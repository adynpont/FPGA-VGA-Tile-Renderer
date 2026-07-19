`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2026 08:16:23 PM
// Design Name: 
// Module Name: imagegen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module imagegen(
    input logic video_active,
    output logic [3:0] vgaRed, 
    output logic [3:0] vgaGreen, 
    output logic [3:0] vgaBlue

    );

  always_comb begin
    if (video_active) begin 
        vgaRed = 4'hf;
        vgaGreen = 4'h0;
        vgaBlue = 4'h0;
    end else begin 
        vgaRed = 4'h0;
        vgaBlue = 4'h0;
        vgaGreen = 4'h0;
    end
  
 end
  

endmodule