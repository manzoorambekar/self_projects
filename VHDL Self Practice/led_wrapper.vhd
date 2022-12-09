----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.12.2021 15:46:40
-- Design Name: 
-- Module Name: led_wrapper - Behavioral
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

entity led_wrapper is
  Port ( Digit_0,
         Digit_1,
         Digit_2,
         Digit_3,
         Digit_4,
         Digit_5,
         Digit_6,
         Digit_7:   in STD_LOGIC_VECTOR(3 downto 0);
         clk_in:    in STD_LOGIC;
         reset_in:  in STD_LOGIC;
         an_out:    out STD_LOGIC_VECTOR(7 downto 0);
         seg_out:   out STD_LOGIC_VECTOR(6 downto 0));
end led_wrapper;

architecture Behavioral of led_wrapper is
signal digits: digit_vector(7 downto 0);
begin
led:    led_driver port map (   digits => digits,
                                reset => reset_in,
                                clk_in => clk_in,
                                an_out => an_out,
                                seg_out => seg_out);
    digits <= (0 => Digit_0,
               1 => Digit_1,
               2 => Digit_3,
               3 => Digit_3,
               4 => Digit_4,
               5 => Digit_5,
               6 => Digit_6,
               7 => Digit_7);
               
end Behavioral;
