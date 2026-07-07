----------------------------------------------------------------------------
-- Entity:        Debounce
-- Written By:    Adyn Pontier
-- Date Created:  6 Jul 26
-- Description:   VHDL model of a debouncer
--
-- Revision History (date, initials, description):
--
-- Dependencies:
--   (none)
----------------------------------------------------------------------------
library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;

----------------------------------------------------------------------------
entity Debounce is
    port (
        D     : in  STD_LOGIC;
        CLK   : in  STD_LOGIC;
        PULSE : in  STD_LOGIC;
        Q     : out STD_LOGIC
    );
end entity;
----------------------------------------------------------------------------

architecture Structural of Debounce is
    component DFF_EN_RESET
        Port ( 
               D     : in  STD_LOGIC;
               CLK   : in  STD_LOGIC;
               EN    : in  STD_LOGIC;
               RESET : in  STD_LOGIC;
               Q     : out STD_LOGIC);
    end component;
    
    signal D2, Q2 : STD_LOGIC;
begin
    FF1: DFF_EN_RESET port map (
        D     => D,
        CLK   => CLK,
        EN    => PULSE,
        RESET => '0',    
        Q     => D2
    );
    
    FF2: DFF_EN_RESET port map (
        D     => D2,
        CLK   => CLK,
        EN    => PULSE,
        RESET => '0',    
        Q     => Q2
    );
    
    Q <= D2 AND Q2;
end architecture;