library grlib;
library ieee;
use grlib.amba;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.amba.all;
use work.types;

entity Motor is
	generic(
		pindex : natural;
		paddr : natural range 0 to 16#FFF#;
		pmask : natural range 0 to 16#FFF#;
		PWMMax : positive;
		PWMPhase : natural;
		EncoderPresent : boolean);
	port(
		rst : in std_ulogic;
		clk : in std_ulogic;
		apbi : in grlib.amba.apb_slv_in_type;
		apbo : buffer grlib.amba.apb_slv_out_type;
		PWMClock : in std_ulogic;
		Interlock : in boolean;
		Hall : in work.types.hall_t;
		Encoder : in work.types.encoder_t;
		Drive : buffer work.types.motor_drive_phases_t);
end entity Motor;

architecture RTL of Motor is
	-- Signals between the APB module and other modules.
	signal Mode : std_ulogic_vector(1 downto 0);
	signal HallStuckLow, HallStuckHigh, EncoderFailed : boolean;
	signal ManualCommutationPattern : std_ulogic_vector(5 downto 0);
	signal PWMLevel : natural range 0 to PWMMax;
	signal Position : work.types.motor_position_t;

	-- Signals between the motor driving modules.
	signal PWMOutput : boolean;
	signal CommutatorPhases : work.types.motor_commutate_phases_t;

	-- Signals used internally in the APB module.
	signal RegisterNumber : natural range 0 to 4;
	signal HallStuckLowLatch, HallStuckHighLatch, EncoderFailedLatch : boolean;
begin
	-- Handle APB constants
	apbo.pconfig <= (
		0 => grlib.amba.ahb_device_reg(VENDOR_ID_THUNDERBOTS, DEVICE_ID_MOTOR, 0, 0, 0),
		1 => grlib.amba.apb_iobar(paddr, pmask));
	apbo.pindex <= pindex;
	apbo.pirq <= (others => '0');

	-- Decode a register number from an APB address.
	RegisterNumber <= to_integer(unsigned(apbi.paddr(4 downto 2)));

	-- Handle APB reads.
	process(RegisterNumber, Mode, HallStuckLow, HallStuckHigh, EncoderFailed, ManualCommutationPattern, PWMLevel, Position, Hall, Encoder) is
	begin
		apbo.prdata <= X"00000000";
		case RegisterNumber is
			when 0 => -- CSR
				apbo.prdata(1 downto 0) <= std_logic_vector(Mode);
				apbo.prdata(2) <= work.types.to_stdulogic(HallStuckLowLatch);
				apbo.prdata(3) <= work.types.to_stdulogic(HallStuckHighLatch);
				apbo.prdata(4) <= work.types.to_stdulogic(EncoderFailedLatch);
			when 1 => -- Manual commutation pattern
				apbo.prdata(5 downto 0) <= std_logic_vector(ManualCommutationPattern);
			when 2 => -- PWM
				apbo.prdata <= std_logic_vector(to_unsigned(PWMLevel, 32));
			when 3 => -- Position
				apbo.prdata <= std_logic_vector(resize(Position, 32));
			when 4 => -- Hall sensors and optical encoders
				for I in 0 to 2 loop
					apbo.prdata(I) <= work.types.to_stdulogic(Hall(I));
				end loop;
				for I in 0 to 1 loop
					apbo.prdata(3 + I) <= work.types.to_stdulogic(Encoder(I));
				end loop;
		end case;
	end process;

	-- Handle APB writes.
	process(clk) is
	begin
		if rising_edge(clk) then
			if rst = '0' then
				Mode <= "00";
				ManualCommutationPattern <= "000000";
				PWMLevel <= 0;
				HallStuckLowLatch <= false;
				HallStuckHighLatch <= false;
				EncoderFailedLatch <= false;
			elsif apbi.penable = '1' and apbi.psel(pindex) = '1' and apbi.pwrite = '1' then
				case RegisterNumber is
					when 0 => -- CSR
						Mode <= std_ulogic_vector(apbi.pwdata(1 downto 0));
						if apbi.pwdata(5) = '1' then
							HallStuckLowLatch <= false;
							HallStuckHighLatch <= false;
							EncoderFailedLatch <= false;
						end if;
					when 1 => -- Manual commutation pattern
						ManualCommutationPattern <= std_ulogic_vector(apbi.pwdata(5 downto 0));
					when 2 => -- PWM
						PWMLevel <= to_integer(unsigned(apbi.pwdata(7 downto 0)));
					when others => null;
				end case;
			end if;
			if Interlock then
				ManualCommutationPattern <= "000000";
			end if;
			if HallStuckLow then
				HallStuckLowLatch <= true;
			end if;
			if HallStuckHigh then
				HallStuckHighLatch <= true;
			end if;
			if EncoderFailed then
				EncoderFailedLatch <= true;
			end if;
		end if;
	end process;

	-- Decode current speed.
	EncoderGenerate : if EncoderPresent generate
		EncoderEntity : entity work.GrayCounter(RTL)
		port map(
			clk => clk,
			Input => Encoder,
			Value => Position);
		EncoderFail : entity work.EncoderFail(RTL)
		port map(
			rst => rst,
			clk => clk,
			Encoder => Encoder,
			Hall => Hall,
			Fail => EncoderFailed);
	end generate;
	NoEncoderGenerate: if not EncoderPresent generate
		HallSpeed : entity work.HallSpeed(RTL)
		port map(
			clk => clk,
			Hall => Hall,
			Value => Position);
		EncoderFailed <= false;
	end generate;

	-- Generate an automatic commutation pattern given the motor's current position.
	Commutator : entity work.Commutator(RTL)
	port map(
		Direction => work.types.to_boolean(Mode(0)),
		Hall => Hall,
		HallStuckHigh => HallStuckHigh,
		HallStuckLow => HallStuckLow,
		Phase => CommutatorPhases);

	-- Generate a PWM waveform.
	PWMGenerator : entity work.PWM(RTL)
	generic map(
		Max => PWMMax,
		Phase => PWMPhase)
	port map(
		rst => rst,
		clk => PWMClock,
		Value => PWMLevel,
		Output => PWMOutput);

	-- Based on the requested mode, send the appropriate signals to the output.
	process(PWMOutput, Mode, CommutatorPhases, ManualCommutationPattern) is
		variable PWMPhase : work.types.motor_drive_phase_t;
		variable Phases : work.types.motor_commutate_phases_t;
	begin
		-- Transform the PWM signal into a phase value.
		if PWMOutput then
			PWMPhase := work.types.HIGH;
		else
			PWMPhase := work.types.LOW;
		end if;

		-- Choose phases.
		if Mode(1) = '1' then -- Normal commutation
			Phases := CommutatorPhases;
		elsif Mode(0) = '1' then -- Brake
			Phases := (others => work.types.LOW);
		else -- Manual commutation
			for I in 0 to 2 loop
				case ManualCommutationPattern(I * 2 + 1 downto I * 2) is
					when "00" => Phases(I) := work.types.FLOAT;
					when "01" => Phases(I) := work.types.PWM;
					when "10" => Phases(I) := work.types.LOW;
					when others => Phases(I) := work.types.HIGH;
				end case;
			end loop;
		end if;

		-- Generate outputs.
		for I in 0 to 2 loop
			case Phases(I) is
				when work.types.FLOAT => Drive(I) <= work.types.FLOAT;
				when work.types.PWM => Drive(I) <= PWMPhase;
				when work.types.LOW => Drive(I) <= work.types.LOW;
				when work.types.HIGH => Drive(I) <= work.types.HIGH;
			end case;
		end loop;
	end process;
end architecture RTL;
