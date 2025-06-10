----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2021 13:42:16
-- Design Name: 
-- Module Name: debounce - Behavioral
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

entity debounce is
    Port ( clk :        in  STD_LOGIC;
           deb_in :     in  STD_LOGIC;
           deb_out :    out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
    signal output: std_logic :='0';
    constant delay: integer := 5;
begin
    process(clk)
    variable counts: integer range 0 to delay :=0;
    begin
        if clk'event and clk = '1' then
            if(deb_in = output) then
                counts := 0;
            else
                counts := counts +1;
                if(counts = delay) then
                    output <= deb_in;
                end if;
            end if;
        end if;
        deb_out <= output;
    end process;

end Behavioral;
