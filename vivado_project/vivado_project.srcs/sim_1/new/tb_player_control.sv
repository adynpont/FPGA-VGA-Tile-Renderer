`timescale 1ns / 1ps

// Exercises player_control's debounce + walk/jump physics. Debounce needs
// ~2 PulseGenerator_10ms periods (2,000,000 clk cycles) of a stable button
// level before it registers, so this test runs into the millions of cycles;
// still trivial for xsim wall-clock time.
module tb_player_control;

    logic clk = 0;
    logic reset;
    logic frame_tick;
    logic btn_left, btn_right, btn_jump;
    logic [9:0] sprite_x, sprite_y;

    integer errors = 0;

    player_control dut (
        .clk(clk),
        .reset(reset),
        .frame_tick(frame_tick),
        .btn_left(btn_left),
        .btn_right(btn_right),
        .btn_jump(btn_jump),
        .sprite_x(sprite_x),
        .sprite_y(sprite_y)
    );

    always #20 clk = ~clk; // 25MHz-equivalent period, value itself is irrelevant to the logic

    localparam int DEBOUNCE_SETTLE_CYCLES = 2_050_000;
    localparam int START_X = 312;
    localparam int GROUND_Y = 400;
    localparam int WALK_STEP = 2;

    task automatic pulse_frame_tick;
        @(posedge clk);
        frame_tick = 1'b1;
        @(posedge clk);
        frame_tick = 1'b0;
    endtask

    task automatic check_eq(input int actual, input int expected, input string label);
        if (actual !== expected) begin
            $display("FAIL: %s expected=%0d got=%0d", label, expected, actual);
            errors = errors + 1;
        end else begin
            $display("PASS: %s = %0d", label, actual);
        end
    endtask

    integer i;

    initial begin
        reset = 1; frame_tick = 0; btn_left = 0; btn_right = 0; btn_jump = 0;
        repeat (4) @(posedge clk);
        reset = 0;

        check_eq(sprite_x, START_X, "initial sprite_x");
        check_eq(sprite_y, GROUND_Y, "initial sprite_y");

        // --- walk right ---
        btn_right = 1;
        repeat (DEBOUNCE_SETTLE_CYCLES) @(posedge clk);
        for (i = 0; i < 5; i = i + 1)
            pulse_frame_tick();
        check_eq(sprite_x, START_X + 5*WALK_STEP, "sprite_x after 5 right ticks");

        // --- walk left back past start ---
        btn_right = 0;
        btn_left  = 1;
        repeat (DEBOUNCE_SETTLE_CYCLES) @(posedge clk);
        for (i = 0; i < 8; i = i + 1)
            pulse_frame_tick();
        check_eq(sprite_x, START_X + 5*WALK_STEP - 8*WALK_STEP, "sprite_x after 8 left ticks");
        btn_left = 0;

        // --- jump: reset to a clean state first ---
        reset = 1;
        repeat (4) @(posedge clk);
        reset = 0;

        btn_jump = 1;
        repeat (DEBOUNCE_SETTLE_CYCLES) @(posedge clk);
        pulse_frame_tick(); // triggers takeoff (velocity set; position moves starting next tick)
        check_eq(dut.on_ground, 0, "on_ground after takeoff");

        // release the button (a single tap): with JUMP_VELOCITY=8, GRAVITY=1
        // the arc takes exactly 17 more frame_ticks to return to GROUND_Y.
        btn_jump = 0;

        pulse_frame_tick(); // 1st physics tick after takeoff
        if (dut.sprite_y >= GROUND_Y) begin
            $display("FAIL: sprite_y did not rise after takeoff (sprite_y=%0d)", dut.sprite_y);
            errors = errors + 1;
        end else begin
            $display("PASS: sprite_y rose after takeoff (sprite_y=%0d)", dut.sprite_y);
        end

        for (i = 0; i < 16; i = i + 1) // remaining ticks of the 17-tick arc
            pulse_frame_tick();
        check_eq(dut.on_ground, 1, "on_ground after landing");
        check_eq(sprite_y, GROUND_Y, "sprite_y after landing");

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);

        $finish;
    end

endmodule
