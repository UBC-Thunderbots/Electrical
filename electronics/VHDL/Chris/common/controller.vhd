library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller is
	port(
		Clock : in std_ulogic;

		DirectDriveFlag : in std_ulogic;
		Drive1 : in signed(15 downto 0);
		Drive2 : in signed(15 downto 0);
		Drive3 : in signed(15 downto 0);
		Drive4 : in signed(15 downto 0);

		DutyCycle1 : out unsigned(9 downto 0);
		DutyCycle2 : out unsigned(9 downto 0);
		DutyCycle3 : out unsigned(9 downto 0);
		DutyCycle4 : out unsigned(9 downto 0);

		Direction1 : out std_ulogic;
		Direction2 : out std_ulogic;
		Direction3 : out std_ulogic;
		Direction4 : out std_ulogic
	);
end entity Controller;

architecture Behavioural of Controller is
	signal PWM1 : signed(10 downto 0);
	signal PWM2 : signed(10 downto 0);
	signal PWM3 : signed(10 downto 0);
	signal PWM4 : signed(10 downto 0);
begin
	SM1 : entity work.SignMagnitude(Behavioural)
	generic map(
		Width => 11
	)
	port map(
		Value => PWM1,
		Absolute => DutyCycle1,
		Sign => Direction1
	);
	SM2 : entity work.SignMagnitude(Behavioural)
	generic map(
		Width => 11
	)
	port map(
		Value => PWM2,
		Absolute => DutyCycle2,
		Sign => Direction2
	);
	SM3 : entity work.SignMagnitude(Behavioural)
	generic map(
		Width => 11
	)
	port map(
		Value => PWM3,
		Absolute => DutyCycle3,
		Sign => Direction3
	);
	SM4 : entity work.SignMagnitude(Behavioural)
	generic map(
		Width => 11
	)
	port map(
		Value => PWM4,
		Absolute => DutyCycle4,
		Sign => Direction4
	);

	process(DirectDriveFlag, Drive1, Drive2, Drive3, Drive4)
	begin
		if DirectDriveFlag = '1' then
			PWM1 <= Drive1(10 downto 0);
			PWM2 <= Drive2(10 downto 0);
			PWM3 <= Drive3(10 downto 0);
			PWM4 <= Drive4(10 downto 0);
		else
			PWM1 <= to_signed(0, 11);
			PWM2 <= to_signed(0, 11);
			PWM3 <= to_signed(0, 11);
			PWM4 <= to_signed(0, 11);
		end if;
	end process;
end architecture Behavioural;
