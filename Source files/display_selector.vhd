----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineers: Ben Bush (bbu36)
--            Connor Grant (cgr107)
--            Rogan Ross (rro100)   
-- Group:     RxnFriGroup7         
-- 
-- Create Date: 08.03.2024 21:40:21
-- Design Name: Display Selector
-- Module Name: display_selector - Behavioral
-- Project Name: ENEL373 Reaction Timer Project
-- Target Devices: Nexys-4 DDR FPGA board
-- Tool Versions: 
-- Description: The display selector is to take in a set clock rate and count from 
--              0 to 7 outputing the full counter value. It is to be used to 
--              select which 7-segment should be lit up.
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

entity display_selector is
    port( 
        DISPLAY_CLK     : in  STD_LOGIC;
        CURRENT_DISPLAY : out STD_LOGIC_VECTOR (2 downto 0)
        );
end display_selector;

architecture Behavioral of display_selector is

   signal count_tmp: std_logic_vector (2 downto 0) := (others => '0');  
    
begin
    
    process (DISPLAY_CLK)
    begin
        if rising_edge(DISPLAY_CLK) then
            count_tmp <= std_logic_vector(unsigned(count_tmp) + 1); -- increases count of 3 bit counter by 1
        end if;
    end process;
    
    CURRENT_DISPLAY <= count_tmp;
    
end Behavioral;
