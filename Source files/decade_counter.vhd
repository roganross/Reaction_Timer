----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineers: Ben Bush, Connor Grant & Rogan Ross
-- Group:     RxnFriGroup7
-- 
-- Create Date: 11.03.2024 14:07:05
-- Design Name: Decade Counter
-- Module Name: decade_counter - Behavioral
-- Project Name: Reaction Timer
-- Target Device: Nexys 4 DDR
-- Description: Decade counter that counts a decade (0-9), once counted toggles
--              & resets to count again.
-- Revision: 1
-- 
----------------------------------------------------------------------------------

-- Import libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Defines inputs & outputs
entity decade_counter is
    port( 
        EN        : in  STD_LOGIC;
        RESET     : in  STD_LOGIC;
        INCREMENT : in  STD_LOGIC;
        COUNT     : out STD_LOGIC_VECTOR (3 downto 0);
        TICK      : out STD_LOGIC
        );
end decade_counter;

-- Behavioural structure & signals defined
architecture Behavioral of decade_counter is
signal toggle  : std_logic := '0';
signal counter : std_logic_vector (3 downto 0) := (others => '0');

begin

    -- Linking signals to outputs
    TICK  <= toggle;
    COUNT <= counter;
    
    -- Process sensitive to changing 'INCREMENT' & 'RESET' values
    process (INCREMENT, RESET, EN) is
    begin
        -- When RESET is TRUE the counter is reset to all 0s
        if (RESET = '1') then
            counter <= (others => '0');
            toggle  <= '0';
        -- When the counter is enabled a rising edge is detected a counter is incremented
        -- unless it is of a value of 9 which toggles 'toggle' & clears the counter.
        elsif (EN = '1' and rising_edge(INCREMENT)) then
            if (counter = "1001") then
                counter <= (others => '0');
                toggle  <= '1';          
            else
                counter <= std_logic_vector(unsigned(counter) + 1);
                toggle  <= '0';
            end if;
        end if;
    end process;

end Behavioral;

