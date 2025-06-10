----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.11.2021 19:50:21
-- Design Name: 
-- Module Name: FullAdder - Behavioral
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

entity FullAdder is
    Port ( A    : in  STD_LOGIC;
           B    : in  STD_LOGIC;
           Cin  : in  STD_LOGIC;
           S    : out STD_LOGIC;
           Cout : out STD_LOGIC);
end FullAdder;

architecture Behavioral of FullAdder is
component HalfAdder is
    Port ( A     : in  STD_LOGIC;
           B     : in  STD_LOGIC;
           Sum   : out STD_LOGIC;
           Carry : out STD_LOGIC);
end component HalfAdder;

signal S1, C1, C2 : std_logic;

begin

    HA1: HalfAdder port map(A=>A, B=>B, Sum=>S1, Carry=>C1);
    HA2: HalfAdder port map(A=>S1, B=>Cin, Sum=>S, Carry=>C2);
    Cout <= C1 or C2;

end Behavioral;
