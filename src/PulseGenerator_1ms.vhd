----------------------------------------------------------------------------
-- Entity:        PulseGenerator_10ms
-- Written By:    Adyn Pontier
-- Date Created:  6 Jul 26
-- Description:   VHDL model of a pulse generator with a pulse every 10 ms
--
-- Revision History (date, initials, description):
--
-- Dependencies:
--   (none)
----------------------------------------------------------------------------
library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;
use     IEEE.NUMERIC_STD.ALL;

----------------------------------------------------------------------------
entity PulseGenerator_10ms is
    port (
        CLK    : in  STD_LOGIC;
        PULSE  : out STD_LOGIC
    );
end entity;
----------------------------------------------------------------------------

architecture Behavioral of PulseGenerator_10ms is

    -- 20 bits: needs to actually reach 999999 (requires >=20 bits), not the
    -- 17 bits this was previously declared with (max 131071, wraps long
    -- before the comparison below can ever be true -> PULSE never fired).
    signal count : UNSIGNED(19 downto 0) := (OTHERS => '0');

begin

    process (CLK)
    begin
        if rising_edge(CLK) then
            if (count >= 999999) then
                count <= (OTHERS => '0');
            else
                count <= count + 1;
            end if;
        end if;
    end process;
    
    PULSE <= '1' when (count >= 999999) else '0';
    
end architecture;
