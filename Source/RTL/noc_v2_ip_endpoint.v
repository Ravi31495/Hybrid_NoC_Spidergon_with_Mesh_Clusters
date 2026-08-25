`timescale 1ns/1ps
`include "noc_defines.vh"

// IP endpoint wrapper for V2 performance experiments.
// This wrapper does not modify the frozen NoC.
module noc_v2_ip_endpoint #(
    parameter [1:0] MY_CLUSTER = 2'd0,
    parameter [1:0] MY_ROW     = 2'd0,
    parameter [1:0] MY_COL     = 2'd0
)
(
    input clk,
    input rst,
    input [1:0] tx_dst_cluster,
    input [1:0] tx_dst_row,
    input [1:0] tx_dst_col,
    input [1:0] tx_packet_type,
    input [1:0] tx_priority,
    input [31:0] tx_payload,
    input tx_send,
    output [`PACKET_WIDTH-1:0] tx_packet,
    output tx_packet_valid,
    input [`PACKET_WIDTH-1:0] rx_packet,
    input rx_valid,
    output packet_received,
    output [1:0] rx_src_cluster,
    output [1:0] rx_src_row,
    output [1:0] rx_src_col,
    output [1:0] rx_packet_type,
    output [1:0] rx_priority,
    output [31:0] rx_payload
);

    packet_generator TX
    (
        .dst_cluster(tx_dst_cluster),
        .dst_row(tx_dst_row),
        .dst_col(tx_dst_col),
        .src_cluster(MY_CLUSTER),
        .src_row(MY_ROW),
        .src_col(MY_COL),
        .packet_type(tx_packet_type),
        .priority(tx_priority),
        .payload(tx_payload),
        .packet(tx_packet),
        .packet_valid(tx_packet_valid)
    );

    packet_receiver RX
    (
        .clk(clk),
        .rst(rst),
        .packet_in(rx_packet),
        .packet_valid_in(rx_valid),
        .my_cluster(MY_CLUSTER),
        .my_row(MY_ROW),
        .my_col(MY_COL),
        .packet_received(packet_received),
        .src_cluster(rx_src_cluster),
        .src_row(rx_src_row),
        .src_col(rx_src_col),
        .packet_type(rx_packet_type),
        .priority(rx_priority),
        .payload(rx_payload)
    );

endmodule
