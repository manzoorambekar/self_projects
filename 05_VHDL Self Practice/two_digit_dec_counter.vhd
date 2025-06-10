----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.12.2021 13:16:33
-- Design Name: 
-- Module Name: 2_digit_dec_counter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity two_digit_dec_counter is
    Port ( en_in    :   in  STD_LOGIC := '0';
           count_in :   in  STD_LOGIC;
           dir      :   in  STD_LOGIC;
           clk_in   :   in  STD_LOGIC;
           reset_in :   in  STD_LOGIC;
           an_out   :   out STD_LOGIC_VECTOR (7 downto 0);
           seg_out  :   out STD_LOGIC_VECTOR (6 downto 0) );
end two_digit_dec_counter;

architecture Behavioral of two_digit_dec_counter is

-- Signals for module interconnections
signal      deb_in, deb_out :   std_logic      := '0';
signal      clk             :   std_logic      := '0';
signal      en, en_out      :   std_logic;
signal      digit_0         :   std_logic_vector(3 downto 0);
signal      digit_1         :   std_logic_vector(3 downto 0);
signal      digits          :   DIGIT_VECTOR(7 downto 0) := (others => x"F");

begin
-- Components port interconnections
U1: debounce    port map    (   clk     => clk_in, 
                                deb_in  => count_in, 
                                deb_out => deb_out);
                                
U2: counter     generic map (   count_width => 9, 
                                bit_width   => 4)
                port map    (   clk    => deb_out, 
                                dir    => dir, 
                                reset  => reset_in,
                                en_in  => en_in, 
                                en_out => en,
                                counts => digits(0));
                                
U3: counter     generic map (   count_width => 9, 
                                bit_width   => 4)
                port map    (   clk    => deb_out, 
                                dir    => dir, 
                                reset  => reset_in,
                                EN_in  => en, 
                                en_out => en_out,
                                counts => digits(1));

U4: led_driver  port map    (   digits  => digits,
                                reset   => reset_in,
                                clk_in  => clk_in,
                                an_out  => an_out,
                                seg_out => seg_out);

end Behavioral; 
