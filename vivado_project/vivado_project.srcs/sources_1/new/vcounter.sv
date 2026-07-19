`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2026 05:36:18 PM
// Design Name: 
// Module Name: vcounter
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


module vcounter(
    
    input logic clk_25,
    input logic En,
    input logic reset,
    output logic [9:0] Vcnt

    );
  
  


 localparam int V_VISIBLE = 480;
 localparam int V_FRONT   = 10;
 localparam int V_SYNC    = 2;
 localparam int V_BACK    = 33;
 localparam int V_TOTAL   = V_VISIBLE + V_FRONT + V_SYNC + V_BACK;
 
    always_ff @(posedge clk_25 or posedge reset) begin
        if (reset) begin
            Vcnt <= 10'd0;
        end else if (En) begin
            if (Vcnt == V_TOTAL - 1)
                Vcnt <= 10'd0;
            else
                Vcnt <= Vcnt + 1'b1;
        end
    end


  
endmodule
