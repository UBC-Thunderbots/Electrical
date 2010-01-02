library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity txpacketassembler is
        Port ( addr : in std_logic_vector(63 downto 0);
               go : in std_logic;
               clock : in std_logic;

               -- sensor data
               data_in1 : in std_logic_vector(7 downto 0);
               data_in2 : in std_logic_vector(7 downto 0);

               TransmitterBusy : in std_logic;

               data_out : out std_logic_vector(7 downto 0);
               SOP : out std_logic;
               load : out std_logic );
end txpacketassembler;

architecture Behaviour of txpacketassembler is

constant DATA_BYTES : integer := 2;

begin

        process(clock) 

        type state_t is ( IDLE, SENDING_SOP,
                        SENDING_LEN_MSB, SENDING_LEN_LSB,
                        SENDING_API_ID,
                        SENDING_FRAME_ID,
                        SENDING_DEST,
                        SENDING_OPTS,
                        SENDING_DATA,
                        SENDING_CSUM );
                        
        variable state : state_t := IDLE;
        variable dest_byte : integer range 0 to 7 := 0;
        variable data_byte : integer range 0 to DATA_BYTES - 1 := 0;
        
        type BUF_ARR_t is array (0 to DATA_BYTES - 1) of std_logic_vector(7 downto 0);
        variable buf : BUF_ARR_t;
        
        variable checksum : std_logic_vector(7 downto 0);

        begin

                if (clock'event and clock = '1') then

                        if (state = IDLE) then
                                if (go = '1') then
                                        state := SENDING_SOP;
                                        
                                        -- copy input data to buf
                                        buf(0) := data_in1;
                                        buf(1) := data_in2;
                                        
                                        -- reset counters
                                        dest_byte := 0;
                                        data_byte := 0;
                                        
                                        checksum := "00000000";
                                end if;
                        else 
                                if (TransmitterBusy = '1') then
                                        load <= '0';
                                else
                                        load <= '1';
                                        if (state = SENDING_SOP) then
                                                SOP <= '1';
                                                state := SENDING_LEN_MSB;
                                                load <= '0';
                                        elsif (state = SENDING_LEN_MSB) then
                                                data_out <= "00000000"; 
                                                -- we can only send 100 bytes at a time
                                                -- therefore length MSB MUST be 0
                                                state := SENDING_LEN_LSB;
                                        elsif (state = SENDING_LEN_LSB) then
                                                data_out <= std_logic_vector(to_unsigned(11 + DATA_BYTES, 8));
                                                state := SENDING_API_ID;
                                        elsif (state = SENDING_API_ID) then
                                                data_out <= "00000000";
                                                state := SENDING_FRAME_ID;
                                        elsif (state = SENDING_FRAME_ID) then
                                                data_out <= "00000000"; -- no response frame
                                                state := SENDING_DEST;
                                        elsif (state = SENDING_DEST) then
                                                data_out <= addr((8 - dest_byte)*8 - 1 downto (8 - dest_byte - 1)*8);
                                                if (dest_byte = 7) then
                                                        state := SENDING_OPTS;
                                                end if;
                                                dest_byte := dest_byte + 1;
                                        elsif (state = SENDING_OPTS) then
                                                data_out <= "00000001";
                                                -- disable ACK, no broadcast
                                                state := SENDING_DATA;
                                        elsif (state = SENDING_DATA) then
                                                data_out <= buf(data_byte);
                                                checksum := std_logic_vector(unsigned(checksum) + unsigned(buf(data_byte)));
                                                if (data_byte = (DATA_BYTES - 1)) then
                                                        state := SENDING_CSUM;
                                                end if;
                                                data_byte := data_byte + 1;
                                        elsif (state = SENDING_CSUM) then
                                                data_out <= checksum;
                                                state := IDLE;
                                        end if;
                                end if;
                        end if;
                end if;

        end process;

end Behaviour;
