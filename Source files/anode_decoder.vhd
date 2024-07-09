----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineers: Ben Bush (bbu36)
--            Connor Grant (cgr107)
--            Rogan Ross (rro100)    
-- Group:     RxnFriGroup7
-- 
-- Create Date: 08.03.2024 21:40:21
-- Design Name: Anode Decoder
-- Module Name: anode_decoder - Behavioral
-- Project Name: ENEL373 Reaction Timer Project
-- Target Devices: Nexys-4 DDR FPGA board
-- Tool Versions: 
-- Description: The anode selector is a combinational decoder that outputs power 
--              to just one of the eight 7-segment display corresponding to what 
--              number the 3 bit counter is inputting. 
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
use IEEE.NUMERIC_STD.ALL;

entity anode_decoder is
    port( 
        DISPLAY_SEL : in  STD_LOGIC_VECTOR (2 downto 0);
        ANODE       : out STD_LOGIC_VECTOR (7 downto 0)
       );
end anode_decoder;

architecture Behavioral of anode_decoder is

begin
    process (DISPLAY_SEL)
    begin
        case DISPLAY_SEL is
            when "000"  => ANODE <= "11111110"; -- Anodes are active low and in order
            when "001"  => ANODE <= "11111101"; -- ANODE[1] is lit up and the rest are off
            when "010"  => ANODE <= "11111011";
            when "011"  => ANODE <= "11110111";
            when "100"  => ANODE <= "11101111";
            when "101"  => ANODE <= "11011111";
            when "110"  => ANODE <= "10111111";
            when "111"  => ANODE <= "01111111";
            when others => ANODE <= (others => '0');
        end case;
    end process;
            
end Behavioral;
