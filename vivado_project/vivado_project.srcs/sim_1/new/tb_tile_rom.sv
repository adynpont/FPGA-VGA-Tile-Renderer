`timescale 1ns / 1ps

// Spot-checks tile_rom addressing against known pixels from the procedural
// placeholder art (see gen_art.py that produced tile_data.mem).
module tb_tile_rom;

    logic clk = 0;
    logic [10:0] addr;
    logic [11:0] color;

    integer errors = 0;

    tile_rom dut (
        .clk(clk),
        .addr(addr),
        .color(color)
    );

    always #5 clk = ~clk;

    integer addrs[0:6] = '{0, 1, 256, 273, 512, 528, 1109};
    logic [11:0] expected_colors[0:6] = '{12'h171, 12'h2a2, 12'h444, 12'h888, 12'h49f, 12'h13c, 12'hf00};
    integer i;

    initial begin
        addr = 0;
        @(posedge clk);
        for (i = 0; i < 7; i = i + 1) begin
            addr = addrs[i];
            @(posedge clk);
            #1;
            if (color !== expected_colors[i]) begin
                $display("FAIL: addr=%0d expected=%h got=%h", addrs[i], expected_colors[i], color);
                errors = errors + 1;
            end else begin
                $display("PASS: addr=%0d color=%h", addrs[i], color);
            end
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);

        $finish;
    end

endmodule
