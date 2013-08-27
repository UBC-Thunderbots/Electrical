library ieee;
library work;
use ieee.std_logic_1164.all;
use work.types.all;

entity DeltaLaser is 
	port( 
		Clock : in std_ulogic;
		Input : in mcp3008_t;
		Difference : buffer laser_diff_t;
		Laser : buffer boolean);
end entity DeltaLaser;

architecture RTL of DeltaLaser is 
	signal LaserState : boolean := false;
	signal OffValue : mcp3008_value_t;
	signal OnValue : mcp3008_value_t; 
begin
	Laser <= LaserState;
	process(Clock) is
	begin
		if rising_edge(Clock) and Input.Strobe then
			-- If laser is on, take a reading and set it to off
			if LaserState then
				OnValue <= Input.Value;
				LaserState <= false;
			-- If laser is off, take a reading and set it to on
			else
				OffValue <= Input.Value;
				LaserState <= true;
			end if;
		end if;
	end process;
	Difference <= OffValue - OnValue;
end architecture RTL;
