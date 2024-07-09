----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineers: Ben Bush (bbu36)
--            Connor Grant (cgr107)
--            Rogan Ross (rro100)
-- Group:     RxnFriGroup7
-- 
-- Create Date: 06.05.2024 21:19:10
-- Design Name: Pseudo Random Number Generator Test Bench
-- Module Name: prng_tb - Behavioral
-- Project Name: ENEL373 Reaction Timer Project
-- Target Devices: Nexys-4 DDR FPGA board
-- Tool Versions: 
-- Description: The PRNG test bench is to test what the random 9-bit vector is
--              each clock cycle.
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity prng_tb is
end prng_tb;

architecture Behavioral of prng_tb is

signal SRCLK : std_logic := '0';
signal Q : std_logic_vector(8 downto 0); -- Output

begin

SRCLK <= not SRCLK after 5ns;            -- toggles clock every 5 nanoseconds

inst_prng : entity work.prng(Behavioral)
port map(SRCLK => SRCLK, Q => Q);

end Behavioral;
