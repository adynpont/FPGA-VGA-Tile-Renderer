`timescale 1ns / 1ps

// Player sprite position/physics. Buttons are debounced (10ms-ish sample
// pulse from PulseGenerator_10ms + Debounce, both reused from src/) and
// horizontal/vertical motion updates once per video frame on frame_tick
// (vcounter's TC, ~60Hz) so walking/falling happen at a visible, steady
// pace instead of every pixel clock.
module player_control(
    input  logic       clk,
    input  logic       reset,
    input  logic       frame_tick,
    input  logic       btn_left,
    input  logic       btn_right,
    input  logic       btn_jump,
    output logic [9:0] sprite_x,
    output logic [9:0] sprite_y
    );

    localparam int SCREEN_W     = 640;
    localparam int SCREEN_H     = 480;
    localparam int SPRITE_SIZE  = 16;
    localparam int TILE_SIZE    = 16;
    localparam int GROUND_ROW   = 26;                                // grass row in tilemap.mem
    localparam int GROUND_Y     = GROUND_ROW*TILE_SIZE - SPRITE_SIZE; // stand on top of the grass
    localparam int START_X      = (SCREEN_W - SPRITE_SIZE) / 2;
    localparam int WALK_STEP    = 2;
    localparam int JUMP_VELOCITY = 8;
    localparam int GRAVITY      = 1;

    logic debounce_pulse;
    logic btn_left_db, btn_right_db, btn_jump_db;

    PulseGenerator_10ms pulse_gen_inst (
        .CLK  (clk),
        .PULSE(debounce_pulse)
    );

    Debounce debounce_left (
        .D    (btn_left),
        .CLK  (clk),
        .PULSE(debounce_pulse),
        .Q    (btn_left_db)
    );

    Debounce debounce_right (
        .D    (btn_right),
        .CLK  (clk),
        .PULSE(debounce_pulse),
        .Q    (btn_right_db)
    );

    Debounce debounce_jump (
        .D    (btn_jump),
        .CLK  (clk),
        .PULSE(debounce_pulse),
        .Q    (btn_jump_db)
    );

    logic on_ground;
    logic signed [6:0] vel_y;
    logic signed [10:0] next_y;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            sprite_x  <= 10'(START_X);
            sprite_y  <= 10'(GROUND_Y);
            vel_y     <= '0;
            on_ground <= 1'b1;
        end else if (frame_tick) begin
            // horizontal walk, clamped to screen bounds
            if (btn_left_db && !btn_right_db) begin
                if (sprite_x > WALK_STEP)
                    sprite_x <= sprite_x - 10'(WALK_STEP);
                else
                    sprite_x <= '0;
            end else if (btn_right_db && !btn_left_db) begin
                if (sprite_x < (SCREEN_W - SPRITE_SIZE - WALK_STEP))
                    sprite_x <= sprite_x + 10'(WALK_STEP);
                else
                    sprite_x <= 10'(SCREEN_W - SPRITE_SIZE);
            end

            // vertical: jump arc under gravity, resting on GROUND_Y otherwise
            if (on_ground) begin
                if (btn_jump_db) begin
                    vel_y     <= -7'(JUMP_VELOCITY);
                    on_ground <= 1'b0;
                end
            end else begin
                next_y = $signed({1'b0, sprite_y}) + vel_y;
                vel_y  <= vel_y + 7'(GRAVITY);
                if (next_y >= GROUND_Y) begin
                    sprite_y  <= 10'(GROUND_Y);
                    vel_y     <= '0;
                    on_ground <= 1'b1;
                end else if (next_y <= 0) begin
                    sprite_y <= '0;
                end else begin
                    sprite_y <= next_y[9:0];
                end
            end
        end
    end

endmodule
