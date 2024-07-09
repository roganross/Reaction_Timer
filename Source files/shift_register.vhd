----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineers: Ben Bush, Connor Grant & Rogan Ross
-- Group:     RxnFriGroup7
-- 
-- Create Date: 07.05.2024 15:16:03
-- Design Name: Shift Register
-- Module Name: shift_register - Behavioral
-- Project Name: ENEL373 Reaction Timer Project
-- Target Devices: Nexys-4 DDR FPGA board
-- Tool Versions: 
-- Description: The shift register consists 3 different stages that each store a 
--  16-bit vector. It it loads a new value in when shift is enabled, and can be 
--  reset
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

entity shift_register is
    port ( 
           SHIFT_EN : in STD_LOGIC;                                             
           RESET : in STD_LOGIC;
           COUNT1, COUNT2, COUNT3, COUNT4 : in  STD_LOGIC_VECTOR (3 downto 0);
           DATA_A : out STD_LOGIC_VECTOR(15 downto 0); 
           DATA_B : out STD_LOGIC_VECTOR(15 downto 0);
           DATA_C : out STD_LOGIC_VECTOR(15 downto 0));

end shift_register;

architecture Behavioral of shift_register is

signal A_reg : std_logic_vector(15 downto 0) := (others => '0');
signal B_reg : std_logic_vector(15 downto 0) := (others => '0');
signal C_reg : std_logic_vector(15 downto 0) := (others => '0');

begin
    
    reg_process: process(SHIFT_EN, RESET)
    begin 
        if(RESET = '1') then
            A_reg <= (others => '0'); -- resets the registers
            B_reg <= (others => '0');
            C_reg <= (others => '0');
        elsif (rising_edge(SHIFT_EN)) then
            A_reg <= COUNT4 & COUNT3 & COUNT2 & COUNT1; -- shifts in new load
            B_reg <= A_reg; -- shifts values to next spot
            C_reg <= B_reg; 
                
        end if;
    end process reg_process;
                
    DATA_A <= A_reg;
    DATA_B <= B_reg;
    DATA_C <= C_reg;        
    
end Behavioral;
