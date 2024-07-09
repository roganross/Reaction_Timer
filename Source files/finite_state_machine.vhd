----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineers: Ben Bush (bbu36)
--            Connor Grant (cgr107)
--            Rogan Ross (rro100) 
-- Group:     RxnFriGroup7
--
-- Attribution: Based on finite_state_machine.vhd by Romain Arnal, UC ECE, provided as 
--              example code for the ENEL373 project.
-- 
-- Create Date: 11.03.2024 19:23:10
-- Design Name: Finite State Machine
-- Module Name: finite_state_machine - Behavioral
-- Project Name: ENEL373 Reaction Timer Project
-- Target Devices: Nexys-4 DDR FPGA board
-- Tool Versions: 
-- Description: The finite state machine is to provide the count down states, 
--              displaying dots corresponding to the countdown, as well as the 
--              timing and reaction time. The machine resets back to the countdown 
--              states from displaying reaction time state.
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

entity finite_state_machine is
    port( 
        CLK, RESET                     : in  STD_LOGIC; 
        BTNC, BTNU, BTND, BTNR         : in  STD_LOGIC;
        COUNT1, COUNT2, COUNT3, COUNT4 : in  STD_LOGIC_VECTOR (3 downto 0);
        RANDOM                         : in  STD_LOGIC_VECTOR (8 downto 0);
        STAT_DATA                      : in  STD_LOGIC_VECTOR (15 downto 0);
        STAT                           : out STD_LOGIC_VECTOR (1 downto 0);
        LED                            : out STD_LOGIC_VECTOR (2 downto 0); 
        COUNT_EN, COUNT_RST            : out STD_LOGIC;  
        SHIFT_EN                       : out STD_LOGIC;
        MESSAGE                        : out STD_LOGIC_VECTOR (31 downto 0)
        );
end finite_state_machine;

architecture Behavioral of finite_state_machine is
    type state_type is (warning_3, warning_2, warning_1, counting, printing, min, max, mean, buffer_state, error);
    signal current_state, next_state : state_type := warning_3;
    constant T1: natural := 1000 ;
    signal t: natural range 0 to T1-1;
    signal shift_enabled : std_logic := '0';
    signal random_3 : natural;
    signal random_2 : natural;
    signal random_1 : natural;
