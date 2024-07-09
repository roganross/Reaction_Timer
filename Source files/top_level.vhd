----------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineers: Ben Bush (bbu36)
--            Connor Grant (cgr107)
--            Rogan Ross (rro100)   
-- Group:     RxnFriGroup7 
-- 
-- Create Date: 11.03.2024 20:34:38
-- Design Name: Top Level
-- Module Name: top_level - Behavioral
-- Project Name: ENEL373 Reaction Timer Project
-- Target Devices: Nexys-4 DDR FPGA board
-- Tool Versions: 
-- Description: Top-level module integrating all components for the ENEL373 
--              Reaction Timer Project.
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

entity top_level is
    Port ( CLK100MHZ  : in  STD_LOGIC;                                        
           CPU_RESETN : in  STD_LOGIC;
           BTNC       : in  STD_LOGIC;
           BTNU       : in  STD_LOGIC;
           BTND       : in  STD_LOGIC;
           BTNL       : in  STD_LOGIC;
           BTNR       : in  STD_LOGIC;
           CA         : out STD_LOGIC;
           CB         : out STD_LOGIC;
           CC         : out STD_LOGIC;
           CD         : out STD_LOGIC;
           CE         : out STD_LOGIC;
           CF         : out STD_LOGIC;
           CG         : out STD_LOGIC;
           DP         : out STD_LOGIC;
           AN         : out STD_LOGIC_VECTOR (7 downto 0);
           LED        : out STD_LOGIC_VECTOR (2 downto 0));
end top_level;

architecture Behavioral of top_level is

    constant DISPLAYCLK_UPPERBOUND_value : std_logic_vector (27 downto 0) := X"000C350"; -- Frequency of 1000Hz
    signal DISPLAYCLK_internal : std_logic; 
    signal DISPLAY_SEL_internal : std_logic_vector(2 downto 0);

    constant COUNTERCLK_UPPERBOUND_value : std_logic_vector(27 downto 0) := X"000C350"; -- Frequency of 1000Hz
    signal COUNTERCLK_internal : std_logic; 
    
    constant SRCLK_UPPERBOUND_value : std_logic_vector(27 downto 0) := X"000C350"; -- Frequency of 1000Hz
    signal SRCLK_internal : std_logic; 
    
    signal MESSAGE_internal : std_logic_vector(31 downto 0);
    signal COUNT_EN_internal : std_logic;
    signal COUNT_RST_internal : std_logic; 
    
    signal COUNT1 : std_logic_vector(3 downto 0) := "0000";
    signal COUNT2 : std_logic_vector(3 downto 0) := "0000";
    signal COUNT3 : std_logic_vector(3 downto 0) := "0000";
    signal COUNT4 : std_logic_vector(3 downto 0) := "0000";
    
    signal RANDOM_internal : std_logic_vector(8 downto 0);
    
    signal TICK1 : std_logic;
    signal TICK2 : std_logic;
    signal TICK3 : std_logic;
    signal TICK4 : std_logic;
    
    signal BCD_internal : std_logic_vector(3 downto 0);
    signal SEG_internal : std_logic_vector(7 downto 0);
    
    signal DATA_A : std_logic_vector(15 downto 0);
    signal DATA_B : std_logic_vector(15 downto 0);
    signal DATA_C : std_logic_vector(15 downto 0);
    signal SHIFT_EN_internal : std_logic;
    
    signal STAT_DATA : std_logic_vector(15 downto 0);
    signal STAT : std_logic_vector(1 downto 0);

