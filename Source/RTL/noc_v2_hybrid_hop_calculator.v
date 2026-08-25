`timescale 1ns/1ps
`include "noc_defines.vh"

// -----------------------------------------------------------------------------
// Hybrid NoC V2 total-hop calculator
//
// Local traffic:
//     Manhattan distance between source and destination.
//
// Inter-cluster traffic:
//     source -> Cx/R0 gateway
//     + one global-cluster transfer
//     + destination gateway -> destination
//
// The V2 gateway is R0=(0,0) in every cluster.
// -----------------------------------------------------------------------------
module noc_v2_hybrid_hop_calculator
(
    input  [1:0] src_cluster,
    input  [1:0] src_row,
    input  [1:0] src_col,

    input  [1:0] dst_cluster,
    input  [1:0] dst_row,
    input  [1:0] dst_col,

    output reg [3:0] total_hops
);

    wire [2:0] src_to_gateway_hops;
    wire [2:0] gateway_to_dst_hops;
    wire [2:0] local_hops;

    hop_calculator SRC_HOPS
    (
        .current_row(src_row),
        .current_col(src_col),
        .dest_row(2'd0),
        .dest_col(2'd0),
        .total_hops(src_to_gateway_hops)
    );

    hop_calculator DST_HOPS
    (
        .current_row(2'd0),
        .current_col(2'd0),
        .dest_row(dst_row),
        .dest_col(dst_col),
        .total_hops(gateway_to_dst_hops)
    );

    hop_calculator LOCAL_HOPS
    (
        .current_row(src_row),
        .current_col(src_col),
        .dest_row(dst_row),
        .dest_col(dst_col),
        .total_hops(local_hops)
    );

    always @(*) begin
        if (src_cluster == dst_cluster)
            total_hops = {1'b0, local_hops};
        else
            total_hops = {1'b0,src_to_gateway_hops} +
                         {1'b0,gateway_to_dst_hops} +
                         4'd1;
    end

endmodule
