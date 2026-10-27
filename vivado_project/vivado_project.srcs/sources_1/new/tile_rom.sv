`timescale 1ns / 1ps


module tile_rom(
    input  logic        clk,
    input  logic [10:0] addr,
    output logic [11:0] color
    );

    logic [11:0] mem [0:2047];
    initial $readmemh("tile_data.mem", mem);

    always_ff @(posedge clk)
        color <= mem[addr];

endmodule