begin

    inst_display_clock : entity work.clock_divider(Behavioral)
        port map(CLK => CLK100MHZ, UPPERBOUND => DISPLAYCLK_UPPERBOUND_value, SLOWCLK => DISPLAYCLK_internal);

    inst_display_selector : entity work.display_selector(Behavioral)
        port map(DISPLAY_CLK => DISPLAYCLK_internal, CURRENT_DISPLAY => DISPLAY_SEL_internal);
        
    inst_anode_decoder : entity work.anode_decoder(Behavioral)
        port map(DISPLAY_SEL => DISPLAY_SEL_internal, ANODE => AN);
    
    inst_mux : entity work.mux(Behavioral)    
        port map(DISPLAY_SEL => DISPLAY_SEL_internal, MESSAGE => MESSAGE_internal, BCD => BCD_internal);
    
    inst_cathode_decoder : entity work.cathode_decoder(Behavioral)
        port map(BCD => BCD_internal, SEG => SEG_internal);
        
    inst_decade_counter_1 : entity work.decade_counter(Behavioral)
        port map(EN => COUNT_EN_internal, RESET => COUNT_RST_internal, INCREMENT => COUNTERCLK_internal, COUNT => COUNT1, TICK => TICK1);
        
    inst_decade_counter_2 : entity work.decade_counter(Behavioral)
        port map(EN => COUNT_EN_internal, RESET => COUNT_RST_internal, INCREMENT => TICK1, COUNT => COUNT2, TICK => TICK2);
        
    inst_decade_counter_3 : entity work.decade_counter(Behavioral)
        port map(EN => COUNT_EN_internal, RESET => COUNT_RST_internal, INCREMENT => TICK2, COUNT => COUNT3, TICK => TICK3);
        
    inst_decade_counter_4 : entity work.decade_counter(Behavioral)  
        port map(EN => COUNT_EN_internal, RESET => COUNT_RST_internal, INCREMENT => TICK3, COUNT => COUNT4, TICK => TICK4);
    
    inst_counter_clock : entity work.clock_divider(Behavioral)
        port map(CLK => CLK100MHZ, UPPERBOUND => COUNTERCLK_UPPERBOUND_value, SLOWCLK => COUNTERCLK_internal);
        
    inst_finite_state_machine : entity work.finite_state_machine(Behavioral)
        port map(CLK => COUNTERCLK_internal, RESET => CPU_RESETN, 
                 BTNC => BTNC, BTNU => BTNU, BTND => BTND, BTNR => BTNR,
                 COUNT1 => COUNT1, COUNT2 => COUNT2, COUNT3 => COUNT3, COUNT4 => COUNT4,
                 RANDOM => RANDOM_internal, STAT_DATA => STAT_DATA, STAT => STAT,
                 LED => LED, COUNT_EN => COUNT_EN_internal, COUNT_RST => COUNT_RST_internal,
                 SHIFT_EN => SHIFT_EN_internal,
                 MESSAGE => MESSAGE_internal);
                 
    inst_prng_clock : entity work.clock_divider(Behavioral)
    port map(CLK => CLK100MHZ, UPPERBOUND => SRCLK_UPPERBOUND_value, SLOWCLK => SRCLK_internal);           
                 
    inst_prng : entity work.prng(Behavioral)
    port map(SRCLK => COUNTERCLK_internal, Q => RANDOM_internal);       
                 
    inst_shift_register : entity work.shift_register(Behavioral)
    port map(RESET => BTNL, SHIFT_EN => SHIFT_EN_internal,
             COUNT1 => COUNT1, COUNT2 => COUNT2, COUNT3 => COUNT3, COUNT4 => COUNT4,
             DATA_A => DATA_A, DATA_B => DATA_B, DATA_C => DATA_C);
             
    inst_ALU : entity work.ALU(Behavioral)
    port map(DATA_A => DATA_A, DATA_B => DATA_B, DATA_C => DATA_C,
             STAT => STAT, DATA_OUT => STAT_DATA);
    
        CA <= SEG_internal(0);
        CB <= SEG_internal(1);
        CC <= SEG_internal(2);
        CD <= SEG_internal(3);
        CE <= SEG_internal(4);
        CF <= SEG_internal(5);
        CG <= SEG_internal(6);
        DP <= SEG_internal(7);          

end Behavioral;
