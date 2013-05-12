library ieee;
use ieee.std_logic_1164.all;
use work.pavr_constants.all;

package types is
	subtype mcp3008_value_t is natural range 0 to 2 ** 10 - 1;
	type mcp3008_t is record
		Value : mcp3008_value_t;
		Strobe : boolean;
	end record;
	type mcp3008s_t is array(0 to 7) of mcp3008_t;

	subtype battery_voltage_t is mcp3008_value_t;
	subtype capacitor_voltage_t is mcp3008_value_t;

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

	-- The number of DMA read and write channels.
	constant DMAReadChannels : natural := 1;
	constant DMAWriteChannels : natural := 2;
	constant DMAChannels : natural := DMAReadChannels + DMAWriteChannels;

	type cpu_input_dma_info_t is record
		Pointer : natural range 0 to pavr_dm_len - 1;
		Count : natural range 0 to 255;
		Enabled : boolean;
	end record;
	type cpu_input_dma_infos_t is array(0 to DMAChannels - 1) of cpu_input_dma_info_t;

	type cpu_output_dma_info_t is record
		Value : std_ulogic_vector(7 downto 0);
		StrobePointerLow : boolean;
		StrobePointerHigh : boolean;
		StrobeCount : boolean;
		StrobeEnable : boolean;
	end record;
	type cpu_output_dma_infos_t is array(0 to DMAChannels - 1) of cpu_output_dma_info_t;

	type cpu_inputs_t is record
		-- System timer tick count
		Ticks : natural range 0 to 255;

		-- Whether interlocks are overridden
		InterlockOverride : boolean;

		-- Whether the breakout board is present
		BreakoutPresent : boolean;

		-- Hall sensor failure detection
		HallsStuckHigh : halls_stuck_t;
		HallsStuckLow : halls_stuck_t;

		-- Optical encoder counts and failure detection
		EncodersCount : encoders_count_t;
		EncodersFail : encoders_fail_t;

		-- ADC readings
		MCP3008 : mcp3008s_t;

		-- Chicker status
		ChickerPresent : boolean;
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

		-- SD card status
		SDBusy : boolean;
		SDPresent : boolean;
		SDDataRead : std_ulogic_vector(7 downto 0);

		-- Device ID
		DeviceID : std_ulogic_vector(55 downto 0);
		DeviceIDReady : boolean;

		-- LFSR output
		LFSRBit : std_ulogic;

		-- Debug port status
		DebugBusy : boolean;

		-- Internal configuration access port status
		ICAPBusy : boolean;

		-- DMA channel pointers, counts, and enable flags
		DMA : cpu_input_dma_infos_t;
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
		MRFDataWrite : std_ulogic_vector(7 downto 0);
		MRFAddress : std_ulogic_vector(9 downto 0);
		MRFStrobeAddress : boolean;
		MRFStrobeShortRead : boolean;
		MRFStrobeLongRead : boolean;
		MRFStrobeShortWrite : boolean;
		MRFStrobeLongWrite : boolean;

		-- SD card control
		SDCS : std_ulogic;
		SDDataWrite : std_ulogic_vector(7 downto 0);
		SDStrobe : boolean;

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

		-- DMA channel pointers, counts, and enable flags
		DMA : cpu_output_dma_infos_t;
	end record;

	-- Control lines sent from a peripheral to the DMA controller for a read channel.
	-- All lines in this record operate on the rising edge of the 40 MHz clock.
	type dmar_request_t is record
		-- Peripheral must set Consumed to true for exactly one clock cycle after it has consumed the byte provided on the response port.
		-- Peripheral must not set Consumed to true unless Valid is true before the clock edge on which Consumed becomes true.
		Consumed : boolean;
	end record;
	type dmar_requests_t is array(0 to DMAReadChannels - 1) of dmar_request_t;

	-- Control and data lines from the DMA controller to a peripheral for a read channel.
	-- All lines in this record operate on the rising edge of the 40 MHz clock.
	type dmar_response_t is record
		-- Peripheral may consume a byte whenever this is true at a clock edge.
		Valid : boolean;
		-- The byte of data read from RAM.
		-- Data becomes valid at the same time as Valid becomes true and remains valid until after the clock edge on which Consumed becomes true.
		Data : std_ulogic_vector(7 downto 0);
	end record;
	type dmar_responses_t is array(0 to DMAReadChannels - 1) of dmar_response_t;

	-- Control and data lines sent from a peripheral to the DMA controller for a write channel.
	-- All lines in this record operate on the rising edge of the 40 MHz clock.
	type dmaw_request_t is record
		-- Peripheral must set Write to true for exactly one clock cycle to push a byte to RAM.
		-- Peripheral must not set Write to true unless Ready is true before the clock edge on which Write becomes true.
		Write : boolean;
		-- The byte of data to write to RAM.
		-- Peripheral must ensure Data becomes valid at the same time as Write becomes true and remains valid until after the subsequent clock edge.
		Data : std_ulogic_vector(7 downto 0);
	end record;
	type dmaw_requests_t is array(DMAReadChannels to DMAChannels - 1) of dmaw_request_t;

	-- Control lines from the DMA controller to a peripheral for a write channel.
	-- All lines in this record operate on the rising edge of the 40 MHz clock.
	type dmaw_response_t is record
		-- Peripheral may write a byte whenever this is true at a clock edge.
		Ready : boolean;
	end record;
	type dmaw_responses_t is array(DMAReadChannels to DMAChannels - 1) of dmaw_response_t;

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
