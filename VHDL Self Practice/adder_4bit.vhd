----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.11.2021 23:50:50
-- Design Name: 
-- Module Name: adder_4bit - Behavioral
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

entity adder_4bit is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           C_in : in STD_LOGIC;
           Sum : out STD_LOGIC_VECTOR (4 downto 0));
end adder_4bit;

architecture Behavioral of adder_4bit is

    component FullAdder is
    Port ( A    : in  STD_LOGIC;
           B    : in  STD_LOGIC;
           Cin  : in  STD_LOGIC;
           S    : out STD_LOGIC;
           Cout : out STD_LOGIC);
    end component FullAdder;
    signal C : std_logic_vector(2 downto 0);
begin

FA1: FullAdder port map (A=>A(0), B=>B(0), Cin=>C_in, S=>Sum(0), Cout=>C(0));
FA2: FullAdder port map (A=>A(1), B=>B(1), Cin=>C(0), S=>Sum(1), Cout=>C(1));
FA3: FullAdder port map (A=>A(2), B=>B(2), Cin=>C(1), S=>Sum(2), Cout=>C(2));
FA4: FullAdder port map (A=>A(3), B=>B(3), Cin=>C(2), S=>Sum(3), Cout=>Sum(4));

end Behavioral;
