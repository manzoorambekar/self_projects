----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2021 04:11:33
-- Design Name: 
-- Module Name: Adder_4_bit_BCD - Behavioral
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

entity Adder_4_bit_BCD is
    Port ( A :          in  STD_LOGIC_VECTOR (3 downto 0);
           B :          in  STD_LOGIC_VECTOR (3 downto 0);
           C :          in  STD_LOGIC;
           clk :        in  STD_LOGIC;
           reset :      in  STD_LOGIC;
           seg_out :    out STD_LOGIC_VECTOR (6 downto 0);
           an_out :     out STD_LOGIC_VECTOR (7 downto 0));
end Adder_4_bit_BCD;

architecture Behavioral of Adder_4_bit_BCD is
    signal digits: DIGIT_VECTOR(7 downto 0) := (others => x"F");
    signal sum:     std_logic_vector (4 downto 0);
begin
D1: adder_4bit  port map    (A => A, B => B, C_in => C, Sum => Sum);

D2: Bin2BCD     port map    (sum => sum , digits=>digits);

D3: led_driver  port map    (digits => digits, clk_in => clk, reset => reset, an_out => an_out, seg_out => seg_out);
end Behavioral;
