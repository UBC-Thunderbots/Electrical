library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
library work;
use work.pavr_constants.all;
use work.types.all;

entity DMAController is
	port(
		-- Control lines.
		Clock : in std_ulogic;
		Reset : in boolean;

		-- Connections to the CPU for control and status registers.
		CPUInputs : out cpu_input_dma_infos_t;
		CPUOutputs : in cpu_output_dma_infos_t;

		-- Connections to the peripherals.
		ReadRequests : in dmar_requests_t;
		ReadResponses : out dmar_responses_t;
		WriteRequests : in dmaw_requests_t;
		WriteResponses : out dmaw_responses_t;

		-- Connections to the data memory block RAM port.
		DMAWrite : out boolean := false;
		DMAAddress : out natural range 0 to pavr_dm_len - 1;
		DMADataWrite : out std_ulogic_vector(7 downto 0);
		DMADataRead : in std_ulogic_vector(7 downto 0));
end entity DMAController;

-- Design:
--
-- The DMA controller consists of a CORE, one or more CHANNELS, and a SCHEDULER.
--
-- The core is actually connected to the block RAM and performs read and write operations.
-- The core is pipelined, with one or more pipeline stages leading into the block RAM, the block RAM itself comprising a pipeline stage, and one or more pipeline stages after the block RAM.
-- The storage at each pipeline stage comprises an address word, a data byte, a write flag, and a one-hot channel bitmask.
-- In this description, each pipeline stage refers to wiring, with storage lying between stages.
--
-- The channels are how the DMA controller connects to peripherals.
-- There are a set of read channels which are used to read from RAM and a separate set of write channels which are used to write to RAM.
-- Each channel is exposed as a request record carrying signals from the peripheral and a response record carrying signals to the peripheral.
-- Within the DMA controller, read and write channels operate differently.
--
-- For a read channel, the channel maintains a two-byte FIFO of data read from RAM but not yet consumed by the peripheral.
-- The two slots in the FIFO are labelled head and tail, with data being pushed into the head and popped from the tail.
-- Whenever the tail is full, that data is exposed to the peripheral.
-- When the peripheral indicates consumption of the data, the tail is marked empty.
-- Whenever the tail is empty but the head is full, the byte is shifted from head to tail.
-- Whenever the head is empty and no read operation is in the core pipeline, the channel tries to issue a read operation to fill the FIFO.
-- The channel address register indicates the next address for which a read operation will be issued.
-- The channel count register indicates the number of bytes for which read operations have not yet been issued into the core.
-- These registers may therefore be up to three bytes ahead of what the peripheral is handling (two bytes in the FIFO and one read operation in the core pipeline).
-- The channel disables itself when the count is zero, no read operation is in the core, and the FIFO is empty, which occurs once the peripheral has consumed the last byte.
--
-- For a write channel, the channel maintains a two-byte FIFO of data sent from the peripheral but not yet issued into the core as a write operation.
-- The two slots in the FIFO are labelled head and tail, with data being pushed into the head and popped from the tail.
-- Whenever the tail is full, the channel tries to issue a write operation into the core.
-- When a write operation is issued into the core, the tail is marked empty.
-- Whenever the tail is empty but the head is full, the byte is shifted from head to tail.
-- Whenever the head is empty and the byte count is nonzero, the channel indicates ready to the peripheral.
-- The channel address register indicates the next address for which a write operation will be issued.
-- The channel count register indicates the number of bytes which have not yet entered the FIFO from the peripheral.
-- These registers may therefore be both out of date AND desynchronized FROM EACH OTHER by the number of bytes in the FIFO!
-- The channel disables itself when the count is zero, no write operation is in the core, and the FIFO is empty.
--
-- The scheduler determines which channel is allowed to issue an operation into the core pipeline on each clock cycle.
-- The scheduler offers a grant to a channel by raising a signal after a clock edge.
-- That channel is allowed to compute the parameters of a core operation which will be accepted into the pipeline at the next clock edge.

