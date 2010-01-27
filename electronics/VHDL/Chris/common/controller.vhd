library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Types.all;

--
-- Implements the control logic.
--
-- This is implemented as a state machine that iterates through a number of states.
-- Each state selects 3 variables, associates them with 3 coefficients, multiplies
-- the coefficients by the variables, adds the products, and stores the result into
-- a variable.
--
-- The states are:
-- (1) Multiplying Error1, Integral1, Derivative1 by PID1 coeffs to get Motor1
-- (2) Multiplying Error2, Integral2, Derivative2 by PID2 coeffs to get Motor2
-- (3) Multiplying Error3, Integral3, Derivative3 by PID3 coeffs to get Motor3
-- (4) Multiplying Error4, Integral4, Derivative4 by PID4 coeffs to get Motor4
--
-- The states are pushed through a four-layer-deep pipeline with the following stages:
-- (1) The address of the state's coefficients is being presented on the ROM Address buses.
-- (2) The ROMs have latched the coefficients onto their outputs and the variables are
--     being routed into the multipliers.
-- (3) The multipliers' input latches have latched the coefficients and variable values and
--     the multipliers are multiplying.
-- (4) The multipliers' output latches have latched the products and the adders are adding.
--
-- At the rising_edge(Clock100) marking the end of the time period when a state is in stage
-- 4, the adders have finished adding and the completed sum-of-products, presented at the
-- output of the MAdd, is latched into the appropriate destination variable.
--
entity Controller is
	port(
		Clock1 : in std_ulogic;
		Clock100 : in std_ulogic;

		ControlledDriveFlag : in std_ulogic;

		Drive1 : in signed(10 downto 0);
		Drive2 : in signed(10 downto 0);
		Drive3 : in signed(10 downto 0);
		Drive4 : in signed(10 downto 0);

		Encoder1 : in signed(10 downto 0);
		Encoder2 : in signed(10 downto 0);
		Encoder3 : in signed(10 downto 0);
		Encoder4 : in signed(10 downto 0);

		Motor1 : out signed(10 downto 0);
		Motor2 : out signed(10 downto 0);
		Motor3 : out signed(10 downto 0);
		Motor4 : out signed(10 downto 0)
	);
end entity Controller;

architecture Behavioural of Controller is
	signal ROMAddress : natural range 0 to 3;
	signal Coeff1 : std_ulogic_vector(17 downto 0);
	signal Coeff2 : std_ulogic_vector(17 downto 0);
	signal Coeff3 : std_ulogic_vector(17 downto 0);
	signal Var1 : signed(17 downto 0);
	signal Var2 : signed(17 downto 0);
	signal Var3 : signed(17 downto 0);
	signal Prod : signed(35 downto 0);

	signal NewError1 : signed(10 downto 0);
	signal NewError2 : signed(10 downto 0);
	signal NewError3 : signed(10 downto 0);
	signal NewError4 : signed(10 downto 0);

	signal Error1 : signed(10 downto 0) := to_signed(0, 11);
	signal Error2 : signed(10 downto 0) := to_signed(0, 11);
	signal Error3 : signed(10 downto 0) := to_signed(0, 11);
	signal Error4 : signed(10 downto 0) := to_signed(0, 11);

	signal NewIntegral1 : signed(10 downto 0);
	signal NewIntegral2 : signed(10 downto 0);
	signal NewIntegral3 : signed(10 downto 0);
	signal NewIntegral4 : signed(10 downto 0);

	signal Integral1 : signed(10 downto 0) := to_signed(0, 11);
	signal Integral2 : signed(10 downto 0) := to_signed(0, 11);
	signal Integral3 : signed(10 downto 0) := to_signed(0, 11);
	signal Integral4 : signed(10 downto 0) := to_signed(0, 11);

	signal LastError1 : signed(10 downto 0) := to_signed(0, 11);
	signal LastError2 : signed(10 downto 0) := to_signed(0, 11);
	signal LastError3 : signed(10 downto 0) := to_signed(0, 11);
	signal LastError4 : signed(10 downto 0) := to_signed(0, 11);

	signal Derivative1 : signed(10 downto 0);
	signal Derivative2 : signed(10 downto 0);
	signal Derivative3 : signed(10 downto 0);
	signal Derivative4 : signed(10 downto 0);

	type StateType is (PID1, PID2, PID3, PID4);
	pure function NextState(State : StateType) return StateType is
	begin
		if State = PID1 then
			return PID2;
		elsif State = PID2 then
			return PID3;
		elsif State = PID3 then
			return PID4;
		else
			return PID1;
		end if;
	end function NextState;

	signal LatchOutputState : StateType := PID1;
	signal MuxInputState : StateType;
	signal ROMAddressState : StateType;
	signal PIDTicks : natural range 0 to 4999 := 1;
