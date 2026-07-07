----------------------------------------------------------------------------
-- Entity:        Mux2to1
-- Written By:    Adyn Pontier
-- Date Created:  6 Jul 26
-- Description:   VHDL model of a 2 to 1 multiplexer
--
-- Revision History (date, initials, description):
--
-- Dependencies:
--   (none)
----------------------------------------------------------------------------
library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;

----------------------------------------------------------------------------
entity Mux2to1 is
    port (
        D0  : in  STD_LOGIC;
        D1  : in  STD_LOGIC;
        SEL : in  STD_LOGIC;
        Y   : out STD_LOGIC
    );
end entity;
----------------------------------------------------------------------------


architecture Behavioral of Mux2to1 is
begin
    Y <= D1 when SEL = '1' else D0;
end architecture;
  
  
