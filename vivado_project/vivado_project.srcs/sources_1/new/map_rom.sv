`timescale 1ns / 1ps


module map_rom(
    input logic clk,
    input logic [10:0] addr,
    output logic [2:0] tile_id
    );
    
    logic [2:0] mem [0:1199];
    initial $readmemh("tilemap.mem", mem);
    
    always_ff @(posedge clk) 
        tile_id <= mem[addr];
        
        
endmodule
