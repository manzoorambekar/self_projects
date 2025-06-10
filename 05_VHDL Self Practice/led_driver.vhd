----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2021 01:30:51
-- Design Name: 
-- Module Name: led_driver - Behavioral
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

entity led_driver is
    Port ( digits :     in  DIGIT_VECTOR (7 downto 0);
           clk_in :     in  STD_LOGIC;
           reset :      in  STD_LOGIC;
           an_out :     out STD_LOGIC_VECTOR (7 downto 0);
           seg_out :    out STD_LOGIC_VECTOR (6 downto 0));
end led_driver;

architecture Behavioral of led_driver is
component clk_div is
    Generic (count_width : integer := 2500);
    Port ( clk_in : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end component clk_div;

component Digit_MUX is
    Port ( digit_in :   in  DIGIT_VECTOR (7 downto 0);
           select_in :  in  STD_LOGIC_VECTOR (7 downto 0);
           digit_out :  out STD_LOGIC_VECTOR (3 downto 0));
end component Digit_MUX;

component dec_to_7seg is
    Port ( digit_in :       in  STD_LOGIC_VECTOR (3 downto 0);
           segment_out :    out STD_LOGIC_VECTOR (6 downto 0));
end component dec_to_7seg;

component ring is
    Generic (N : integer range 1 to 31 := 3);
    Port ( clk_in : in STD_LOGIC;
           reset : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (N downto 0));
end component ring;

signal digit:           std_logic_vector(3 downto 0);
signal digit_select:    std_logic_vector(7 downto 0);
signal clk:             std_logic;

begin
U1: Digit_MUX   port map    (digit_in => digits, 
                             select_in => digit_select,
                             digit_out => digit);
                             
U2: clk_div     generic map (count_width => 5000)
                port map    (clk_in => clk_in,
                             reset => reset,
                             clk_out => clk);
                             
U3: ring        generic map (N => 7)
                port map    (clk_in => clk,
                             reset => reset,
                             output => digit_select);
U4: dec_to_7seg port map    (digit_in => digit,
                             segment_out => seg_out);
end Behavioral;
