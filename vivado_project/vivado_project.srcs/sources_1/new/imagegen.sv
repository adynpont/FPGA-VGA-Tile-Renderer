`timescale 1ns / 1ps

// Final compositor: sprite drawn over tile background, black during blanking.
// video_active here is the 2-cycle-delayed signal from tile_fetch, already
// aligned with bg_color/sprite_color's pipeline latency.
module imagegen(

    input logic        video_active,
    input logic [11:0] bg_color,
    input logic [11:0] sprite_color,
    input logic        sprite_active,
    output logic [3:0] vgaRed,
    output logic [3:0] vgaGreen,
    output logic [3:0] vgaBlue
   );

    logic [11:0] pixel_color;

    always_comb begin
        if (!video_active)
            pixel_color = 12'h000;
        else if (sprite_active)
            pixel_color = sprite_color;
        else
            pixel_color = bg_color;
    end

    assign vgaRed   = pixel_color[11:8];
    assign vgaGreen = pixel_color[7:4];
    assign vgaBlue  = pixel_color[3:0];

endmodule
