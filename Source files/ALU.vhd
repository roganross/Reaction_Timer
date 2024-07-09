----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineers: Ben Bush, Connor Grant & Rogan Ross
-- Group:     RxnFriGroup7
-- 
-- Create Date: 08.05.2024 18:33:45
-- Design Name: ALU
-- Module Name: ALU - Behavioral
-- Project Name: ENEL373 Reaction Timer Project
-- Target Devices: Nexys-4 DDR FPGA board
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: The ALU module is designed to perform basic arithmetic and 
-- logical operations on input data and provide the result based on the control 
-- signal (STAT).
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port ( 
           DATA_A, DATA_B, DATA_C : in  STD_LOGIC_VECTOR (15 downto 0);
           STAT                   : in  STD_LOGIC_VECTOR (1 downto 0);
           DATA_OUT               : out STD_LOGIC_VECTOR (15 downto 0));
end ALU;

architecture Behavioral of ALU is

signal max  : std_logic_vector(15 downto 0);
signal min  : std_logic_vector(15 downto 0);
signal mean : std_logic_vector(15 downto 0);

begin

min_process: process(DATA_A, DATA_B, DATA_C)
    begin
        if (DATA_C = "0000000000000000") then
            if (DATA_B = "0000000000000000") then 
                min <= DATA_A; -- min is DATA_A if it is the only non zero value
            elsif (DATA_B < DATA_A) then
                min <= DATA_B;
            else
                min <= DATA_A;
            end if;
        elsif (DATA_B < DATA_A and DATA_B < DATA_C) then 
            min <= DATA_B;
        elsif (DATA_C < DATA_A and DATA_C < DATA_B) then
            min <= DATA_C;
        else
            min <= DATA_A;
        end if;
    end process min_process;
                
max_process: process(DATA_A, DATA_B, DATA_C)
    begin
        if (DATA_B >= DATA_A and DATA_B >= DATA_C and (DATA_B /= "000000000000000")) then
            max <= DATA_B;
        elsif (DATA_C >= DATA_A and DATA_C >= DATA_B and (DATA_C /= "000000000000000")) then
            max <= DATA_C;
        else
            max <= DATA_A; -- max is DATA_A if it is the only non zero value  
        end if;
    end process max_process;
    
mean_process : process(DATA_A, DATA_B, DATA_C)
variable temp_A : natural;
variable temp_B : natural;
variable temp_C : natural;
variable avg    : natural;
    begin 
        temp_A := to_integer(unsigned(DATA_A(15 downto 12))) * 1000 + 
                  to_integer(unsigned(DATA_A(11 downto 8))) * 100 + 
                  to_integer(unsigned(DATA_A(7 downto 4))) * 10 + 
                  to_integer(unsigned(DATA_A(3 downto 0))); 
                  
        temp_B := to_integer(unsigned(DATA_B(15 downto 12))) * 1000 + 
                  to_integer(unsigned(DATA_B(11 downto 8))) * 100 + 
                  to_integer(unsigned(DATA_B(7 downto 4))) * 10 + 
                  to_integer(unsigned(DATA_B(3 downto 0))); 
                  
        temp_C := to_integer(unsigned(DATA_C(15 downto 12))) * 1000 + 
                  to_integer(unsigned(DATA_C(11 downto 8))) * 100 + 
                  to_integer(unsigned(DATA_C(7 downto 4))) * 10 + 
                  to_integer(unsigned(DATA_C(3 downto 0)));     
   
        if (DATA_C = "0000000000000000") then
            if (DATA_B = "0000000000000000") then 
                mean <= DATA_A; -- mean is DATA_A if it is the only non zero value
            else
                avg := (temp_A + temp_B) / 2;
                mean <= std_logic_vector(to_unsigned(avg/1000,4)) & 
                    std_logic_vector(to_unsigned((avg-(avg/1000)*1000)/100,4)) & 
                    std_logic_vector(to_unsigned((avg-(avg/100)*100)/10,4)) & 
                    std_logic_vector(to_unsigned((avg-(avg/10)*10),4));
            end if;
        else
            avg := (temp_A + temp_B + temp_C) / 3;
            mean <= std_logic_vector(to_unsigned(avg/1000,4)) & 
                    std_logic_vector(to_unsigned((avg-(avg/1000)*1000)/100,4)) & 
                    std_logic_vector(to_unsigned((avg-(avg/100)*100)/10,4)) & 
                    std_logic_vector(to_unsigned((avg-(avg/10)*10),4));
        end if;
  end process;              
    
stat_process: process(STAT)
    begin
        case STAT is
            when "00"  => DATA_OUT <= (others => '0');
            when "01"  => DATA_OUT <= min; 
            when "10"  => DATA_OUT <= max;
            when "11"  => DATA_OUT <= MEAN;
            when others => DATA_OUT <= (others => '0');
        end case;
    end process;

end Behavioral;
