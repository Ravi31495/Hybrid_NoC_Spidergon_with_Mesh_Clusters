`timescale 1ns / 1ps

`include "noc_defines.vh"

//////////////////////////////////////////////////////////////////////////////////
// Module Name : address_translator
// Description : Decodes all packet header fields.
//////////////////////////////////////////////////////////////////////////////////

module address_translator
(
    input [`PACKET_WIDTH-1:0] packet,

    // Destination
    output [`CLUSTER_BITS-1:0] dest_cluster,
    output [`ROW_BITS-1:0]     dest_row,
    output [`COL_BITS-1:0]     dest_col,

    // Source
    output [`CLUSTER_BITS-1:0] src_cluster,
    output [`ROW_BITS-1:0]     src_row,
    output [`COL_BITS-1:0]     src_col,

    // Header
    output [`TYPE_BITS-1:0]     packet_type,
    output [`PRIORITY_BITS-1:0] packet_priority,

    // Payload
    output [`PAYLOAD_BITS-1:0] payload
);

    // Destination

    assign dest_cluster =
        packet[`PACKET_WIDTH-1 :
               `PACKET_WIDTH-`CLUSTER_BITS];

    assign dest_row =
        packet[`PACKET_WIDTH-`CLUSTER_BITS-1 :
               `PACKET_WIDTH-`CLUSTER_BITS-`ROW_BITS];

    assign dest_col =
        packet[`PACKET_WIDTH-`CLUSTER_BITS-`ROW_BITS-1 :
               `PACKET_WIDTH-`CLUSTER_BITS-`ROW_BITS-`COL_BITS];


    // Source

    assign src_cluster =
        packet[`PACKET_WIDTH-`CLUSTER_BITS-`ROW_BITS-`COL_BITS-1 :
               `PACKET_WIDTH-(2*`CLUSTER_BITS)-`ROW_BITS-`COL_BITS];

    assign src_row =
        packet[`PACKET_WIDTH-(2*`CLUSTER_BITS)-`ROW_BITS-`COL_BITS-1 :
               `PACKET_WIDTH-(2*`CLUSTER_BITS)-(2*`ROW_BITS)-`COL_BITS];

    assign src_col =
        packet[`PACKET_WIDTH-(2*`CLUSTER_BITS)-(2*`ROW_BITS)-`COL_BITS-1 :
               `PACKET_WIDTH-(2*`CLUSTER_BITS)-(2*`ROW_BITS)-(2*`COL_BITS)];


    // Packet type

    assign packet_type =
        packet[`PAYLOAD_BITS+`PRIORITY_BITS+`TYPE_BITS-1 :
               `PAYLOAD_BITS+`PRIORITY_BITS];


    // Packet priority
    //
    // IMPORTANT:
    // "priority" is a SystemVerilog keyword.
    // Therefore the signal is named packet_priority.

    assign packet_priority =
        packet[`PAYLOAD_BITS+`PRIORITY_BITS-1 :
               `PAYLOAD_BITS];


    // Payload

    assign payload =
        packet[`PAYLOAD_BITS-1:0];

endmodule