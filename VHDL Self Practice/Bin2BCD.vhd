----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2021 03:53:49
-- Design Name: 
-- Module Name: Bin2BCD - Behavioral
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

entity Bin2BCD is
    Port ( sum : in STD_LOGIC_VECTOR (4 downto 0);
           digits : out DIGIT_VECTOR (7 downto 0));
end Bin2BCD;

architecture Behavioral of Bin2BCD is

begin
    bin_2_bcd(sum, digits(1 downto 0));

end Behavioral;