architecture Arch of DMAController is
	-- The number of pipeline stages leading up to the block RAM.
	constant PrePipelineDepth : positive := 1;

	-- The number of pipeline stages coming from the block RAM.
	constant PostPipelineDepth : positive := 1;

	-- This is the type of data associated with one stage in the core pipeline.
	type core_stage_t is record
		Valid : boolean;
		Channel : natural range 0 to DMAChannels - 1;
		Data : std_ulogic_vector(7 downto 0);
		Address : natural range 0 to pavr_dm_len - 1;
		Write : boolean;
	end record;

	-- The wires running from the channels to the core.
	-- In this array, the Channel fields are ignored.
	type core_inputs_t is array(0 to DMAChannels - 1) of core_stage_t;
	signal CoreInputs : core_inputs_t;

	-- The pipeline stages leading into the block RAM; array element zero is wired to the channels, while the last array element is wired into the BRAM control lines.
	type core_pre_pipeline_t is array(0 to PrePipelineDepth - 1) of core_stage_t;
	signal CorePrePipeline : core_pre_pipeline_t := (others => (Valid => false, Channel => 0, Data => X"00", Address => 0, Write => false));

	-- The pipeline stages leading from the block RAM; array element zero is wired to the BRAM output lines, while the last array element is wired into the channels.
	type core_post_pipeline_t is array(0 to PostPipelineDepth - 1) of core_stage_t;
	signal CorePostPipeline : core_post_pipeline_t := (others => (Valid => false, Channel => 0, Data => X"00", Address => 0, Write => false));

	-- The wires running from the core to the channels carrying the pipeline output.
	signal CoreOutputs : core_stage_t;

	-- The wires indicating whether a particular channel has any operations in the core at this time.
	-- These signals intentionally do not check for write operations in the post-BRAM pipeline.
	type core_has_channel_operation_t is array(0 to DMAChannels - 1) of boolean;
	signal CoreHasChannelOperation : core_has_channel_operation_t;



	-- The pointer, count, and enable signals and the two-byte FIFOs for all channels.
	type pointers_t is array(0 to DMAChannels - 1) of natural range 0 to pavr_dm_len - 1;
	signal Pointers : pointers_t;
	type counts_t is array(0 to DMAChannels - 1) of natural range 0 to pavr_dm_len - 1;
	signal Counts : counts_t;
	type enables_t is array(0 to DMAChannels - 1) of boolean;
	signal Enables : enables_t := (others => false);
	type fifo_entry_t is record
		Valid : boolean;
		Data : std_ulogic_vector(7 downto 0);
	end record;
	type fifo_stage_t is array(0 to DMAChannels - 1) of fifo_entry_t;
	signal FIFOHeads : fifo_stage_t := (others => (Valid => false, Data => X"00"));
	signal FIFOTails : fifo_stage_t := (others => (Valid => false, Data => X"00"));



	-- The channel selected by the scheduler.
	signal SchedulerChannel : natural range 0 to DMAChannels - 1 := 0;
	signal LastSchedulerChannel : natural range 0 to DMAChannels - 1 := 0;
