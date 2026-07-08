----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/06/2026 07:59:19 PM
-- Design Name: 
-- Module Name: Tile_Generator_TopLevel - Structural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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


entity Tile_Generator_TopLevel is
port (
        CLK   : in  STD_LOGIC;
        RESET : in  STD_LOGIC;
        vgaRed : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue : out STD_LOGIC_VECTOR (3 downto 0);
        Hsync : out STD_LOGIC;
        Vsync : out STD_LOGIC
        
        
    );
end Tile_Generator_TopLevel;

architecture Structural of Tile_Generator_TopLevel is

signal CLK_25: STD_LOGIC;
signal clk_locked : STD_LOGIC;
signal blink_count : UNSIGNED(23 downto 0) := (others => '0');
signal blink_reg    : STD_LOGIC := '0';

component clk_wiz_0
    port (
        clk_in1 : in STD_LOGIC;
        clk_out1 : out STD_LOGIC;
        reset : in STD_LOGIC;
        locked : out STD_LOGIC
 );
 end component;
    



begin

clk_25mhz : clk_wiz_0
    port map (
       clk_in1 => CLK,
       clk_out1 => CLK_25,
       reset => RESET,
       locked => clk_locked 
   );
   
   


end Structural;