begin

    STATE_REGISTER: process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RESET = '0') then
                current_state <= warning_3;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    OUTPUT_DECODE: process (current_state, COUNT4, COUNT3, COUNT2, COUNT1, random_3, random_2, random_1)
    begin
        case (current_state) is
            when warning_3 =>
                COUNT_EN  <= '0';
                COUNT_RST <= '1';
                SHIFT_EN <= '0';
                MESSAGE <= X"bbbbbddd"; -- displays three dots
                random_3 <= random_3;
                random_2 <= to_integer(unsigned(RANDOM)) + 480; -- updates random time for 2 decimals with a lower bound of 480 seconds
                random_1 <= random_1;
                LED <= "000";
            when warning_2 =>
                COUNT_EN  <= '0';
                COUNT_RST <= '0';
                SHIFT_EN <= '0';
                MESSAGE <= X"bbbbbbdd"; -- displays two dots
                random_3 <= random_3;
                random_2 <= random_2;
                random_1 <= to_integer(unsigned(RANDOM)) + 480; -- updates random time for 1 decimal with a lower bound of 480 seconds
                LED <= "000";
            when warning_1 =>
                COUNT_EN  <= '0';
                COUNT_RST <= '0';
                SHIFT_EN <= '0';
                MESSAGE <= X"bbbbbbbd"; -- displays one dot
                random_3 <= random_3;
                random_2 <= random_2;
                random_1 <= random_1;
                LED <= "000";
            when counting =>
                COUNT_EN  <= '1'; -- starts the timer
                COUNT_RST <= '0';
                SHIFT_EN <= '0';
                MESSAGE(31 downto 16) <= (others => '0') ;
                MESSAGE(15 downto 0) <=  COUNT4 & COUNT3 & COUNT2 & COUNT1;
                random_3 <= random_3;
                random_2 <= random_2;
                random_1 <= random_1;
                LED <= "000";
            when printing =>
                COUNT_EN  <= '0'; -- stops the timer
                COUNT_RST <= '0';
                SHIFT_EN <= '1'; -- stores the timer value 
                MESSAGE(31 downto 16) <= (others => '0') ;
                MESSAGE(15 downto 0) <=  COUNT4 & COUNT3 & COUNT2 & COUNT1;
                random_3 <= random_3;
                random_2 <= random_2;
                random_1 <= random_1;
                LED <= "000";
            when min =>
                COUNT_EN  <= '0';
                COUNT_RST <= '0';
                SHIFT_EN <= '0';
                STAT <= "01"; -- sets value to be the min
                MESSAGE(31 downto 16) <= (others => '0') ;
                MESSAGE(15 downto 0) <= STAT_DATA;
                random_3 <= random_3;
                random_2 <= random_2;
                random_1 <= random_1;
                LED <= "001"; -- lightens LED[0] to indicate min value
            when max =>
                COUNT_EN  <= '0';
                COUNT_RST <= '0';
                SHIFT_EN <= '0';
                STAT <= "10"; -- sets value to be the max
                MESSAGE(31 downto 16) <= (others => '0') ;
                MESSAGE(15 downto 0) <= STAT_DATA;
                random_3 <= random_3;
                random_2 <= random_2;
                random_1 <= random_1;
                LED <= "100"; -- lightens LED[2] to indicate max value
            when mean =>
                COUNT_EN  <= '0';
                COUNT_RST <= '0';
                SHIFT_EN <= '0';
                STAT <= "11"; -- sets value to be the mean
                MESSAGE(31 downto 16) <= (others => '0') ;
                MESSAGE(15 downto 0) <= STAT_DATA;
                random_3 <= random_3;
                random_2 <= random_2;
                random_1 <= random_1;
                LED <= "010"; -- lightens LED[1] to indicate mean value
            when buffer_state =>
                COUNT_EN  <= '0';
                COUNT_RST <= '0';
                SHIFT_EN <= '0';
                MESSAGE <= X"bbbbbddd";   
                random_3 <= to_integer(unsigned(RANDOM)) + 480; -- updates random time for 3 decimals with a lower bound of 480 seconds
                random_2 <= random_2;
                random_1 <= random_1; 
                LED <= "000";     
            when error =>
                COUNT_EN  <= '0';
                COUNT_RST <= '0';
                SHIFT_EN <= '0';
                MESSAGE <= X"bbaccecf"; -- display error message "Error!"
                random_3 <= random_3;
                random_2 <= random_2;
                random_1 <= random_1;
                LED <= "000";
            when others =>
                COUNT_EN  <= '0';
                COUNT_RST <= '1';
                SHIFT_EN <= '0';
                MESSAGE <= X"bbbbbbbb"; -- displays blank screen
                random_3 <= random_3;
                random_2 <= random_2;
                random_1 <= random_1;
                LED <= "000";
        end case;
    end process;

    
    NEXT_STATE_DECODE: process (current_state, t, BTNC, BTNU, BTND, BTNR)
    begin
        case (current_state) is
            when warning_3 =>
                if BTNC = '1' then
                    next_state <= error;
                elsif t >= random_3 then
                    next_state <= warning_2; -- switches of decimal 3 when the random time 3 has past
                else
                    next_state <= warning_3;
                end if;
            when warning_2 =>
                if BTNC = '1' then
                    next_state <= error;
                elsif t >= random_2 then
                    next_state <= warning_1; -- switches of decimal 2 when the random time 2 has past
                else
                    next_state <= warning_2;
                end if;
            when warning_1 =>
                if BTNC = '1' then
                    next_state <= error;
                elsif t >= random_1 then
                    next_state <= counting; -- starts counting when random time 1 has past
                else
                    next_state <= warning_1;
                end if;
            when counting =>
                if BTNC = '1' then
                    next_state <= printing; -- stops the timer and displays the time
                else
                    next_state <= counting;
                end if;
            when printing =>
                if (BTNC = '1' and t >= 999) then
                    next_state <= buffer_state;
                elsif (BTNU = '1') then
                    next_state <= max;
                elsif (BTND = '1') then
                    next_state <= min;
                elsif (BTNR = '1') then
                    next_state <= mean;
                else
                    next_state <= printing;
                end if;
            when min => 
                if (BTNC = '1') then
                    next_state <= buffer_state;
                elsif (BTNU = '1') then
                    next_state <= max;
                elsif (BTNR = '1') then
                    next_state <= mean;
                else
                    next_state <= min;
                end if;
            when max => 
                if (BTNC = '1') then
                    next_state <= buffer_state;
                elsif (BTND = '1') then
                    next_state <= min;
                elsif (BTNR = '1') then
                    next_state <= mean;
                else
                    next_state <= max;
                end if;
            when mean =>
                if (BTNC = '1') then
                    next_state <= buffer_state;
                elsif (BTND = '1') then
                    next_state <= min;
                elsif (BTNU = '1') then
                    next_state <= max;
                else
                    next_state <= mean;
                end if;
            when buffer_state =>                
                if (BTNC = '0') then
                    next_state <= warning_3;
                else
                    next_state <= buffer_state;              
                end if;
            when error =>
                if t >= 999 then
                    next_state <= warning_3;
                else
                    next_state <= error;
                end if;
            when others =>
                next_state <= current_state;
        end case;
    end process;

    TIMER: process (CLK)
    begin
        if rising_edge(CLK) then
            if current_state /= next_state then
                t <= 0;
            elsif t /= T1-1 then
                t <= t + 1;
            end if;
        end if;
    end process;

    

end Behavioral;
