library grlib;
library ieee;
library work;
use grlib.amba;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.amba.all;
use work.types.all;

entity Chicker is
	generic(
		pindex : in natural;
		paddr : in natural range 0 to 16#FFF#;
		pmask : in natural range 0 to 16#FFF#);
	port(
		rst : in std_ulogic;
		clk : in std_ulogic;
		apbi : in grlib.amba.apb_slv_in_type;
		apbo : buffer grlib.amba.apb_slv_out_type;
		DischargeCE : in boolean;
		Present : in boolean;
		BatteryVoltage : in mcp3008_t;
		CapacitorVoltage : in mcp3008_t;
		ChargerClock : in std_ulogic;
		Interlock : in boolean;
		ChargedLED : buffer boolean;
		ChargePin : buffer boolean;
		KickPin : buffer boolean;
		ChipPin : buffer boolean);
end entity Chicker;

architecture RTL of Chicker is
	-- Constants
	constant CapacitorDangerousThreshold : natural := natural(30.0 / (220000.0 + 2200.0) * 2200.0 / 3.3 * 1023.0);
	constant CapacitorStopDischargeThreshold : natural := natural(20.0 / (220000.0 + 2200.0) * 2200.0 / 3.3 * 1023.0);

	-- Signals between the APB module and the boost controller module
	signal ChargeEnable, ChargeDone, ChargeTimeout : boolean;

	-- Signals betwene the APB module and the discharge module
	signal DischargeEnable : boolean;
	signal Kick, Chip : boolean;

	-- Signals used internally in the APB/firing module
	signal RegisterNumber : natural range 0 to 2;
	signal PulseWidth : unsigned(15 downto 0);

	-- Signals used internally in the discharge module
	subtype discharge_counter_t is natural range 0 to 5119;
	signal DischargeCounter : discharge_counter_t;
	signal DischargePulse : boolean;
begin
	-- Handle APB constants
	apbo.pconfig <= (
		0 => grlib.amba.ahb_device_reg(VENDOR_ID_THUNDERBOTS, DEVICE_ID_CHICKER, 0, 0, 0),
		1 => grlib.amba.apb_iobar(paddr, pmask));
	apbo.pindex <= pindex;
	apbo.pirq <= (others => '0');

	-- Decode a register number from an APB address
	RegisterNumber <= to_integer(unsigned(apbi.paddr(3 downto 2)));

	-- Handle APB reads
	process(RegisterNumber, ChargeEnable, DischargeEnable, ChargeDone, ChargeTimeout, Kick, Chip, Present, CapacitorVoltage, PulseWidth) is
	begin
		apbo.prdata <= X"00000000";
		case RegisterNumber is
			when 0 =>
				apbo.prdata(0) <= to_stdulogic(ChargeEnable);
				apbo.prdata(1) <= to_stdulogic(DischargeEnable);
				apbo.prdata(2) <= to_stdulogic(ChargeDone);
				apbo.prdata(3) <= to_stdulogic(ChargeTimeout);
				apbo.prdata(4) <= to_stdulogic(Kick);
				apbo.prdata(5) <= to_stdulogic(Chip);
				apbo.prdata(6) <= to_stdulogic(Present);

			when 1 =>
				apbo.prdata <= std_logic_vector(to_unsigned(CapacitorVoltage.Value, 32));

			when 2 =>
				apbo.prdata <= X"0000" & std_logic_vector(PulseWidth);
		end case;
	end process;

	-- Handle APB writes and solenoid firing
	process(clk) is
	begin
		if rising_edge(clk) then
			if rst = '0' then
				Kick <= false;
				Chip <= false;
				ChargeEnable <= false;
				DischargeEnable <= true;
				PulseWidth <= X"0000";
			else
				-- Handle APB writes
				if apbi.penable = '1' and apbi.psel(pindex) = '1' and apbi.pwrite = '1' then
					case RegisterNumber is
						when 0 =>
							ChargeEnable <= to_boolean(apbi.pwdata(0));
							DischargeEnable <= to_boolean(apbi.pwdata(1));
							Kick <= to_boolean(apbi.pwdata(4));
							Chip <= to_boolean(apbi.pwdata(5));

						when 1 =>
							null;

						when 2 =>
							PulseWidth <= unsigned(apbi.pwdata(15 downto 0));
					end case;
				end if;

				-- Prevent charging and discharging simultaneously, if interlocks are applied
				if Interlock and DischargeEnable then
					ChargeEnable <= false;
				end if;

				if DischargeCE then
					-- If pulse width is zero, kick or chip is finished; otherwise, decrement pulse width
					if PulseWidth = X"00000000" then
						Kick <= false;
						Chip <= false;
					elsif Kick or Chip then
						PulseWidth <= PulseWidth - 1;
					end if;
				end if;
			end if;
		end if;
	end process;

	-- Run discharge and assemble final kick/chip pin signals
	DischargeCounter <= (DischargeCounter + 1) mod (discharge_counter_t'high + 1) when rising_edge(clk) and DischargeCE;
	DischargePulse <= DischargeCounter < 128 and CapacitorVoltage.Value > CapacitorStopDischargeThreshold;
	KickPin <= Kick or (DischargePulse and DischargeEnable);
	ChipPin <= Chip or (DischargePulse and DischargeEnable);

	-- Instantiate the boost controller
	BoostController : entity work.BoostController(RTL)
	generic map(
		ClockFrequency => 4000000.0)
	port map(
		Clock => ChargerClock,
		Enable => ChargeEnable,
		CapacitorVoltage => CapacitorVoltage.Value,
		BatteryVoltage => BatteryVoltage.Value,
		Charge => ChargePin,
		Timeout => ChargeTimeout,
		Activity => open,
		Done => ChargeDone);

	-- Control the LED
	ChargedLED <= CapacitorVoltage.Value > CapacitorDangerousThreshold;
end architecture RTL;
