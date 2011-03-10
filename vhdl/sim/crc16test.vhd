library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.crc16.all;

entity CRC16Test is
end entity;

architecture Behavioural of CRC16Test is
	subtype crc_t is std_ulogic_vector(15 downto 0);
	subtype data_t is std_ulogic_vector(7 downto 0);

	type ccitt_table_t is array(0 to 255) of std_ulogic_vector(15 downto 0);

	constant CCITTTable : ccitt_table_t := (
		X"0000", X"1189", X"2312", X"329b", X"4624", X"57ad", X"6536", X"74bf",
		X"8c48", X"9dc1", X"af5a", X"bed3", X"ca6c", X"dbe5", X"e97e", X"f8f7",
		X"1081", X"0108", X"3393", X"221a", X"56a5", X"472c", X"75b7", X"643e",
		X"9cc9", X"8d40", X"bfdb", X"ae52", X"daed", X"cb64", X"f9ff", X"e876",
		X"2102", X"308b", X"0210", X"1399", X"6726", X"76af", X"4434", X"55bd",
		X"ad4a", X"bcc3", X"8e58", X"9fd1", X"eb6e", X"fae7", X"c87c", X"d9f5",
		X"3183", X"200a", X"1291", X"0318", X"77a7", X"662e", X"54b5", X"453c",
		X"bdcb", X"ac42", X"9ed9", X"8f50", X"fbef", X"ea66", X"d8fd", X"c974",
		X"4204", X"538d", X"6116", X"709f", X"0420", X"15a9", X"2732", X"36bb",
		X"ce4c", X"dfc5", X"ed5e", X"fcd7", X"8868", X"99e1", X"ab7a", X"baf3",
		X"5285", X"430c", X"7197", X"601e", X"14a1", X"0528", X"37b3", X"263a",
		X"decd", X"cf44", X"fddf", X"ec56", X"98e9", X"8960", X"bbfb", X"aa72",
		X"6306", X"728f", X"4014", X"519d", X"2522", X"34ab", X"0630", X"17b9",
		X"ef4e", X"fec7", X"cc5c", X"ddd5", X"a96a", X"b8e3", X"8a78", X"9bf1",
		X"7387", X"620e", X"5095", X"411c", X"35a3", X"242a", X"16b1", X"0738",
		X"ffcf", X"ee46", X"dcdd", X"cd54", X"b9eb", X"a862", X"9af9", X"8b70",
		X"8408", X"9581", X"a71a", X"b693", X"c22c", X"d3a5", X"e13e", X"f0b7",
		X"0840", X"19c9", X"2b52", X"3adb", X"4e64", X"5fed", X"6d76", X"7cff",
		X"9489", X"8500", X"b79b", X"a612", X"d2ad", X"c324", X"f1bf", X"e036",
		X"18c1", X"0948", X"3bd3", X"2a5a", X"5ee5", X"4f6c", X"7df7", X"6c7e",
		X"a50a", X"b483", X"8618", X"9791", X"e32e", X"f2a7", X"c03c", X"d1b5",
		X"2942", X"38cb", X"0a50", X"1bd9", X"6f66", X"7eef", X"4c74", X"5dfd",
		X"b58b", X"a402", X"9699", X"8710", X"f3af", X"e226", X"d0bd", X"c134",
		X"39c3", X"284a", X"1ad1", X"0b58", X"7fe7", X"6e6e", X"5cf5", X"4d7c",
		X"c60c", X"d785", X"e51e", X"f497", X"8028", X"91a1", X"a33a", X"b2b3",
		X"4a44", X"5bcd", X"6956", X"78df", X"0c60", X"1de9", X"2f72", X"3efb",
		X"d68d", X"c704", X"f59f", X"e416", X"90a9", X"8120", X"b3bb", X"a232",
		X"5ac5", X"4b4c", X"79d7", X"685e", X"1ce1", X"0d68", X"3ff3", X"2e7a",
		X"e70e", X"f687", X"c41c", X"d595", X"a12a", X"b0a3", X"8238", X"93b1",
		X"6b46", X"7acf", X"4854", X"59dd", X"2d62", X"3ceb", X"0e70", X"1ff9",
		X"f78f", X"e606", X"d49d", X"c514", X"b1ab", X"a022", X"92b9", X"8330",
		X"7bc7", X"6a4e", X"58d5", X"495c", X"3de3", X"2c6a", X"1ef1", X"0f78");

	function LinuxCRC(CRC : crc_t; Data : data_t) return crc_t is
	begin
		return (X"00" & CRC(15 downto 8)) xor CCITTTable(to_integer(unsigned(CRC(7 downto 0) xor Data)));
	end function LinuxCRC;
begin
	process
		variable CRCU : std_ulogic_vector(15 downto 0);
		variable DataU : std_ulogic_vector(7 downto 0);
	begin
		for CRC in 0 to 65535 loop
			for Data in 0 to 255 loop
				CRCU := std_ulogic_vector(to_unsigned(CRC, 16));
				DataU := std_ulogic_vector(to_unsigned(Data, 8));
				assert LinuxCRC(CRCU, DataU) = CRC16(CRCU, DataU) severity failure;
			end loop;
		end loop;
		wait;
	end process;
end architecture Behavioural;
