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
-- (1) Multiplying Vx, Vy, Vt by row 1 of V2M to get Setpoint1 (if in velocities mode)
-- (2) Multiplying Vx, Vy, Vt by row 2 of V2M to get Setpoint2 (if in velocities mode)
-- (3) Multiplying Vx, Vy, Vt by row 3 of V2M to get Setpoint3 (if in velocities mode)
-- (4) Multiplying Vx, Vy, Vt by row 4 of V2M to get Setpoint4 (if in velocities mode)
-- (5) Multiplying Error1, Integral1, Derivative1 by PID1 coeffs to get Motor1
-- (6) Multiplying Error2, Integral2, Derivative2 by PID2 coeffs to get Motor2
-- (7) Multiplying Error3, Integral3, Derivative3 by PID3 coeffs to get Motor3
-- (8) Multiplying Error4, Integral4, Derivative4 by PID4 coeffs to get Motor4
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
		VelocitiesFlag : in std_ulogic;

		Drive1 : in signed(15 downto 0);
		Drive2 : in signed(15 downto 0);
		Drive3 : in signed(15 downto 0);
		Drive4 : in signed(15 downto 0);

		Encoder1 : in signed(9 downto 0);
		Encoder2 : in signed(9 downto 0);
		Encoder3 : in signed(9 downto 0);
		Encoder4 : in signed(9 downto 0);

		Motor1 : out signed(10 downto 0);
		Motor2 : out signed(10 downto 0);
		Motor3 : out signed(10 downto 0);
		Motor4 : out signed(10 downto 0)
	);
end entity Controller;