begin
	-- Run the first pipeline stage, bringing values from the channels to the core.
	process(CoreInputs, LastSchedulerChannel) is
	begin
		CorePrePipeline(0) <= CoreInputs(LastSchedulerChannel);
		CorePrePipeline(0).Channel <= LastSchedulerChannel;
	end process;

	-- Run the core pipeline stages that do not touch the inputs or the BRAM.
	PrePipeline : for I in 1 to PrePipelineDepth - 1 generate
		process(Clock) is
		begin
			if rising_edge(Clock) then
				if Reset then
					CorePrePipeline(I).Valid <= false;
				else
					CorePrePipeline(I) <= CorePrePipeline(I - 1);
				end if;
			end if;
		end process;
	end generate;
	PostPipeline : for I in 1 to PostPipelineDepth - 1 generate
		process(Clock) is
		begin
			if rising_edge(Clock) then
				if Reset then
					CorePostPipeline(I).Valid <= false;
				else
					CorePostPipeline(I) <= CorePostPipeline(I - 1);
				end if;
			end if;
		end process;
	end generate;

	-- Run the core pipeline stage going into the BRAM.
	DMAWrite <= CorePrePipeline(PrePipelineDepth - 1).Valid and CorePrePipeline(PrePipelineDepth - 1).Write;
	DMAAddress <= CorePrePipeline(PrePipelineDepth - 1).Address;
	DMADataWrite <= CorePrePipeline(PrePipelineDepth - 1).Data;

	-- Run the core pipeline stage going out of the BRAM.
	process(Clock, DMADataRead) is
	begin
		if rising_edge(Clock) then
			if Reset then
				CorePostPipeline(0).Valid <= false;
			else
				CorePostPipeline(0) <= CorePrePipeline(PrePipelineDepth - 1);
			end if;
		end if;
		CorePostPipeline(0).Data <= DMADataRead;
	end process;

	-- Run the core pipeline stage leaving the pipeline and going back to the channels.
	CoreOutputs <= CorePostPipeline(PostPipelineDepth - 1);

	-- Run the channel operation checks.
	process(CorePrePipeline, CorePostPipeline) is
	begin
		for Channel in 0 to DMAChannels - 1 loop
			CoreHasChannelOperation(Channel) <= false;
			for Stage in 0 to PrePipelineDepth - 1 loop
				if CorePrePipeline(Stage).Valid and CorePrePipeline(Stage).Channel = Channel then
					CoreHasChannelOperation(Channel) <= true;
				end if;
			end loop;
			if Channel < DMAReadChannels then
				for Stage in 0 to PostPipelineDepth - 1 loop
					if CorePostPipeline(Stage).Valid and CorePostPipeline(Stage).Channel = Channel then
						CoreHasChannelOperation(Channel) <= true;
					end if;
				end loop;
			end if;
		end loop;
	end process;



	GenerateReadChannels : for Channel in 0 to DMAReadChannels - 1 generate
		process(Clock) is
		begin
			if rising_edge(Clock) then
				-- Unless an operation is specifically issued, by default, we do not issue an operation.
				-- However, we might as well always update the address because there is no harm in sending an address as part of an invalid operation.
				CoreInputs(Channel).Valid <= false;
				CoreInputs(Channel).Address <= Pointers(Channel);

				if Reset then
					Enables(Channel) <= false;
					FIFOHeads(Channel).Valid <= false;
					FIFOTails(Channel).Valid <= false;
				else
					if Enables(Channel) then
						-- Run the channel.
						if FIFOHeads(Channel).Valid and not FIFOTails(Channel).Valid then
							-- Advance the FIFO.
							-- Nothing else can happen this clock cycle.
							-- The peripheral cannot be consuming a byte because the tail was invalid.
							-- Meanwhile, the core cannot be providing a byte from an operation because the head was valid so no operation would have been issued.
							FIFOTails(Channel) <= FIFOHeads(Channel);
							FIFOHeads(Channel).Valid <= false;
						end if;
						if ReadRequests(Channel).Consumed then
							-- Peripheral has consumed the data at the tail of the FIFO, so mark it invalid.
							-- This should only happen when tail is valid, since otherwise peripheral is forbidden from consuming.
							FIFOTails(Channel).Valid <= false;
						end if;
						if CoreOutputs.Valid and CoreOutputs.Channel = Channel then
							-- Core operation for this channel has reached the end of the core pipeline.
							-- Add the results of the operation to the FIFO.
							-- It is not possible that this could happen while the FIFO head is full, because we never issue operations unless the FIFO head is empty.
							FIFOHeads(Channel).Valid <= true;
							FIFOHeads(Channel).Data <= CoreOutputs.Data;
						end if;
						if not FIFOHeads(Channel).Valid and not CoreHasChannelOperation(Channel) and Counts(Channel) /= 0 and SchedulerChannel = Channel then
							-- Issue a request into the core and advance the pointer and count accordingly.
							CoreInputs(Channel).Valid <= true;
							Pointers(Channel) <= Pointers(Channel) + 1;
							Counts(Channel) <= Counts(Channel) - 1;
						end if;
						if not FIFOHeads(Channel).Valid and not FIFOTails(Channel).Valid and not CoreHasChannelOperation(Channel) and Counts(Channel) = 0 then
							-- The transfer is complete.
							Enables(Channel) <= false;
						end if;
					else
						-- Allow the CPU to modify the transfer parameters.
						if CPUOutputs(Channel).StrobePointerByte then
							Pointers(Channel) <= (Pointers(Channel) * 256 + to_integer(unsigned(CPUOutputs(Channel).Value))) mod pavr_dm_len;
						end if;
						if CPUOutputs(Channel).StrobeCountByte then
							Counts(Channel) <= (Counts(Channel) * 256 + to_integer(unsigned(CPUOutputs(Channel).Value))) mod pavr_dm_len;
						end if;
						if CPUOutputs(Channel).StrobeEnable then
							Enables(Channel) <= true;
						end if;
					end if;
				end if;
			end if;
		end process;

		ReadResponses(Channel).Valid <= FIFOTails(Channel).Valid and not ReadRequests(Channel).Consumed;
		ReadResponses(Channel).Data <= FIFOTails(Channel).Data;
		CoreInputs(Channel).Channel <= 0;
		CoreInputs(Channel).Data <= X"00";
		CoreInputs(Channel).Write <= false;
	end generate;



	GenerateWriteChannels : for Channel in DMAReadChannels to DMAChannels - 1 generate
		process(Clock) is
		begin
			if rising_edge(Clock) then
				-- Unless an operation is specifically issued, by default, we do not issue an operation.
				-- However, we might as well always update the address because there is no harm in sending an address as part of an invalid operation.
				CoreInputs(Channel).Valid <= false;
				CoreInputs(Channel).Address <= Pointers(Channel);

				if Reset then
					Enables(Channel) <= false;
					FIFOHeads(Channel).Valid <= false;
					FIFOTails(Channel).Valid <= false;
				else
					if Enables(Channel) then
						-- Run the channel.
						if FIFOHeads(Channel).Valid and not FIFOTails(Channel).Valid then
							-- Advance the FIFO.
							-- Nothing else can happen this clock cycle.
							-- The peripheral cannot be writing a byte because the head was valid.
							FIFOTails(Channel) <= FIFOHeads(Channel);
							FIFOHeads(Channel).Valid <= false;
						end if;
						if WriteRequests(Channel).Write then
							-- Peripheral has generated data which should be taken into the head of the FIFO.
							-- This should only happen when head is invalid and count is nonzero, since otherwise Ready is false and peripheral is forbidden from writing.
							FIFOHeads(Channel).Valid <= true;
							FIFOHeads(Channel).Data <= WriteRequests(Channel).Data;
							Counts(Channel) <= Counts(Channel) - 1;
						end if;
						if FIFOTails(Channel).Valid and SchedulerChannel = Channel then
							-- Issue a request into the core and advance the pointer accordingly.
							-- Count is updated based on bytes being pushed into the FIFO, so do not update it here.
							FIFOTails(Channel).Valid <= false;
							CoreInputs(Channel).Valid <= true;
							CoreInputs(Channel).Data <= FIFOTails(Channel).Data;
							Pointers(Channel) <= Pointers(Channel) + 1;
						end if;
						if not FIFOHeads(Channel).Valid and not FIFOTails(Channel).Valid and not CoreHasChannelOperation(Channel) and Counts(Channel) = 0 then
							-- The transfer is complete.
							Enables(Channel) <= false;
						end if;
					else
						-- Allow the CPU to modify the transfer parameters.
						if CPUOutputs(Channel).StrobePointerByte then
							Pointers(Channel) <= (Pointers(Channel) * 256 + to_integer(unsigned(CPUOutputs(Channel).Value))) mod pavr_dm_len;
						end if;
						if CPUOutputs(Channel).StrobeCountByte then
							Counts(Channel) <= (Counts(Channel) * 256 + to_integer(unsigned(CPUOutputs(Channel).Value))) mod pavr_dm_len;
						end if;
						if CPUOutputs(Channel).StrobeEnable then
							Enables(Channel) <= true;
						end if;
					end if;
				end if;
			end if;
		end process;

		WriteResponses(Channel).Ready <= not FIFOHeads(Channel).Valid and not WriteRequests(Channel).Write and Counts(Channel) /= 0;
		CoreInputs(Channel).Channel <= 0;
		CoreInputs(Channel).Write <= true;
	end generate;



	GenerateCPUInputs : for Channel in 0 to DMAChannels - 1 generate
		CPUInputs(Channel).Pointer <= Pointers(Channel);
		CPUInputs(Channel).Count <= Counts(Channel);
		CPUInputs(Channel).Enabled <= Enables(Channel) or CPUOutputs(Channel).StrobeEnable;
	end generate;



	process(Clock) is
	begin
		if rising_edge(Clock) then
			LastSchedulerChannel <= SchedulerChannel;
			if Reset then
				SchedulerChannel <= 0;
			else
				SchedulerChannel <= (SchedulerChannel + 1) mod DMAChannels;
			end if;
		end if;
	end process;
end architecture Arch;
