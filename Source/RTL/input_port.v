`timescale 1ns / 1ps
`include "noc_defines.vh"

module input_port
(
    input clk,
    input rst,

    input [`PACKET_WIDTH-1:0] packet_in,
    input packet_valid,

    input read_enable,

    input [`CLUSTER_BITS-1:0] my_cluster,
    input [`ROW_BITS-1:0]     my_row,
    input [`COL_BITS-1:0]     my_col,

    input local_busy,
    input north_busy,
    input south_busy,
    input east_busy,
    input west_busy,

    output [`PACKET_WIDTH-1:0] packet_out,
    output [2:0] direction,

    output request,
    output packet_valid_out,

    output empty,
    output full
);

    // =========================================================
    // FIFO
    // =========================================================

    wire [`PACKET_WIDTH-1:0] fifo_packet;
    wire fifo_almost_empty;

    input_buffer INPUT_BUFFER
    (
        .clk          (clk),
        .rst          (rst),

        .packet_in    (packet_in),
        .write_en     (packet_valid),

        .read_en      (read_enable),

        .packet_out   (fifo_packet),

        .full         (full),
        .empty        (empty),
        .almost_empty (fifo_almost_empty)
    );


    // =========================================================
    // Packet output
    // =========================================================

    assign packet_out = fifo_packet;

    assign packet_valid_out = ~empty;


    // =========================================================
    // DIRECT PACKET HEADER DECODING
    //
    // PACKET FORMAT:
    //
    // [47:46] destination cluster
    // [45:44] destination row
    // [43:42] destination column
    //
    // [41:40] source cluster
    // [39:38] source row
    // [37:36] source column
    //
    // [35:34] type
    // [33:32] priority
    //
    // [31:0] payload
    // =========================================================

    wire [1:0] dest_cluster;
    wire [1:0] dest_row;
    wire [1:0] dest_col;

    assign dest_cluster = fifo_packet[47:46];
    assign dest_row     = fifo_packet[45:44];
    assign dest_col     = fifo_packet[43:42];


    // =========================================================
    // ROUTING UNIT
    // =========================================================

    routing_unit ROUTING_UNIT
    (
        .current_cluster (my_cluster),
        .current_row     (my_row),
        .current_col     (my_col),

        .dest_cluster    (dest_cluster),
        .dest_row        (dest_row),
        .dest_col        (dest_col),

        .local_busy      (local_busy),
        .north_busy      (north_busy),
        .south_busy      (south_busy),
        .east_busy       (east_busy),
        .west_busy       (west_busy),

        .final_direction (direction)
    );


    // =========================================================
    // REQUEST GENERATOR
    // =========================================================

    request_generator REQUEST_GENERATOR
    (
        .fifo_empty        (empty),
        .fifo_almost_empty (fifo_almost_empty),
        .read_enable       (read_enable),
        .request           (request)
    );

endmodule