library ieee;
use ieee.std_logic_1164.all;

package types is
	subtype battery_voltage_t is natural range 0 to 2 ** 10 - 1;

	subtype capacitor_voltage_t is natural range 0 to 2 ** 10 - 1;

	subtype mcp3008_t is natural range 0 to 2 ** 10 - 1;
	type mcp3008s_t is array(0 to 7) of mcp3008_t;

	type encoder_t is array(0 to 1) of boolean;
	type encoders_t is array(0 to 3) of encoder_t;

	type encoders_clear_t is array(0 to 3) of boolean;

	subtype encoder_count_t is integer range -32768 to 32767;
	type encoders_count_t is array(0 to 3) of encoder_count_t;

	type encoders_fail_t is array(0 to 3) of boolean;

	type hall_t is array(0 to 2) of boolean;
	type halls_t is array(0 to 4) of hall_t;

	type halls_stuck_t is array(0 to 4) of boolean;

	type motor_control_phase_t is (FLOAT, PWM, LOW, HIGH);
	type motor_control_phases_t is array(0 to 2) of motor_control_phase_t;
	subtype motor_control_power_t is natural range 0 to 2 ** 8 - 1;
	type motor_control_t is record
		Phases : motor_control_phases_t;
		AutoCommutate : boolean;
		Direction : boolean;
		Power : motor_control_power_t;
	end record;
	type motors_control_t is array(0 to 4) of motor_control_t;

	type motor_drive_phase_t is (FLOAT, LOW, HIGH);
	type motor_drive_phases_t is array(0 to 2) of motor_drive_phase_t;
	type motors_drive_phases_t is array(0 to 4) of motor_drive_phases_t;

	type cpu_inputs_t is record
		-- System timer tick count
		Ticks : natural range 0 to 255;

		-- Whether interlocks are overridden
		InterlockOverride : boolean;

		-- Hall sensor failure detection
		HallsStuckHigh : halls_stuck_t;
		HallsStuckLow : halls_stuck_t;

		-- Optical encoder counts
		EncodersCount : encoders_count_t;

		-- ADC readings
		MCP3008Levels : mcp3008s_t;

		-- Chicker status
		ChargeDone : boolean;
		ChargeTimeout : boolean;
		KickActive : boolean;
		ChipActive : boolean;

		-- SPI Flash status
		FlashBusy : boolean;
		FlashDataRead : std_ulogic_vector(7 downto 0);

		-- MRF status
		MRFInterrupt : std_ulogic;
		MRFBusy : boolean;
		MRFDataRead : std_ulogic_vector(7 downto 0);

		-- Device ID
		DeviceID : std_ulogic_vector(55 downto 0);
		DeviceIDReady : boolean;

		-- LFSR output
		LFSRBit : std_ulogic;

		-- Debug port status
		DebugBusy : boolean;

		-- Internal configuration access port status
		ICAPBusy : boolean;
	end record;

	type cpu_outputs_t is record
		-- LED control
		RadioLED : boolean;
		TestLEDsSoftware : boolean;
		TestLEDsValue : std_ulogic_vector(4 downto 0);

		-- Power control
		PowerLaser : boolean;
		PowerMotors : boolean;
		PowerLogic : boolean;

		-- Motor control
		MotorsControl : motors_control_t;

		-- Chicker control
		Charge : boolean;
		Discharge : boolean;
		KickPeriod : natural range 0 to 65535;
		StartKick : boolean;
		StartChip : boolean;

		-- SPI Flash control
		FlashCS : std_ulogic;
		FlashDataWrite : std_ulogic_vector(7 downto 0);
		FlashStrobe : boolean;

		-- MRF control
		MRFReset : std_ulogic;
		MRFWake : std_ulogic;
		MRFCS : std_ulogic;
		MRFDataWrite : std_ulogic_vector(7 downto 0);
		MRFStrobe : boolean;

		-- Lateral position sensor control
		LPSDrives : std_ulogic_vector(3 downto 0);

		-- LFSR control
		LFSRTick : boolean;

		-- Debug port control
		DebugEnabled : boolean;
		DebugData : std_ulogic_vector(7 downto 0);
		DebugStrobe : boolean;

		-- Internal configuration access port control
		ICAPData : std_ulogic_vector(15 downto 0);
		ICAPStrobe : boolean;

		-- For simulation only, a random magic value
		SimMagic : std_ulogic_vector(7 downto 0);
	end record;

	function to_boolean(X : std_ulogic) return boolean;

	function to_stdulogic(X : boolean) return std_ulogic;
end package types;

package body types is
	function to_boolean(X : std_ulogic) return boolean is
	begin
		return X = '1';
	end function to_boolean;

	function to_stdulogic(X : boolean) return std_ulogic is
	begin
		if X then
			return '1';
		else
			return '0';
		end if;
	end function to_stdulogic;
end package body types;
