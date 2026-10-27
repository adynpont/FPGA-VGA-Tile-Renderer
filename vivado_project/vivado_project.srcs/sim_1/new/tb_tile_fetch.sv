`timescale 1ns / 1ps

// End-to-end pipeline-alignment check for tile_fetch (map_rom -> tile_rom):
// drives specific (Hcnt,Vcnt) pixel coordinates and confirms the 2-cycle
// delayed color/video_active line up with the expected tile at that pixel.
module tb_tile_fetch;

    logic clk = 0;
    logic [9:0] Hcnt, Vcnt;
    logic video_active;
    logic [11:0] color;
    logic video_active_d2;

    integer errors = 0;

    tile_fetch dut (
        .clk(clk),
        .Hcnt(Hcnt),
        .Vcnt(Vcnt),
        .video_active(video_active),
        .color(color),
        .video_active_d2(video_active_d2)
    );

    always #5 clk = ~clk;

    // (Hcnt, Vcnt, expected color, expected video_active)
    // row0,col0 sky -> tile2, local pixel (0,0) -> light streak '49f'
    // row26,col1 ground surface -> tile0 (grass), local pixel (3,2) -> '2a2'
    // row29,col20 underground -> tile3 (dirt), local pixel (0,1) -> '974'
    // Hcnt=700 (blanking, >=640) -> video_active low
    integer hs[0:3] = '{0, 19, 320, 700};
    integer vs[0:3] = '{0, 418, 465, 100};
    logic [11:0] expected_colors[0:3] = '{12'h49f, 12'h2a2, 12'h974, 12'h000};
    logic expected_va[0:3] = '{1'b1, 1'b1, 1'b1, 1'b0};
    integer i;

    task automatic apply_and_check(input integer idx);
        Hcnt = hs[idx][9:0];
        Vcnt = vs[idx][9:0];
        video_active = (hs[idx] < 640) && (vs[idx] < 480);
        // hold steady for 3 cycles to flush any prior pipeline contents
        repeat (3) @(posedge clk);
        #1;
        if (video_active_d2 !== expected_va[idx]) begin
            $display("FAIL: idx=%0d (Hcnt=%0d,Vcnt=%0d) expected video_active_d2=%b got=%b",
                      idx, hs[idx], vs[idx], expected_va[idx], video_active_d2);
            errors = errors + 1;
        end else if (expected_va[idx] && (color !== expected_colors[idx])) begin
            $display("FAIL: idx=%0d (Hcnt=%0d,Vcnt=%0d) expected color=%h got=%h",
                      idx, hs[idx], vs[idx], expected_colors[idx], color);
            errors = errors + 1;
        end else begin
            $display("PASS: idx=%0d (Hcnt=%0d,Vcnt=%0d) color=%h video_active_d2=%b",
                      idx, hs[idx], vs[idx], color, video_active_d2);
        end
    endtask

    initial begin
        Hcnt = 0; Vcnt = 0; video_active = 0;
        @(posedge clk);
        for (i = 0; i < 4; i = i + 1)
            apply_and_check(i);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);

        $finish;
    end

endmodule
