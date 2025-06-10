----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2021 01:36:57
-- Design Name: 
-- Module Name: Digit_MUX - Behavioral
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
use work.my_package.All;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Digit_MUX is
    Port ( digit_in :   in  DIGIT_VECTOR (7 downto 0);
           select_in :  in  STD_LOGIC_VECTOR (7 downto 0);
           digit_out :  out STD_LOGIC_VECTOR (3 downto 0));
end Digit_MUX;

architecture Behavioral of Digit_MUX is

begin
    with select_in select
    digit_out <= digit_in(0) when "11111110",
                 digit_in(1) when "11111101",
                 digit_in(2) when "11111011",
                 digit_in(3) when "11110111",
                 digit_in(4) when "11101111",
                 digit_in(5) when "11011111",
                 digit_in(6) when "10111111",
                 digit_in(7) when "01111111",
                 "1111"      when others;
                 
                 


end Behavioral;
