----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2021 00:11:40
-- Design Name: 
-- Module Name: my_package - Behavioral
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

package my_package is
type digit_vector is array( natural range<>) of std_logic_vector(3 downto 0);

procedure bin_2_bcd(    signal bin: std_logic_vector(4 downto 0);
                        signal digits: out digit_vector (1 downto 0));

component adder_4bit is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           C_in : in STD_LOGIC;
           Sum : out STD_LOGIC_VECTOR (4 downto 0));
end component adder_4bit;
component Bin2BCD is
    Port ( sum : in STD_LOGIC_VECTOR (4 downto 0);
           digits : out DIGIT_VECTOR (7 downto 0));
end component Bin2BCD;
component led_driver is
    Port ( digits :     in  DIGIT_VECTOR (7 downto 0);
           clk_in :     in  STD_LOGIC;
           reset :      in  STD_LOGIC;
           an_out :     out STD_LOGIC_VECTOR (7 downto 0);
           seg_out :    out STD_LOGIC_VECTOR (6 downto 0));
end component led_driver;     
component counter is
    Generic (count_width: integer := 9;
             bit_width: integer := 4);
            
    Port ( clk :        in STD_LOGIC;
           en_in :      in STD_LOGIC;
           en_out :     out STD_LOGIC;
           dir :        in STD_LOGIC;
           reset :   in STD_LOGIC;
           counts :     out STD_LOGIC_VECTOR (bit_width-1 downto 0));
end component counter;

component debounce is
    Port ( clk :        in  STD_LOGIC;
           deb_in :     in  STD_LOGIC;
           deb_out :    out STD_LOGIC);
end component debounce;        
end my_package;

package body my_package is
procedure bin_2_bcd(    signal bin: std_logic_vector(4 downto 0);
                        signal digits: out digit_vector (1 downto 0)) is

                        variable temp: std_logic_vector(4 downto 0) := bin;
                        variable bcd: unsigned (7 downto 0) := (others => '0');
begin
    for i in 0 to 4 loop
        if bcd(3 downto 0) > 4 then
            bcd(3 downto 0) := bcd(3 downto 0) + 3;
        end if;
        bcd := bcd(6 downto 0) & temp(4);
        temp := temp(3 downto 0) & '0';
    end loop;
    digits(0) <= std_logic_vector(bcd(3 downto 0));
    digits(1) <= std_logic_vector(bcd(7 downto 4));
end bin_2_bcd;
end my_package;

