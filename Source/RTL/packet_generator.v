`timescale 1ns / 1ps

module packet_generator
#(
    parameter CLUSTER_BITS  = 2,
    parameter ROW_BITS      = 2,
    parameter COL_BITS      = 2,
    parameter TYPE_BITS     = 2,
    parameter PRIORITY_BITS = 2,
    parameter PAYLOAD_BITS  = 32,

    parameter PACKET_WIDTH =
            (2*CLUSTER_BITS) +
            (2*ROW_BITS) +
            (2*COL_BITS) +
            TYPE_BITS +
            PRIORITY_BITS +
            PAYLOAD_BITS
)
(
    input  [CLUSTER_BITS-1:0] dst_cluster,
    input  [ROW_BITS-1:0]     dst_row,
    input  [COL_BITS-1:0]     dst_col,

    input  [CLUSTER_BITS-1:0] src_cluster,
    input  [ROW_BITS-1:0]     src_row,
    input  [COL_BITS-1:0]     src_col,

    input  [TYPE_BITS-1:0]     packet_type,
    input  [PRIORITY_BITS-1:0] priority,

    input  [PAYLOAD_BITS-1:0] payload,

    output [PACKET_WIDTH-1:0] packet,
    output                    packet_valid
);

assign packet =
{
    dst_cluster,
    dst_row,
    dst_col,

    src_cluster,
    src_row,
    src_col,

    packet_type,
    priority,

    payload
};

assign packet_valid = 1'b1;

endmodule