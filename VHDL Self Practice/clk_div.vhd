----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2021 11:25:52
-- Design Name: 
-- Module Name: clk_div - Behavioral
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

entity clk_div is
    Generic (   count_width :  integer := 2500);
    Port    (   clk_in      :  in  STD_LOGIC;
                reset       :  in  STD_LOGIC;
                clk_out     :  out STD_LOGIC);
end clk_div;

architecture Behavioral of clk_div is

begin
counter: process(clk_in , reset)
    variable ticks: integer range 0 to count_width := 0;
    variable Q : std_logic := '0';

begin
    if(reset = '0') then
        ticks := 0;
        Q := '0';
        
    elsif(clk_in 'event and clk_in='1') then
        ticks := ticks + 1;
        
        if(ticks = count_width) then
            ticks := 0;
            Q := not Q;
        end if;
    end if;
    
    clk_out <= Q;
    
end process;

end Behavioral;
