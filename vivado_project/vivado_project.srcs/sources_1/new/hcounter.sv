`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2026 05:18:19 PM
// Design Name: 
// Module Name: hcounter
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


module hcounter(

    input logic clk_25,
    input logic reset, 
    output logic [9:0] Hcnt,
    output logic TC
    );
  
  
  
  localparam int H_VISIBLE = 640;
  localparam int H_FRONT   = 16;
  localparam int H_SYNC    = 96;
  localparam int H_BACK    = 48;
  localparam int H_TOTAL   = H_VISIBLE + H_FRONT + H_SYNC + H_BACK;
    
    
  always_ff @(posedge clk_25 or posedge reset) begin 
    if (reset) begin 
       Hcnt <= 10'd0;
    end else begin 
        if (Hcnt== H_TOTAL - 1)
            Hcnt <= 10'd0;
        else 
            Hcnt <= Hcnt + 1'b1;
    end
   end 
   
assign TC = (Hcnt == H_TOTAL - 1);


endmodule
