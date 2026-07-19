`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2026 08:56:52 PM
// Design Name: 
// Module Name: VGA_Timing
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


module VGA_Timing(
      input logic clk,
      input logic reset,
      output logic hsync,
      output logic vsync,
      output logic video_active,
      output logic [9:0] pixel_x,
      output logic [9:0] pixel_y

    );
    
    // Horizontal timing (640x480 @ 60 Hz)   
    localparam int H_VISIBLE = 640;
    localparam int H_FRONT = 16;
    localparam int H_SYNC = 96;
    localparam int H_BACK = 48;
    localparam int H_TOTAL = H_VISIBLE + H_FRONT + H_SYNC + H_BACK;
    
    
     // Vertical timing 
    localparam int V_VISIBLE = 480;
    localparam int V_FRONT = 10;
    localparam int V_SYNC = 2;
    localparam int V_BACK = 33;
    localparam int V_TOTAL = V_VISIBLE + V_FRONT + V_SYNC + V_BACK;
    
    logic [9:0] h_count, v_count;
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin 
            h_count <= 0;
            v_count <= 0;
        end else begin 
            if (h_count == H_TOTAL - 1) begin 
             h_count <= 0; 
             if (v_count == V_TOTAL -1) 
                v_count <= 0;
            else 
                v_count <= v_count + 1;
            end else begin 
           h_count <= h_count + 1;
           end 
          end
        end 
   
    assign hsync = ~((h_count >= (H_VISIBLE + H_FRONT)) && (h_count < (H_VISIBLE + H_FRONT + H_SYNC)));
    assign vsync = ~((v_count >= (V_VISIBLE + V_FRONT)) && (v_count < (V_VISIBLE + V_FRONT + V_SYNC)));
    assign video_active = (h_count < H_VISIBLE) && (v_count < V_VISIBLE);
   
endmodule
