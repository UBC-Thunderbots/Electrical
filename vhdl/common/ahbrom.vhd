library grlib;
library ieee;
library techmap;
use grlib.amba;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use techmap.gencomp;
use work.amba.all;

entity AHBROM is
	generic(
		hindex : natural;
		haddr : natural range 0 to 16#FFF#;
		hmask : natural range 0 to 16#FFF#);
	port(
		rst : in std_ulogic;
		clk : in std_ulogic;
		ahbsi : in grlib.amba.ahb_slv_in_type;
		ahbso : out grlib.amba.ahb_slv_out_type);
end entity AHBROM;

architecture RTL of AHBROM is
	signal EnableROM : std_ulogic;
	signal ExtraResponseCycle : boolean := false;
begin
	ahbso.hconfig <= (
		0 => grlib.amba.ahb_device_reg(VENDOR_ID_THUNDERBOTS, DEVICE_ID_AHBROM, 0, 0, 0),
		4 => grlib.amba.ahb_membar(haddr, '1', '1', hmask),
		others => (others => '0'));
	ahbso.hindex <= hindex;

	EnableROM <= ahbsi.hsel(hindex) and ahbsi.hready;

	ROM : techmap.gencomp.syncram
	generic map(
		tech => techmap.gencomp.spartan6,
		abits => 9,
		dbits => 32,
		testen => 0)
	port map(
		clk => clk,
		address => ahbsi.haddr(10 downto 2),
		datain => (others => '0'),
		dataout => ahbso.hrdata,
		enable => EnableROM,
		write => '0',
		testin => (others => '0'));

	process(clk) is
	begin
		if rising_edge(clk) then
			if rst = '0' then
				ExtraResponseCycle <= false;
			else
				if ExtraResponseCycle then
					ahbso.hready <= '1';
					ExtraResponseCycle <= false;
				else
					ahbso.hresp <= "00";
					ahbso.hready <= '1';
					if ahbsi.hsel(hindex) = '1' and ahbsi.hready = '1' and ahbsi.htrans(1) = '1' then
						if ahbsi.hwrite = '1' then
							ahbso.hresp <= "01";
							ahbso.hready <= '0';
							ExtraResponseCycle <= true;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;
end architecture RTL;
