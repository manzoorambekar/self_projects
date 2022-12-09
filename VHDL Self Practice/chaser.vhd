----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2021 13:25:13
-- Design Name: 
-- Module Name: chaser - Behavioral
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

entity chaser is
    Port ( clk_in : in STD_LOGIC;
           reset : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (15 downto 0));
end chaser;

architecture Behavioral of chaser is
    component clk_div is
        Generic (count_width : integer := 2500);
        Port ( clk_in : in STD_LOGIC;
               reset : in STD_LOGIC;
               clk_out : out STD_LOGIC);
    end component clk_div;
    component ring is
        Generic (N : integer range 1 to 31 := 3);
        Port ( clk_in : in STD_LOGIC;
               reset_in : in STD_LOGIC;
               output : out STD_LOGIC_VECTOR (N downto 0));
    end component ring;
    signal clk: std_logic;
    
begin

D1: clk_div generic map (count_width => 12500000)
            port map (clk_in=>clk_in, reset=>reset, clk_out=>clk);

D2: ring generic map (N => 15)
            port map (clk_in=>clk, reset_in=>reset, output=>output);

end Behavioral;
