----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineers: Ben Bush (bbu36)
--            Connor Grant (cgr107)
--            Rogan Ross (rro100)   
-- Group:     RxnFriGroup7 
-- 
-- Attribution: Based on code provided by Ciaran Moore, UC ECE, provided to be 
-- updated and verified for the ENEL373 project.
--
-- Create Date: 10.03.2024 11:12:56
-- Design Name: Cathode Decoder
-- Module Name: cathode_decoder - Behavioral
-- Project Name: ENEL373 Reaction Timer Project
-- Target Devices: Nexys-4 DDR FPGA board
-- Tool Versions: 
-- Description: The cathode decoder is to turn on the required segments that 
--  display the number, decimal point, or value corresponding to binary-coded 
--  decimal value inputted.
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

entity cathode_decoder is
    port( 
        BCD : in  STD_LOGIC_VECTOR (3 downto 0);
        SEG : out STD_LOGIC_VECTOR (7 downto 0)
        );
end cathode_decoder;

architecture Behavioral of cathode_decoder is

begin

    process (BCD) is
    begin
        case (BCD) is
            when "0000" => SEG(7 downto 0) <= "11000000"; -- 0
            when "0001" => SEG(7 downto 0) <= "11111001"; -- 1 
            when "0010" => SEG(7 downto 0) <= "10100100"; -- 2 
            when "0011" => SEG(7 downto 0) <= "10110000"; -- 3 
            when "0100" => SEG(7 downto 0) <= "10011001"; -- 4 
            when "0101" => SEG(7 downto 0) <= "10010010"; -- 5 
            when "0110" => SEG(7 downto 0) <= "10000010"; -- 6 
            when "0111" => SEG(7 downto 0) <= "11111000"; -- 7 
            when "1000" => SEG(7 downto 0) <= "10000000"; -- 8
            when "1001" => SEG(7 downto 0) <= "10011000"; -- 9
            when "1010" => SEG(7 downto 0) <= "10000110"; -- E
            when "1011" => SEG(7 downto 0) <= "11111111"; -- blank
            when "1100" => SEG(7 downto 0) <= "10101111"; -- r
            when "1101" => SEG(7 downto 0) <= "01111111"; -- decimal point
            when "1110" => SEG(7 downto 0) <= "10100011"; -- o
            when "1111" => SEG(7 downto 0) <= "01111101"; -- !
            when others => NULL;
         end case;
    end process; 
    
end Behavioral;