library grlib;
library ieee;
use grlib.amba;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.amba.all;
use work.types.all;

entity SysCtl is
	generic(
		pindex : natural;
		paddr : natural range 0 to 16#FFF#;
		pmask : natural range 0 to 16#FFF#);
	port(
		rst : in std_ulogic;
		clk : in std_ulogic;
		apbi : in grlib.amba.apb_slv_in_type;
		apbo : buffer grlib.amba.apb_slv_out_type;
		Clock250kHz : in std_ulogic;
		Clock1MHz : in std_ulogic;
		LogicPower : buffer std_ulogic;
		HVPower : buffer std_ulogic;
		HWInterlockOverride : in std_ulogic;
		Interlock : buffer boolean;
		BreakoutPresent : in std_ulogic;
		RadioLED : buffer std_ulogic;
		TestLEDs : buffer std_ulogic_vector(2 downto 0);
		BatteryVoltage : in mcp3008_t;
		ThermistorVoltage : in mcp3008_t;
		LaserReceiverVoltage : in mcp3008_t;
		LaserDrive : buffer boolean;
		AMBAResetRequest : buffer boolean;
		CPUError : in boolean);
end entity SysCtl;

architecture RTL of SysCtl is
	signal RegIndex : natural range 0 to 6;
	signal DeviceDNAReady : boolean;
	signal DeviceDNAValue : std_ulogic_vector(54 downto 0);
	signal TSC : unsigned(31 downto 0);
	signal TwoSecondBlink : boolean;
	signal LaserDiff : laser_diff_t;
begin
	-- Handle APB constants
	apbo.pconfig <= (
		0 => grlib.amba.ahb_device_reg(VENDOR_ID_THUNDERBOTS, DEVICE_ID_SYSCTL, 0, 0, 0),
		1 => grlib.amba.apb_iobar(paddr, pmask));
	apbo.pindex <= pindex;
	apbo.pirq <= (others => '0');

	-- Decode APB register index
	RegIndex <= to_integer(unsigned(apbi.paddr(4 downto 2)));

	-- Handle APB reads
	process(RegIndex, LogicPower, HVPower, HWInterlockOverride, Interlock, BreakoutPresent, RadioLED, TestLEDs, DeviceDNAReady, DeviceDNAValue, TSC, BatteryVoltage, ThermistorVoltage, LaserDiff) is
	begin
		apbo.prdata <= X"00000000";
		case RegIndex is
			when 0 =>
				apbo.prdata(0) <= LogicPower;
				apbo.prdata(1) <= HVPower;
				apbo.prdata(2) <= not HWInterlockOverride;
				apbo.prdata(3) <= to_stdulogic(Interlock);
				apbo.prdata(4) <= BreakoutPresent;
				apbo.prdata(5) <= RadioLED;
				apbo.prdata(8 downto 6) <= std_logic_vector(TestLEDs);
				apbo.prdata(9) <= to_stdulogic(DeviceDNAReady);
			when 1 =>
				apbo.prdata(22 downto 0) <= std_logic_vector(DeviceDNAValue(54 downto 32));
			when 2 =>
				apbo.prdata <= std_logic_vector(DeviceDNAValue(31 downto 0));
			when 3 =>
				apbo.prdata <= std_logic_vector(TSC);
			when 4 =>
				apbo.prdata <= std_logic_vector(to_unsigned(BatteryVoltage.Value, 32));
			when 5 =>
				apbo.prdata <= std_logic_vector(to_unsigned(ThermistorVoltage.Value, 32));
			when 6 =>
				apbo.prdata <= std_logic_vector(to_signed(LaserDiff, 32));
		end case;
	end process;

	-- Handle APB writes
	process(clk) is
	begin
		if rising_edge(clk) then
			if rst = '0' then
				LogicPower <= '1';
				HVPower <= '0';
				RadioLED <= '0';
				TestLEDs <= "000";
				Interlock <= true;
				AMBAResetRequest <= false;
			elsif CPUError then
				LogicPower <= '1';
				HVPower <= '0';
				RadioLED <= '0';
				TestLEDs <= to_stdulogic(TwoSecondBlink) & to_stdulogic(TwoSecondBlink) & to_stdulogic(TwoSecondBlink);
				Interlock <= true;
				AMBAResetRequest <= false;
			else
				if apbi.penable = '1' and apbi.psel(pindex) = '1' and apbi.pwrite = '1' then
					if RegIndex = 0 then
						LogicPower <= apbi.pwdata(0);
						HVPower <= apbi.pwdata(1);
						Interlock <= to_boolean(apbi.pwdata(3));
						RadioLED <= apbi.pwdata(5);
						TestLEDs <= std_ulogic_vector(apbi.pwdata(8 downto 6));
						AMBAResetRequest <= to_boolean(apbi.pwdata(10));
					end if;
				end if;
			end if;
			-- If hardware applies interlocks, software *cannot* remove them.
			if HWInterlockOverride = '0' then
				Interlock <= true;
			end if;
		end if;
	end process;

	-- Instantiate the Device DNA module
	DeviceDNA : entity work.DeviceDNA(RTL)
	port map(
		rst => rst,
		Clock1MHz => Clock1MHz,
		Ready => DeviceDNAReady,
		Value => DeviceDNAValue);

	-- Run the TSC
	process(clk) is
	begin
		if rising_edge(clk) then
			if rst = '0' then
				TSC <= X"00000000";
			else
				TSC <= TSC + 1;
			end if;
		end if;
	end process;

	-- Run a two-second-period blink counter
	process(Clock250kHz) is
		variable Counter : natural range 0 to 249999;
	begin
		if rising_edge(Clock250kHz) then
			if rst = '0' then
				Counter := 0;
				TwoSecondBlink <= false;
			else
				if Counter = 249999 then
					TwoSecondBlink <= not TwoSecondBlink;
				end if;
				Counter := (Counter + 1) mod 250000;
			end if;
		end if;
	end process;

	-- Instantiate the laser control and calculation module
	DeltaLaser : entity work.DeltaLaser(RTL)
	port map(
		Clock => Clock1MHz, -- Must be same clock domain as MCP3008
		Input => LaserReceiverVoltage,
		Difference => LaserDiff,
		Laser => LaserDrive);
end architecture RTL;
