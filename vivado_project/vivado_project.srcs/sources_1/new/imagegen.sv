`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2026 05:57:15 PM
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
    output logic [3:0]  vgaRed,
    output logic [3:0] vgaBlue,
    output logic [3:0] vgaGreen
   );
   
   
   
 always_comb begin
    if (video_active) begin
       vgaRed = 4'hF;
       vgaBlue = 4'h0;
       vgaGreen = 4'h0;
    end else begin
        vgaRed = 4'h0;
        vgaBlue = 4'h0;
        vgaGreen = 4'h0;
    end
 end
 
 
endmodule
