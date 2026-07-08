`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2026 07:32:18 PM
// Design Name: 
// Module Name: tb_VGA_Timing
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


module tb_VGA_Timing;

    localparam int H_VISIBLE = 640;
    localparam int H_FRONT = 16;
    localparam int H_SYNC = 96;
    localparam int H_BACK = 48;
    localparam int H_TOTAL = H_VISIBLE + H_FRONT + H_SYNC + H_BACK;
    localparam int V_VISIBLE = 480;
    localparam int V_FRONT = 10;
    localparam int V_SYNC = 2;
    localparam int V_BACK = 33;
    localparam int V_TOTAL = V_VISIBLE + V_FRONT + V_SYNC + V_BACK;
    
    
    logic clk, reset;
    logic hsync, vsync, video_active;
    logic [9:0] pixel_x, pixel_y;
    
    int exp_h_count, exp_v_count, error_count, cycle_count;
    
    VGA_Timing dut (
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .video_active(video_active),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
        
    );
    
    always #5 clk = ~clk;
    
 initial begin 
    clk = 0;
    reset = 1;
    exp_h_count = 0;
    exp_v_count = 0;
    error_count = 0;
    cycle_count = 0;
    
    repeat (5) @(posedge clk);
    reset = 0; 
    
    repeat (2 * H_TOTAL * V_TOTAL + 100) @(posedge clk) begin
        check_outputs();
        update_expected();
        cycle_count++;
    end 
    
    if (error_count == 0) 
        $display("Test Passed: %0d cycles checked, 0 errors", cycle_count);
    else
        $display("Test Failed: %0d errors out of %0d cycles", error_count,cycle_count);
    $finish;
 end 
 
 task check_outputs();
    logic exp_hsync, exp_vsync, exp_video_active;
    logic [9:0] exp_pixel_x, exp_pixel_y;
    
    exp_hsync = ~((exp_h_count >= (H_VISIBLE + H_FRONT)) && (exp_h_count < (H_VISIBLE + H_FRONT + H_SYNC)));
    exp_vsync = ~((exp_v_count >= (V_VISIBLE + V_FRONT)) && (exp_v_count < (V_VISIBLE + V_FRONT + V_SYNC)));
    exp_video_active = (exp_h_count < H_VISIBLE) && (exp_v_count < V_VISIBLE);
    exp_pixel_x = exp_h_count;
    exp_pixel_y = exp_v_count;
    
    if (!reset) begin 
        if (hsync != exp_hsync) begin
            $error("hsync mismatched at cycle %0d, got %b, expected %b", cycle_count, hsync, exp_hsync);
            error_count++;
        end
        if (vsync != exp_vsync) begin
            $error("vsync mismatched at cycle %0d, got %b, expected %b", cycle_count, vsync, exp_vsync);
            error_count++;
        end 
        if (video_active != exp_video_active) begin 
            $error("video_active mismatch at cycle %0d, got %b, expected %b", cycle_count, video_active, exp_video_active);
            error_count++;
        end
        if (pixel_x != exp_pixel_x) begin
            $error("pixel_x mismatch at cycle %0d, got %b, expected %b", cycle_count, pixel_x, exp_pixel_x);
            error_count++;
        end
        if (pixel_y != exp_pixel_y) begin
            $error("pixel_y mismatch at cycle %0d, got %b, expected %b", cycle_count, pixel_y, exp_pixel_y);
            error_count++;
        end
     end 
  endtask 
  
task update_expected(); 
    if (exp_h_count == H_TOTAL - 1) begin 
        exp_h_count = 0;
        if (exp_v_count == V_TOTAL - 1)
            exp_v_count = 0;
        else 
            exp_v_count = exp_v_count + 1;
   end else begin 
        exp_h_count = exp_h_count + 1;
   end 
endtask
        
        
endmodule
