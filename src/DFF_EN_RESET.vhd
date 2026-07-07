----------------------------------------------------------------------------
-- Entity:        DFF_EN_RESET
-- Written By:    E. George Walters
-- Date Created:  9 Feb 19
-- Description:   VHDL model of a D flip-flop with enable and reset
--
-- Revision History (date, initials, description):
--
-- Dependencies:
--   (none)
----------------------------------------------------------------------------
library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;

----------------------------------------------------------------------------
entity DFF_EN_RESET is
    port (
        D     : in  STD_LOGIC;
        CLK   : in  STD_LOGIC;
        EN    : in  STD_LOGIC;
        RESET : in  STD_LOGIC;
        Q     : out STD_LOGIC
    );
end entity;
----------------------------------------------------------------------------

architecture Structural of DFF_EN_RESET is

component DFF
        port (
            D    : in  STD_LOGIC;
            CLK  : in  STD_LOGIC;
            Q    : out STD_LOGIC
        );
    end component;
    
component Mux2to1
            port (
                D0   : in  STD_LOGIC;
                D1   : in  STD_LOGIC;
                SEL  : in  STD_LOGIC;
                Y    : out STD_LOGIC
            );
        end component;
        
 signal Q_int  : STD_LOGIC;
 signal mux_out : STD_LOGIC;
 signal sel     : STD_LOGIC;
 signal enabled     : STD_LOGIC;
 
begin

enabled <= D when EN = '1' else Q_int;
    sel <= RESET;
    
    Mux: Mux2to1
        port map (
            D0  => enabled,
            D1  => '0',
            SEL => sel,
            Y   => mux_out
        );

    flipflop1: DFF
        port map (
            D   => mux_out,
            CLK => CLK,
            Q   => Q_int
        );

    Q <= Q_int;


end architecture;
