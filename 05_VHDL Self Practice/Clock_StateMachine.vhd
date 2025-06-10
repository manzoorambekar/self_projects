----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.12.2021 16:06:44
-- Design Name: 
-- Module Name: Clock_StateMachine - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Clock_StateMachine is
    Port ( clk_in       : in  STD_LOGIC;
           reset_in     : in  STD_LOGIC;
           SW_clear     : in  STD_LOGIC;
           SW_start     : in  STD_LOGIC;
           SW_stop      : in  STD_LOGIC;
           count_EN     : out STD_LOGIC     :=  '0';
           count_reset  : out STD_LOGIC     :=  '0');
end Clock_StateMachine;

architecture Behavioral of Clock_StateMachine is
    type    states is(stopped, counting, cleared);
    signal  state, next_state: states   :=  stopped;

begin

-- Invocation:  Based on the hardware input switches (start, stop, clear)
-- Operation:   Update the next state based on the input signal and current state.
transition  : process(SW_start, SW_stop, SW_clear)
begin
    -- Check the current state of the stopwatch
    case state is
        -- For current state as counting, poll for only stop signal
        when counting =>
            -- Jump from counting to stopped, to pause the stop watch.
            if(SW_stop = '1') then
                next_state  <=  stopped;
            end if;
         
        -- For current state as stopped, poll for start and clear signals
        when stopped =>
            -- Jump from stopped to counting, to resume the stop watch from the last count.
            if(SW_start = '1') then
                next_state  <=  counting;
            -- Jump from stopped to cleared, to clear the stop watch counts.
            elsif(SW_clear = '1') then
                next_state  <=  cleared;
            end if;
          
        -- For current state as cleared, poll for only start signal
        when cleared =>
            -- Jump from cleaed to counting, to restart the stop watch from initial values.
            if(SW_start = '1') then
                next_state  <=  counting;
            end if;
    end case;
end process;

-- Invocation:  Based on every clock edge and reset input signal
-- Operation:   If invoked by,
--                  reset_in: Reset the stop watch.
--                  clk_in: Change the current state to next state on the clock edge.
memory      : process(clk_in, reset_in)
begin
    if(reset_in = '0') then
        state <= cleared;
    -- If reset is 1 and rising clock edge has been encountered then change the state
    elsif (clk_in'event and clk_in = '1') then
        state <= next_state;
        
    end if;
end process;

-- Invocation:  For every state change at the rising clock edge.
-- Operation:   Update the output signals of clock state machine for every state change.
output      : process(state)
begin

    case state is
        -- Start/resume the counters.
        when counting =>
            count_reset <=  '1';
            count_EN    <=  '1';
        
        -- Pause the counters.
        when stopped =>
            count_reset <=  '1';
            count_EN    <=  '0';
        
        -- Clear the counters to initial values.
        when cleared =>
            count_reset <=  '0';
            count_EN    <=  '0';
            
    end case;
end process;

end Behavioral;
