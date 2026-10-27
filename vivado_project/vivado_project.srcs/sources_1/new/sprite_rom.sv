`timescale 1ns / 1ps

// Player sprite pixel-color ROM: 16x16 pixels, 12-bit RGB (4 bits/channel,
// {R,G,B} packed high-to-low). addr = {pixel_y[3:0], pixel_x[3:0]}.
// Color 12'hF0F (bright magenta) is the reserved transparent/chroma-key value.
// Registered output (1-cycle read latency), loaded from sprite_data.mem.
module sprite_rom(
    input  logic       clk,
    input  logic [7:0] addr,
    output logic [11:0] color
    );

    logic [11:0] mem [0:255];
    initial $readmemh("sprite_data.mem", mem);

    always_ff @(posedge clk)
        color <= mem[addr];

endmodule
