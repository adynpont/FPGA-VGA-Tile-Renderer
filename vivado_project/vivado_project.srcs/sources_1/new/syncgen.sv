`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2026 05:49:05 PM
// Design Name: 
// Module Name: syncgen
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


module syncgen(

    input logic [9:0] Hcnt,
    input logic [9:0] Vcnt,
    output logic Vsync,
    output logic Hsync,
    output logic video_active
);

localparam int H_VISIBLE = 640;
localparam int H_FRONT   = 16;
localparam int H_SYNC    = 96;

localparam int V_VISIBLE = 480;
localparam int V_FRONT   = 10;
localparam int V_SYNC    = 2;


assign Hsync = ~((Hcnt >= (H_VISIBLE + H_FRONT)) &&
                      (Hcnt <  (H_VISIBLE + H_FRONT + H_SYNC)));
                      
assign Vsync = ~((Vcnt >= (V_VISIBLE + V_FRONT)) &&
                      (Vcnt <  (V_VISIBLE + V_FRONT + V_SYNC)));
                      
assign video_active = (Hcnt < H_VISIBLE) && (Vcnt < V_VISIBLE);
                                            

endmodule
