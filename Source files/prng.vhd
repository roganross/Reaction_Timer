----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineers: Ben Bush (bbu36)
--            Connor Grant (cgr107)
--            Rogan Ross (rro100)
-- Group:     RxnFriGroup7
-- 
-- Create Date: 06.05.2024 20:39:26
-- Design Name: Pseudo Random Number Generator
-- Module Name: prng - Behavioral
-- Project Name: ENEL373 Reaction Timer Project
-- Target Devices: Nexys-4 DDR FPGA board
-- Tool Versions: 
-- Description: The PRNG begins with a seed and uses a linear feedback shift register
--              in conjunction to generate new serial bits. This will then output a 
--              random sequence of bits.
-- 
-- Dependencies: 
-- 
-- Revision: Final
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity prng is
    port(
        SRCLK : in  STD_LOGIC;                      -- clock input for triggering the PRNG
        Q     : out STD_LOGIC_VECTOR (8 downto 0)   --output for the pseudo-random sequence
       );
end prng;

architecture Behavioral of prng is
signal shift_register : std_logic_vector(8 downto 0) := "000010001"; -- initialise shift register with seed
signal serial : std_logic;                                           -- temporary storage for computed serial bit

begin
    
    -- generate the next bit in the psuedo-random sequence
    serial <= (shift_register(1) XOR shift_register(2)) XOR (shift_register(3) XOR shift_register(7)); 
    
    NEXT_RANDOM_NUMBER: process (SRCLK)
    begin 

        if rising_edge(SRCLK) then
            -- shifts the register contents to the right by one bit and appends the newly computed bit
            shift_register <= shift_register(7 downto 0) & serial;
        end if;
    end process;
    
    -- outputs the psudo-random sequence
    Q <= shift_register;

end Behavioral;
