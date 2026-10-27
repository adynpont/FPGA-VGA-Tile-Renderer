`timescale 1ns / 1ps

// Standalone testbench for map_rom: checks the 1200-entry, 1-cycle-latency
// tilemap ROM against the level layout in tilemap.mem
// (rows 0-25 = tile 2 sky, row 26 = tile 0 grass, rows 27-29 = tile 3 dirt).
module tb_map_rom;

    logic clk = 0;
    logic [10:0] addr;
    logic [2:0] tile_id;

    integer errors = 0;

    map_rom dut (
        .clk(clk),
        .addr(addr),
        .tile_id(tile_id)
    );

    always #5 clk = ~clk;

    function automatic [2:0] expected_tile(input integer row, input integer col);
        if (row < 26)
            expected_tile = 3'd2;
        else if (row == 26)
            expected_tile = 3'd0;
        else
            expected_tile = 3'd3;
    endfunction

    integer rows[0:7] = '{0, 0, 25, 26, 26, 27, 29, 29};
    integer cols[0:7] = '{0, 39, 1, 0, 20, 39, 0, 15};
    reg [2:0] expected;
    integer i;

    initial begin
        addr = 0;
        @(posedge clk);
        for (i = 0; i < 8; i = i + 1) begin
            addr = rows[i]*40 + cols[i];
            expected = expected_tile(rows[i], cols[i]);
            @(posedge clk);
            #1;
            if (tile_id !== expected) begin
                $display("FAIL: row=%0d col=%0d addr=%0d expected=%0d got=%0d",
                          rows[i], cols[i], rows[i]*40+cols[i], expected, tile_id);
                errors = errors + 1;
            end else begin
                $display("PASS: row=%0d col=%0d addr=%0d tile_id=%0d",
                          rows[i], cols[i], rows[i]*40+cols[i], tile_id);
            end
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);

        $finish;
    end

endmodule
