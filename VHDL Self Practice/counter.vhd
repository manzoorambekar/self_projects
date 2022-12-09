----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2021 22:26:03
-- Design Name: 
-- Module Name: counter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    Generic (count_width: integer := 9;
             bit_width: integer := 4);
            
    Port ( clk :        in STD_LOGIC;
           en_in :      in STD_LOGIC;
           en_out :     out STD_LOGIC;
           dir :        in STD_LOGIC;
           reset :      in STD_LOGIC;
           counts :     out STD_LOGIC_VECTOR (bit_width-1 downto 0));
end counter;

architecture Behavioral of counter is

begin

cnt:    process(clk, reset, en_in, dir)
        variable ticks: integer range 0 to count_width := 0;
begin
    if(reset = '0') then
        ticks :=0;
    elsif (clk'event and clk = '1') then
        if(en_in = '1') then
            if(dir = '1') then
                if(ticks = count_width) then
                    ticks := 0;
                else
                    ticks := ticks + 1;
                end if;
            else
                if(ticks = 0) then
                    ticks := count_width;
                else
                    ticks := ticks - 1;
                end if;
            end if;
        end if;
    end if;
    if(dir = '1' and ticks = 9) or (dir = '0' and ticks = 0) then
        en_out <= en_in;
    else
        en_out <= '0';
    end if;
    counts <= std_logic_vector(to_unsigned (ticks, counts'length));
end process;

end Behavioral;
