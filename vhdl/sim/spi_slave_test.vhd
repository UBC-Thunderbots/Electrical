library ieee;
use ieee.std_logic_1164.all;

library work;
use work.types.all;

entity spi_slave_test is
end entity;

architecture tester of spi_slave_test is
	constant HostPeriod : time := 12.5 ns;
	constant BusPeriod : time := 23.81 ns;
	type data_vector_t is array(0 to 15) of spi_word_t;
	constant XmitData : data_vector_t := (X"13", X"5E", X"36", X"32", X"5B", X"5A", X"A3", X"B0", X"7F", X"DB", X"FF", X"80", X"BC", X"80", X"F1", X"32");

	signal Stop : std_ulogic := '0';

	signal HostClock : std_ulogic; --probably 80Mhz
	signal BusClock : std_ulogic; --probably 42Mhz
	signal CSLine : std_ulogic := '1';
	signal Input : spi_input_t;
	signal Output : spi_output_t;

	signal Xover : std_ulogic;
	
	signal ReadData : spi_word_t;
	signal ReadStrobe : boolean;
	signal ReadCRCOk : boolean;
	signal ReadFirst : boolean;

	signal begin_transfer : boolean := false;
begin

	ReadData <= Input.ReadData;
	ReadStrobe <= Input.ReadStrobe;
	ReadCRCOk <= Input.ReadCRCOk;
	ReadFirst <= Input.ReadFirst;

	tranceiver: entity work.SPIslave
		port map(
		HostClock=>HostClock,
		BusClock=>BusClock,
		CSLine => CSLine,
		Input => Input,
		Output => Output,
		MOSIPin => Xover,
		MISOPin => Xover);

		host_clock: process
			variable host_clock_count : natural := 0;
		begin
			if(host_clock_count = 100) then
				begin_transfer <= true;
			end if;
			HostClock <= '1';
			wait for HostPeriod / 2;
			HostClock <= '0';
			wait for HostPeriod / 2;
			host_clock_count := host_clock_count + 1;
			if(host_clock_count > 1000) then
				wait;
			end if;
		end process;

		bus_clock: process
			variable bus_clock_count : natural := 0;
		begin
			CSLine <='1';
			BusClock <= '0';
			while(not begin_transfer) loop
				wait on begin_transfer;
			end loop;
			CSLine <= '0';
			while(CSLine = '1') loop
				wait for BusPeriod;
			end loop;
			bus_clock_count := bus_clock_count + 1;
			BusClock <= '1';
			wait for BusPeriod / 2;
			BusClock <= '0';
			wait for BusPeriod / 2;
			if(bus_clock_count = spi_word_t'length * (data_vector_t'length + 2)) then
				wait for BusPeriod;
				CSLine <= '1';
				wait;
			end if;
		end process;

		host_process: process(HostClock)
			variable writing : boolean := false;
			variable data_count : natural :=0;
		begin
			if(rising_edge(HostClock)) then
				Output.WriteStrobe <= false;
				if Input.ReadStrobe and Input.ReadFirst then
					writing := true;
				end if;

				if(Input.WriteReady = true) and writing then
					if(data_count < 16 ) then
						Output.WriteData <= XmitData(data_count);
						Output.WriteStrobe <= true;
					elsif(data_count = 16) then
						Output.WriteCRC <= true;
						Output.WriteStrobe <= true;
					end if;
					data_count := data_count + 1;
				end if;
			end if;
		end process;


end architecture;
