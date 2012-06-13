library ieee;
library unisim;

use ieee.std_logic_1164.all;
use unisim.vcomponents.all;

entity device_id is
	port(
		signal Clock4Mhz : in std_ulogic;
		signal Value : out std_ulogic_vector(56 downto 0)
	);
end entity;

architecture behav of device_id is
	signal clk : std_ulogic := '0';
	type state_t is (INIT,LOAD,SHIFTING,HOLD);
	signal state : state_t := LOAD;
	signal device_value : std_ulogic_vector(56 downto 0) := (others => '0');
	signal data_out : std_ulogic;
	signal read : std_ulogic := '0';
	signal shift : std_ulogic := '0';
begin

	Value <= device_value;

	--max internal clock 2 Mhz
	process(Clock4Mhz)
	begin
		if(rising_edge(Clock4Mhz)) then
			clk <= not clk;
		end if;
	end process;

	process(clk)
	begin
		if(rising_edge(clk)) then
			case state is
				when INIT =>
					read <= '0';
					shift <= '0';
					state <= LOAD;
				when LOAD =>
					read <= '1';
					shift <= '0';
					state <= SHIFTING;
				when SHIFTING =>
					shift <= '1';
					read <= '0';
					if(device_value(56) = '1') then
						state <= HOLD;
					else
						state <= SHIFTING;
						device_value <= device_value(55 downto 0)&data_out;
					end if;
				when HOLD =>
					read <= '0';
					shift <= '0';
					state <= HOLD;
			end case;
		end if;
	end process;

	id_value : DNA_PORT
		port map (
			DOUT => data_out,
			DIN => '0',
			READ => read,
			SHIFT => shift,
			CLK => clk
		);
	
end architecture;
