----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2021 01:42:52
-- Design Name: 
-- Module Name: dec_to_7seg - Behavioral
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

entity dec_to_7seg is
    Port ( digit_in :       in  STD_LOGIC_VECTOR (3 downto 0);
           segment_out :    out STD_LOGIC_VECTOR (6 downto 0));
end dec_to_7seg;

architecture Behavioral of dec_to_7seg is

begin 
    process(digit_in)
    begin
        case digit_in is 
                    when x"0"   => segment_out <= "1000000";
                    when x"1"   => segment_out <= "1111001";
                    when x"2"   => segment_out <= "0100100";
                    when x"3"   => segment_out <= "0110000";
                    when x"4"   => segment_out <= "0011001";
                    when x"5"   => segment_out <= "0010010";
                    when x"6"   => segment_out <= "0000010";
                    when x"7"   => segment_out <= "1111000";
                    when x"8"   => segment_out <= "0000000";
                    when x"9"   => segment_out <= "0010000";
                    when others => segment_out <= "1111111";
        end case;
    end process;
end Behavioral;