architecture Behavioural of Controller is
	signal ROMAddress : natural range 0 to 7;
	signal Coeff1Raw : std_ulogic_vector(17 downto 0);
	signal Coeff2Raw : std_ulogic_vector(17 downto 0);
	signal Coeff3Raw : std_ulogic_vector(17 downto 0);

	signal Coeff1 : signed(17 downto 0);
	signal Coeff2 : signed(17 downto 0);
	signal Coeff3 : signed(17 downto 0);
	signal Var1 : signed(17 downto 0);
	signal Var2 : signed(17 downto 0);
	signal Var3 : signed(17 downto 0);
	signal Prod : signed(35 downto 0);

	signal V2MOut1 : signed(9 downto 0) := to_signed(0, 10);
	signal V2MOut2 : signed(9 downto 0) := to_signed(0, 10);
	signal V2MOut3 : signed(9 downto 0) := to_signed(0, 10);
	signal V2MOut4 : signed(9 downto 0) := to_signed(0, 10);

	signal Setpoint1 : signed(9 downto 0);
	signal Setpoint2 : signed(9 downto 0);
	signal Setpoint3 : signed(9 downto 0);
	signal Setpoint4 : signed(9 downto 0);

	signal Error1 : signed(10 downto 0) := to_signed(0, 11);
	signal Error2 : signed(10 downto 0) := to_signed(0, 11);
	signal Error3 : signed(10 downto 0) := to_signed(0, 11);
	signal Error4 : signed(10 downto 0) := to_signed(0, 11);

	signal Integral1 : signed(17 downto 0) := to_signed(0, 18);
	signal Integral2 : signed(17 downto 0) := to_signed(0, 18);
	signal Integral3 : signed(17 downto 0) := to_signed(0, 18);
	signal Integral4 : signed(17 downto 0) := to_signed(0, 18);

	signal LastError1 : signed(10 downto 0) := to_signed(0, 11);
	signal LastError2 : signed(10 downto 0) := to_signed(0, 11);
	signal LastError3 : signed(10 downto 0) := to_signed(0, 11);
	signal LastError4 : signed(10 downto 0) := to_signed(0, 11);

	signal Derivative1 : signed(17 downto 0);
	signal Derivative2 : signed(17 downto 0);
	signal Derivative3 : signed(17 downto 0);
	signal Derivative4 : signed(17 downto 0);

	type StateType is (V2M1, V2M2, V2M3, V2M4, PID1, PID2, PID3, PID4);
	pure function NextState(State : StateType) return StateType is
	begin
		if State = V2M1 then
			return V2M2;
		elsif State = V2M2 then
			return V2M3;
		elsif State = V2M3 then
			return V2M4;
		elsif State = V2M4 then
			return PID1;
		elsif State = PID1 then
			return PID2;
		elsif State = PID2 then
			return PID3;
		elsif State = PID3 then
			return PID4;
		else
			return V2M1;
		end if;
	end function NextState;

	signal LatchOutputState : StateType := V2M1;
	signal MuxInputState : StateType;
	signal ROMAddressState : StateType;
	signal PIDTicks : natural range 0 to 999 := 1;
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
		A => Coeff1,
		B => Coeff2,
		C => Coeff3,
		X => Var1,
		Y => Var2,
		Z => Var3,
		Prod => Prod
	);
	Coeffs1 : entity work.ROM(Behavioural)
	generic map(
		InitData =>
		(
			-- First **column** of V2M matrix.
			std_ulogic_vector(to_signed(1, 18)),
			std_ulogic_vector(to_signed(0, 18)),
			std_ulogic_vector(to_signed(0, 18)),
			std_ulogic_vector(to_signed(0, 18)),
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
		Data => Coeff1Raw
	);
	Coeffs2 : entity work.ROM(Behavioural)
	generic map(
		InitData =>
		(
			-- Second **column** of V2M matrix.
			std_ulogic_vector(to_signed(0, 18)),
			std_ulogic_vector(to_signed(1, 18)),
			std_ulogic_vector(to_signed(0, 18)),
			std_ulogic_vector(to_signed(0, 18)),
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
		Data => Coeff2Raw
	);
	Coeffs3 : entity work.ROM(Behavioural)
	generic map(
		InitData =>
		(
			-- Third **column** of V2M matrix.
			std_ulogic_vector(to_signed(0, 18)),
			std_ulogic_vector(to_signed(0, 18)),
			std_ulogic_vector(to_signed(1, 18)),
			std_ulogic_vector(to_signed(0, 18)),
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
		Data => Coeff3Raw
	);
	Coeff1 <= signed(Coeff1Raw);
	Coeff2 <= signed(Coeff2Raw);
	Coeff3 <= signed(Coeff3Raw);

	-- The PID loops take their inputs either from the outputs of the matrix or
	-- from the drive values directly, depending on the flags.
	process(ControlledDriveFlag, VelocitiesFlag, Drive1, Drive2, Drive3, Drive4, V2MOut1, V2MOut2, V2MOut3, V2MOut4)
	begin
		if ControlledDriveFlag = '1' then
			Setpoint1 <= resize(Drive1, Setpoint1'length);
			Setpoint2 <= resize(Drive2, Setpoint2'length);
			Setpoint3 <= resize(Drive3, Setpoint3'length);
			Setpoint4 <= resize(Drive4, Setpoint4'length);
		elsif VelocitiesFlag = '1' then
			Setpoint1 <= V2MOut1;
			Setpoint2 <= V2MOut2;
			Setpoint3 <= V2MOut3;
			Setpoint4 <= V2MOut4;
		else
			Setpoint1 <= to_signed(0, 18);
			Setpoint2 <= to_signed(0, 18);
			Setpoint3 <= to_signed(0, 18);
			Setpoint4 <= to_signed(0, 18);
		end if;
	end process;

	-- Depending on the state, we must select the proper address for the ROMs.
	ROMAddress <=
		     0 when ROMAddressState = V2M1
		else 1 when ROMAddressState = V2M2
		else 2 when ROMAddressState = V2M3
		else 3 when ROMAddressState = V2M4
		else 4 when ROMAddressState = PID1
		else 5 when ROMAddressState = PID2
		else 6 when ROMAddressState = PID3
		else 7 when ROMAddressState = PID4;

	-- Depending on the state, we must select the proper inputs to the MAdd.
	process(MuxInputState, Drive1, Drive2, Drive3, Error1, Error2, Error3, Error4, Integral1, Integral2, Integral3, Integral4, Derivative1, Derivative2, Derivative3, Derivative4)
	begin
		if MuxInputState = V2M1 then
			Var1 <= resize(Drive1, Var1'length);
			Var2 <= resize(Drive2, Var2'length);
			Var3 <= resize(Drive3, Var3'length);
		elsif MuxInputState = V2M2 then
			Var1 <= resize(Drive1, Var1'length);
			Var2 <= resize(Drive2, Var2'length);
			Var3 <= resize(Drive3, Var3'length);
		elsif MuxInputState = V2M3 then
			Var1 <= resize(Drive1, Var1'length);
			Var2 <= resize(Drive2, Var2'length);
			Var3 <= resize(Drive3, Var3'length);
		elsif MuxInputState = V2M4 then
			Var1 <= resize(Drive1, Var1'length);
			Var2 <= resize(Drive2, Var2'length);
			Var3 <= resize(Drive3, Var3'length);
		elsif MuxInputState = PID1 then
			Var1 <= resize(Error1, Var1'length);
			Var2 <= Integral1;
			Var3 <= Derivative1;
		elsif MuxInputState = PID2 then
			Var1 <= resize(Error2, Var1'length);
			Var2 <= Integral2;
			Var3 <= Derivative2;
		elsif MuxInputState = PID3 then
			Var1 <= resize(Error3, Var1'length);
			Var2 <= Integral3;
			Var3 <= Derivative3;
		elsif MuxInputState = PID4 then
			Var1 <= resize(Error4, Var1'length);
			Var2 <= Integral4;
			Var3 <= Derivative4;
		end if;
	end process;

	-- On a clock edge, capture the computed output and advance the state variable.
	-- This is where you should change which bits out of the product are kept for
	-- each state.
	process(Clock100)
	begin
		if rising_edge(Clock100) then
			if LatchOutputState = V2M1 then
				V2MOut1 <= Prod(9 downto 0);
			elsif LatchOutputState = V2M2 then
				V2MOut2 <= Prod(9 downto 0);
			elsif LatchOutputState = V2M3 then
				V2MOut3 <= Prod(9 downto 0);
			elsif LatchOutputState = V2M4 then
				V2MOut4 <= Prod(9 downto 0);
			elsif LatchOutputState = PID1 then
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

	-- Iterate the PID loops. All we really have to do here is advance the variables
	-- over a timestep; everything else is done "combinationally" as far as we are
	-- concerned (that is, sequentially but very fast).
	process(Clock1)
		-- Adds an error value to an integral value, clamping around the limit.
		pure function Integrate(Orig : in signed(17 downto 0); Err : in signed(10 downto 0); Limit : integer)
		return signed is
			variable OrigExtended : signed(18 downto 0);
			variable ErrExtended : signed(18 downto 0);
			variable SumExtended : signed(18 downto 0);
		begin
			OrigExtended := resize(Orig, 19);
			ErrExtended := resize(Err, 19);
			SumExtended := OrigExtended + ErrExtended;
			if SumExtended < -Limit then
				return to_signed(-Limit, 18);
			elsif SumExtended > Limit then
				return to_signed(Limit, 18);
			else
				return SumExtended(17 downto 0);
			end if;
		end function Integrate;

		variable NewError1 : signed(10 downto 0);
		variable NewError2 : signed(10 downto 0);
		variable NewError3 : signed(10 downto 0);
		variable NewError4 : signed(10 downto 0);
	begin
		if rising_edge(Clock1) then
			if PIDTicks = 0 then
				NewError1 := Setpoint1 - Encoder1;
				NewError2 := Setpoint2 - Encoder2;
				NewError3 := Setpoint3 - Encoder3;
				NewError4 := Setpoint4 - Encoder4;
				Integral1 <= Integrate(Integral1, NewError1, 131071);
				Integral2 <= Integrate(Integral2, NewError2, 131071);
				Integral3 <= Integrate(Integral3, NewError3, 131071);
				Integral4 <= Integrate(Integral4, NewError4, 131071);
				LastError1 <= Error1;
				LastError2 <= Error2;
				LastError3 <= Error3;
				LastError4 <= Error4;
				Error1 <= NewError1;
				Error2 <= NewError2;
				Error3 <= NewError3;
				Error4 <= NewError4;
			end if;
			PIDTicks <= (PIDTicks + 1) mod 1000;
		end if;
	end process;

	Derivative1 <= Error1 - LastError1;
	Derivative2 <= Error2 - LastError2;
	Derivative3 <= Error3 - LastError3;
	Derivative4 <= Error4 - LastError4;
end architecture Behavioural;
