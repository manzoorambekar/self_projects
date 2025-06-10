----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2021 12:58:51
-- Design Name: 
-- Module Name: ring - Behavioral
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

entity ring is
    Generic (N : integer range 1 to 31 := 3);
    Port ( clk_in : in STD_LOGIC;
           reset : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (N downto 0));
end ring;

architecture Behavioral of ring is

begin
    count: process(clk_in , reset)
    
    variable data : std_logic_vector (N downto 0) := (0=>'0', others => '1');
    begin
    if(reset = '0') then 
        data := (0=>'0', others => '1');
    elsif(clk_in 'event and clk_in = '1') then
        data := data(N-1 downto 0) & data(N);
    end if;
    output <= data;
end process;

end Behavioral;