begin
	-- If some state is latched in the output of the multipliers, then the next state must be
	-- latched in the input of the multipliers and be being multiplied right now. But we don't
	-- actually care to know this state, so don't keep it in a signal.

	-- If some state is latched in the input of the multipliers, then the next state's variables
	-- should be being routed into the latches for capture on the next clock edge.
	MuxInputState <= NextState(NextState(LatchOutputState));

	-- If some state's variables and coefficients are being routed into the multipliers, then the
	-- coefficients for that state are in the output latches of the ROMs. The ROMs' address inputs
	-- should be seeing the address for the next state, so that on the next rising edge, the data
	-- at that address will appear on the ROM outputs.
	ROMAddressState <= NextState(NextState(NextState(LatchOutputState)));

	MAddInstance : entity work.MAdd(Behavioural)
	port map(
		Clock => Clock100,
		A => signed(Coeff1),
		B => signed(Coeff2),
		C => signed(Coeff3),
		X => Var1,
		Y => Var2,
		Z => Var3,
		Prod => Prod
	);
	Coeffs1 : entity work.ROM(Behavioural)
	generic map(
		InitData =>
		(
			-- Proportional coefficients for motors 1, 2, 3, 4.
			std_ulogic_vector(to_signed(1, 18)),
			std_ulogic_vector(to_signed(1, 18)),
			std_ulogic_vector(to_signed(1, 18)),
			std_ulogic_vector(to_signed(1, 18))
		)
	)
	port map(
		Clock => Clock100,
		Address => ROMAddress,
		Data => Coeff1
	);
	Coeffs2 : entity work.ROM(Behavioural)
	generic map(
		InitData =>
		(
			-- Integral coefficients for motors 1, 2, 3, 4.
			std_ulogic_vector(to_signed(0, 18)),
			std_ulogic_vector(to_signed(0, 18)),
			std_ulogic_vector(to_signed(0, 18)),
			std_ulogic_vector(to_signed(0, 18))
		)
	)
	port map(
		Clock => Clock100,
		Address => ROMAddress,
		Data => Coeff2
	);
	Coeffs3 : entity work.ROM(Behavioural)
	generic map(
		InitData =>
		(
			-- Derivative coefficients for motors 1, 2, 3, 4.
			std_ulogic_vector(to_signed(0, 18)),
			std_ulogic_vector(to_signed(0, 18)),
			std_ulogic_vector(to_signed(0, 18)),
			std_ulogic_vector(to_signed(0, 18))
		)
	)
	port map(
		Clock => Clock100,
		Address => ROMAddress,
		Data => Coeff3
	);

	-- Depending on the state, we must select the proper address for the ROMs.
	ROMAddress <=
		     0 when ROMAddressState = PID1
		else 1 when ROMAddressState = PID2
		else 2 when ROMAddressState = PID3
		else 3 when ROMAddressState = PID4;

	-- Depending on the state, we must select the proper inputs to the MAdd.
	process(MuxInputState, Error1, Error2, Error3, Error4, Integral1, Integral2, Integral3, Integral4, Derivative1, Derivative2, Derivative3, Derivative4)
	begin
		if MuxInputState = PID1 then
			Var1 <= resize(Error1, Var1'length);
			Var2 <= resize(Integral1, Var2'length);
			Var3 <= resize(Derivative1, Var3'length);
		elsif MuxInputState = PID2 then
			Var1 <= resize(Error2, Var1'length);
			Var2 <= resize(Integral2, Var2'length);
			Var3 <= resize(Derivative2, Var3'length);
		elsif MuxInputState = PID3 then
			Var1 <= resize(Error3, Var1'length);
			Var2 <= resize(Integral3, Var2'length);
			Var3 <= resize(Derivative3, Var3'length);
		elsif MuxInputState = PID4 then
			Var1 <= resize(Error4, Var1'length);
			Var2 <= resize(Integral4, Var2'length);
			Var3 <= resize(Derivative4, Var3'length);
		end if;
	end process;

	-- On a clock edge, capture the computed output and advance the state variable.
	-- This is where you should change which bits out of the product are kept for
	-- each state.
	process(Clock100)
	begin
		if rising_edge(Clock100) then
			if LatchOutputState = PID1 then
				Motor1 <= Prod(10 downto 0);
			elsif LatchOutputState = PID2 then
				Motor2 <= Prod(10 downto 0);
			elsif LatchOutputState = PID3 then
				Motor3 <= Prod(10 downto 0);
			elsif LatchOutputState = PID4 then
				Motor4 <= Prod(10 downto 0);
			end if;
			LatchOutputState <= NextState(LatchOutputState);
		end if;
	end process;

	-- NewError is computed combinationally from setpoint and plant values.
	-- NewError is injected into Error on each PID cycle.
	SSubNewError : entity work.SharedSaturatingSubtracter(Behavioural)
	generic map(
		Width => 11
	)
	port map(
		Clock => Clock1,
		X1 => Drive1,
		Y1 => Encoder1,
		Difference1 => NewError1,
		X2 => Drive2,
		Y2 => Encoder2,
		Difference2 => NewError2,
		X3 => Drive3,
		Y3 => Encoder3,
		Difference3 => NewError3,
		X4 => Drive4,
		Y4 => Encoder4,
		Difference4 => NewError4
	);

	-- NewIntegral is computed combinationally from Integral and Error values.
	-- NewIntegral is injected into Integral on each PID cycle.
	SAddNewIntegral : entity work.SharedSaturatingAdder(Behavioural)
	generic map(
		Width => 11
	)
	port map(
		Clock => Clock1,
		X1 => Integral1,
		Y1 => Error1,
		Sum1 => NewIntegral1,
		X2 => Integral2,
		Y2 => Error2,
		Sum2 => NewIntegral2,
		X3 => Integral3,
		Y3 => Error3,
		Sum3 => NewIntegral3,
		X4 => Integral4,
		Y4 => Error4,
		Sum4 => NewIntegral4
	);

	-- Derivative is computed combinationally from Error and LastError.
	-- Error is injected into LastError on each PID cycle.
	SSubDerivative : entity work.SharedSaturatingSubtracter(Behavioural)
	generic map(
		Width => 11
	)
	port map(
		Clock => Clock1,
		X1 => Error1,
		Y1 => LastError1,
		Difference1 => Derivative1,
		X2 => Error2,
		Y2 => LastError2,
		Difference2 => Derivative2,
		X3 => Error3,
		Y3 => LastError3,
		Difference3 => Derivative3,
		X4 => Error4,
		Y4 => LastError4,
		Difference4 => Derivative4
	);

	-- Iterate the PID loops. All we really have to do here is advance the variables
	-- over a timestep; everything else is done "combinationally" as far as we are
	-- concerned (that is, sequentially but very fast).
	process(Clock1)
	begin
		if rising_edge(Clock1) then
			if PIDTicks = 0 then
				LastError1 <= Error1;
				LastError2 <= Error2;
				LastError3 <= Error3;
				LastError4 <= Error4;
				Error1 <= NewError1;
				Error2 <= NewError2;
				Error3 <= NewError3;
				Error4 <= NewError4;
				Integral1 <= NewIntegral1;
				Integral2 <= NewIntegral2;
				Integral3 <= NewIntegral3;
				Integral4 <= NewIntegral4;
			end if;
			PIDTicks <= (PIDTicks + 1) mod 5000;
		end if;
	end process;
end architecture Behavioural;
