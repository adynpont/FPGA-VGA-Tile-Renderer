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
        BTNL  : in  STD_LOGIC;
        BTNR  : in  STD_LOGIC;
        BTNC  : in  STD_LOGIC;
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
signal video_active_d2 : STD_LOGIC;
signal Hcnt : STD_LOGIC_VECTOR(9 downto 0);
signal Vcnt : STD_LOGIC_VECTOR(9 downto 0);
signal TC : STD_LOGIC;
signal frame_tick : STD_LOGIC;
signal bg_color : STD_LOGIC_VECTOR(11 downto 0);
signal sprite_color : STD_LOGIC_VECTOR(11 downto 0);
signal sprite_active : STD_LOGIC;
signal sprite_x : STD_LOGIC_VECTOR(9 downto 0);
signal sprite_y : STD_LOGIC_VECTOR(9 downto 0);

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
        Vcnt : out STD_LOGIC_VECTOR(9 downto 0);
        TC : out STD_LOGIC
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

 component tile_fetch
    port (
        clk : in STD_LOGIC;
        Hcnt : in STD_LOGIC_VECTOR(9 downto 0);
        Vcnt : in STD_LOGIC_VECTOR(9 downto 0);
        video_active : in STD_LOGIC;
        color : out STD_LOGIC_VECTOR(11 downto 0);
        video_active_d2 : out STD_LOGIC
    );
 end component;

 component sprite_fetch
    port (
        clk : in STD_LOGIC;
        Hcnt : in STD_LOGIC_VECTOR(9 downto 0);
        Vcnt : in STD_LOGIC_VECTOR(9 downto 0);
        sprite_x : in STD_LOGIC_VECTOR(9 downto 0);
        sprite_y : in STD_LOGIC_VECTOR(9 downto 0);
        sprite_color : out STD_LOGIC_VECTOR(11 downto 0);
        sprite_active : out STD_LOGIC
    );
 end component;

 component player_control
    port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        frame_tick : in STD_LOGIC;
        btn_left : in STD_LOGIC;
        btn_right : in STD_LOGIC;
        btn_jump : in STD_LOGIC;
        sprite_x : out STD_LOGIC_VECTOR(9 downto 0);
        sprite_y : out STD_LOGIC_VECTOR(9 downto 0)
    );
 end component;

 component imagegen
    port (
        video_active : in STD_LOGIC;
        bg_color : in STD_LOGIC_VECTOR(11 downto 0);
        sprite_color : in STD_LOGIC_VECTOR(11 downto 0);
        sprite_active : in STD_LOGIC;
        vgaRed : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue : out STD_LOGIC_VECTOR(3 downto 0)
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
        En => TC,
        TC => frame_tick
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

 tile_fetch_inst : tile_fetch
    port map (
        clk => CLK_25,
        Hcnt => Hcnt,
        Vcnt => Vcnt,
        video_active => video_active,
        color => bg_color,
        video_active_d2 => video_active_d2
   );

 sprite_fetch_inst : sprite_fetch
    port map (
        clk => CLK_25,
        Hcnt => Hcnt,
        Vcnt => Vcnt,
        sprite_x => sprite_x,
        sprite_y => sprite_y,
        sprite_color => sprite_color,
        sprite_active => sprite_active
   );

 player_control_inst : player_control
    port map (
        clk => CLK_25,
        reset => RESET,
        frame_tick => frame_tick,
        btn_left => BTNL,
        btn_right => BTNR,
        btn_jump => BTNC,
        sprite_x => sprite_x,
        sprite_y => sprite_y
   );

  imagegen_inst : imagegen
    port map (
          video_active => video_active_d2,
          bg_color => bg_color,
          sprite_color => sprite_color,
          sprite_active => sprite_active,
          vgaRed => vgaRed,
          vgaBlue => vgaBlue,
          vgaGreen => vgaGreen

  );


end Structural;
