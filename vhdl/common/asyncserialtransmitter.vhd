library grlib;
library ieee;
use grlib.amba;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.amba.all;
use work.types.all;

entity AsyncSerialTransmitter is
	generic(
		pindex : natural;
		paddr : natural range 0 to 16#FFF#;
		pmask : natural range 0 to 16#FFF#);
	port(
		rst : in std_ulogic;
		clk : in std_ulogic;
		apbi : in grlib.amba.apb_slv_in_type;
		apbo : buffer grlib.amba.apb_slv_out_type;
		BusClock : in std_ulogic;
		Enabled : buffer boolean;
		Output : buffer std_ulogic);
end entity AsyncSerialTransmitter;

architecture RTL of AsyncSerialTransmitter is
	signal RegisterNumber : natural range 0 to 1;
	signal Busy : boolean := false;
	signal StrobeX : boolean := false;
	signal StrobeY : boolean := false;
	signal NewData : std_ulogic_vector(7 downto 0);
	signal Shifter : std_ulogic_vector(8 downto 0);
	signal Counter : natural range 0 to 11;
begin
	-- Handle APB constants
	apbo.pconfig <= (
		0 => grlib.amba.ahb_device_reg(VENDOR_ID_THUNDERBOTS, DEVICE_ID_DEBUGPORT, 0, 0, 0),
		1 => grlib.amba.apb_iobar(paddr, pmask));
	apbo.pindex <= pindex;
	apbo.pirq <= (others => '0');

	-- Decode a register number from an APB address
	RegisterNumber <= to_integer(unsigned(apbi.paddr(2 downto 2)));

	-- Handle APB reads
	process(RegisterNumber, Enabled, Busy) is
	begin
		apbo.prdata <= X"00000000";
		apbo.prdata(0) <= to_stdulogic(Enabled);
		apbo.prdata(1) <= to_stdulogic(Busy);
	end process;

	-- Handle APB writes
	process(clk) is
	begin
		if rising_edge(clk) then
			if rst = '0' then
				Enabled <= false;
				StrobeX <= StrobeY;
			else
				if apbi.penable = '1' and apbi.psel(pindex) = '1' and apbi.pwrite = '1' then
					if RegisterNumber = 0 then
						Enabled <= to_boolean(apbi.pwdata(0));
					elsif RegisterNumber = 1 then
						NewData <= std_ulogic_vector(apbi.pwdata(7 downto 0));
						StrobeX <= not StrobeY;
					end if;
				end if;
			end if;
		end if;
	end process;

	-- Run the transmitter
	process(BusClock) is
	begin
		if rising_edge(BusClock) then
			if StrobeX /= StrobeY then
				Shifter <= NewData & '0';
				Counter <= 11;
				StrobeY <= StrobeX;
			else
				if Counter /= 0 then
					Counter <= Counter - 1;
				end if;
				Shifter <= '1' & Shifter(8 downto 1);
			end if;
		end if;
	end process;

	Busy <= StrobeX /= StrobeY or Counter /= 0;
	Output <= Shifter(0);
end architecture RTL;
