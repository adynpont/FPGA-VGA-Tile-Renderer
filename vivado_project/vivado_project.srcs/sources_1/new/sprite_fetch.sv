`timescale 1ns / 1ps

// Draws the 16x16 player sprite at (sprite_x, sprite_y). Delayed 2 cycles
// (one extra register beyond sprite_rom's own 1-cycle latency) to line up
// with tile_fetch's 2-cycle background pipeline.
module sprite_fetch(
    input  logic        clk,
    input  logic [9:0]  Hcnt,
    input  logic [9:0]  Vcnt,
    input  logic [9:0]  sprite_x,
    input  logic [9:0]  sprite_y,
    output logic [11:0] sprite_color,
    output logic        sprite_active
    );

    localparam int SPRITE_SIZE = 16;
    localparam logic [11:0] TRANSPARENT = 12'hF0F;

    // cycle N: bounds check + address
    logic       in_bounds;
    logic [3:0] pixel_x, pixel_y;
    logic [7:0] rom_addr;

    assign in_bounds = (Hcnt >= sprite_x) && (Hcnt < sprite_x + SPRITE_SIZE) &&
                        (Vcnt >= sprite_y) && (Vcnt < sprite_y + SPRITE_SIZE);
    assign pixel_x   = Hcnt - sprite_x;
    assign pixel_y   = Vcnt - sprite_y;
    assign rom_addr  = {pixel_y, pixel_x};

    // delay stages to reach 2-cycle total latency
    logic       in_bounds_d1, in_bounds_d2;
    logic [11:0] rom_color, rom_color_d1;

    always_ff @(posedge clk) begin
        in_bounds_d1 <= in_bounds;
        in_bounds_d2 <= in_bounds_d1;
        rom_color_d1 <= rom_color;
    end

    sprite_rom sprite_rom_inst (
        .clk  (clk),
        .addr (rom_addr),
        .color(rom_color)
    );

    assign sprite_color = rom_color_d1;
    assign sprite_active = in_bounds_d2 && (rom_color_d1 != TRANSPARENT);

endmodule
