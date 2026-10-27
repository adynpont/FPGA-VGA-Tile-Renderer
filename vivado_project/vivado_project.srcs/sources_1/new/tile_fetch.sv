`timescale 1ns / 1ps


module tile_fetch(
    input  logic        clk,
    input  logic [9:0]  Hcnt,
    input  logic [9:0]  Vcnt,
    input  logic        video_active,
    output logic [11:0] color,
    output logic        video_active_d2
    );

    localparam int MAP_COLS = 40;
    localparam int MAP_ROWS = 30;

    
    logic [5:0]  tile_row, tile_col;
    logic [10:0] tilemap_addr;
    logic        in_map_range;

    assign tile_row      = Vcnt[8:4];
    assign tile_col      = Hcnt[9:4];
    assign in_map_range  = (tile_row < MAP_ROWS) && (tile_col < MAP_COLS);
    assign tilemap_addr  = in_map_range ? (11'(tile_row) * MAP_COLS + tile_col) : 11'd0;

    
    logic [3:0] tile_pixel_x_d1, tile_pixel_y_d1;
    logic       video_active_d1;

    always_ff @(posedge clk) begin
        tile_pixel_x_d1 <= Hcnt[3:0];
        tile_pixel_y_d1 <= Vcnt[3:0];
        video_active_d1 <= video_active;
        video_active_d2 <= video_active_d1;
    end

    
    logic [2:0]  tile_id;
    logic [10:0] tile_rom_addr;

    assign tile_rom_addr = {tile_id, tile_pixel_y_d1, tile_pixel_x_d1};

    map_rom map_rom_inst (
        .clk    (clk),
        .addr   (tilemap_addr),
        .tile_id(tile_id)
    );

    
    tile_rom tile_rom_inst (
        .clk  (clk),
        .addr (tile_rom_addr),
        .color(color)
    );

endmodule
