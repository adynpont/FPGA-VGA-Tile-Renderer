`timescale 1ns / 1ps

// Checks sprite_fetch bounding-box detection and chroma-key transparency.
module tb_sprite_fetch;

    logic clk = 0;
    logic [9:0] Hcnt, Vcnt, sprite_x, sprite_y;
    logic [11:0] sprite_color;
    logic sprite_active;

    integer errors = 0;

    sprite_fetch dut (
        .clk(clk),
        .Hcnt(Hcnt),
        .Vcnt(Vcnt),
        .sprite_x(sprite_x),
        .sprite_y(sprite_y),
        .sprite_color(sprite_color),
        .sprite_active(sprite_active)
    );

    always #5 clk = ~clk;

    task automatic check(input integer h, input integer v, input integer sx, input integer sy,
                          input logic exp_active, input string label);
        Hcnt = h[9:0]; Vcnt = v[9:0]; sprite_x = sx[9:0]; sprite_y = sy[9:0];
        repeat (3) @(posedge clk);
        #1;
        if (sprite_active !== exp_active) begin
            $display("FAIL: %s expected sprite_active=%b got=%b (color=%h)", label, exp_active, sprite_active, sprite_color);
            errors = errors + 1;
        end else begin
            $display("PASS: %s sprite_active=%b color=%h", label, sprite_active, sprite_color);
        end
    endtask

    initial begin
        Hcnt = 0; Vcnt = 0; sprite_x = 0; sprite_y = 0;
        @(posedge clk);

        // sprite placed at (100,200); (105,203) is inside the head region (opaque skin)
        check(105, 203, 100, 200, 1'b1, "inside sprite, opaque pixel");

        // (100,210) local (0,10) is outside pants columns 4-7/9-12 -> transparent -> not active
        check(100, 210, 100, 200, 1'b0, "inside bbox, transparent pixel");

        // outside bounding box entirely
        check(50, 50, 100, 200, 1'b0, "outside bounding box");

        // edge just outside right/bottom of bbox (sprite_x+16, sprite_y+16 excluded)
        check(116, 200, 100, 200, 1'b0, "just past right edge");

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);

        $finish;
    end

endmodule
