----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineers: Ben Bush (bbu36)
--            Connor Grant (cgr107)
--            Rogan Ross (rro100)
-- Group:     RxnFriGroup7
-- 
-- Attribution: Based on clock_divider.vhd by Romain Arnal, UC ECE, provided as 
--              example code for the ENEL373 project.
-- 
-- Create Date: 08.03.2024 21:40:21
-- Design Name: Clock Divider
-- Module Name: clock_divider - Behavioral
-- Project Name: ENEL373 Reaction Timer Project
-- Target Devices: Nexys-4 DDR FPGA board
-- Tool Versions: 
-- Description: The clock divider is designed to take the boards internal clock 
--              and divide it down to the desired clock frequency by calculating 
--              and setting the required upper bound.
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

entity clock_divider is
	port(
		CLK        : in  STD_LOGIC;
		UPPERBOUND : in  STD_LOGIC_VECTOR (27 downto 0);
		SLOWCLK    : out STD_LOGIC
		);
end clock_divider;

architecture Behavioral of clock_divider is
	signal clk_ctr  : std_logic_vector (27 downto 0) := (others => '0');
	signal temp_clk : std_logic := '1';
begin
 
	process (CLK)
	begin
		if (rising_edge(CLK)) then
			if clk_ctr = UPPERBOUND then
				clk_ctr  <= (others => '0'); -- resets counter once upperbound is reached 
				temp_clk <= not temp_clk;    -- toggles temporary clock 
			else
				clk_ctr <= std_logic_vector(unsigned(clk_ctr) + 1); -- increments counter by 1
			end if;
		end if;
	end process;
	
	SLOWCLK <= temp_clk; -- links temporary clock to output slow clock
 
end Behavioral;

