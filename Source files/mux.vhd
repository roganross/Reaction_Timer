----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineers: Ben Bush, Connor Grant & Rogan Ross
-- Group:     RxnFriGroup7
-- 
-- Create Date: 10.03.2024 12:11:27
-- Module Name: mux - Behavioral
-- Project Name: Reaction Timer
-- Target Device: Nexys 4 DDR
-- Description: Uses a multiplexer to select the message to display on each digit
-- of the BCD.
-- Revision: 1
-- 
----------------------------------------------------------------------------------

-- Import libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Defines inputs & outputs
entity mux is
    port( 
        DISPLAY_SEL : in  STD_LOGIC_VECTOR (2 downto 0);
        MESSAGE     : in  STD_LOGIC_VECTOR (31 downto 0);
        BCD         : out STD_LOGIC_VECTOR (3 downto 0)
        );
end mux;

-- Behavioural structure
architecture Behavioral of mux is

begin

    -- Process sensitive to changing 'DISPLAY_SEL' value
    process (DISPLAY_SEL, MESSAGE) is
    begin
    -- Depending on the value of 'DISPLAY_SEL', the message to display is determined
        case DISPLAY_SEL is
            when "000" => BCD <= MESSAGE(3 downto 0);
            when "001" => BCD <= MESSAGE(7 downto 4);
            when "010" => BCD <= MESSAGE(11 downto 8);
            when "011" => BCD <= MESSAGE(15 downto 12);
            when "100" => BCD <= MESSAGE(19 downto 16);
            when "101" => BCD <= MESSAGE(23 downto 20);
            when "110" => BCD <= MESSAGE(27 downto 24);
            when "111" => BCD <= MESSAGE(31 downto 28);
            when others => NULL;
        end case;
    end process;                                                

end Behavioral;
