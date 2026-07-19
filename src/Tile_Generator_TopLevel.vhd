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
signal video_active : STD_LOGIC;
signal Hcnt : STD_LOGIC_VECTOR(9 downto 0);
signal Vcnt : STD_LOGIC_VECTOR(9 downto 0);
signal TC : STD_LOGIC;

component clk_wiz_0
    port (
        clk_in1 : in STD_LOGIC;
        clk_out1 : out STD_LOGIC;
        reset : in STD_LOGIC;
        locked : out STD_LOGIC
 );
 end component; 
 
 component hcounter 
    port (
        CLK_25 : in STD_LOGIC;
        reset : in STD_LOGIC;
        Hcnt : out STD_LOGIC_VECTOR(9 downto 0);
        TC : out STD_LOGIC
  );
  end component; 
  
 component vcounter 
    port ( 
        CLK_25 : in STD_LOGIC;
        reset : in STD_LOGIC;
        En : in STD_LOGIC;
        Vcnt : out STD_LOGIC_VECTOR(9 downto 0)
   );
  end component;
   
 component syncgen 
    port  ( 
        Hcnt : in STD_LOGIC_VECTOR(9 downto 0);
        Vcnt : in STD_LOGIC_VECTOR(9 downto 0);
        Vsync : out STD_LOGIC;
        Hsync : out STD_LOGIC;
        video_active : out std_logic
   ); 
 end component;
 
 
 component imagegen
    port (
        video_active : in STD_LOGIC;
        vgaRed : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen : out STD_LOGIC_VECTOR(3 downto 0)
        
    );
   end component;

begin
   

 hcounter_inst : hcounter 
    port map (
        clk_25 => CLK_25,
        reset => RESET,
        Hcnt => Hcnt, 
        TC => TC
  );
  
 
 vcounter_inst : vcounter 
    port map (
        clk_25 => CLK_25,
        reset => RESET,
        Vcnt => Vcnt,
        En => TC
   );
   
   
 syncgen_inst : syncgen 
    port map (
        Hsync => Hsync,
        Vsync => Vsync,
        Hcnt => Hcnt,
        Vcnt => Vcnt,
        video_active => video_active
        
 );
        
   
 clk_25_inst : clk_wiz_0 
    port map (
        clk_in1 => CLK,
        reset => RESET,
        clk_out1 => CLK_25,
        locked => clk_locked
   );
        
  imagegen_inst : imagegen
    port map (
          video_active => video_active,
          vgaRed => vgaRed,
          vgaBlue => vgaBlue,
          vgaGreen => vgaGreen
          
  );
  
  
end Structural;