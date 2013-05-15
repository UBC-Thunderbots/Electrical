library ieee;
library work;
use ieee.std_logic_1164.all;
use work.types.all;
use work.clock.all;

entity DeltaLaser is 
	port( 
		Clock : in clocks_t;
		Input : in mcp3008_t;
		Difference : out laser_diff_t;
		Laser : out boolean);
end entity DeltaLaser;

architecture Arch of DeltaLaser is 
	signal LaserState : boolean := false;
	signal OffValue : mcp3008_value_t;
	signal OnValue : mcp3008_value_t; 
begin
	Laser <= LaserState;
	process(Clock.Clock4MHz) is
	begin
		if rising_edge(Clock.Clock4MHz) and Input.Strobe then
			
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
end architecture Arch;
