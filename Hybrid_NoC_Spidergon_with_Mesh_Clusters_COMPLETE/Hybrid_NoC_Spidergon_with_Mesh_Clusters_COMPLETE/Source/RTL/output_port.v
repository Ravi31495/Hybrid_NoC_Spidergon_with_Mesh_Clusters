`timescale 1ns / 1ps
`include "noc_defines.vh"

//////////////////////////////////////////////////////////////////////////////////
// Module Name : output_port
//
// Description :
//      Output port containing an output FIFO.
//
//      Data path:
//
//          Crossbar
//             |
//             v
//        output_port
//             |
//             v
//        output_buffer
//             |
//             v
//        Next Router / PE
//
//      packet_valid = 1 when the FIFO contains valid data.
//
//      A FIFO read occurs only when:
//          read_en = 1
//          FIFO is not empty
//////////////////////////////////////////////////////////////////////////////////

module output_port
(
    input clk,
    input rst,

    //--------------------------------------------------
    // Control
    //--------------------------------------------------

    input write_en,
    input read_en,

    //--------------------------------------------------
    // Data from Crossbar
    //--------------------------------------------------

    input [`PACKET_WIDTH-1:0] packet_in,

    //--------------------------------------------------
    // Data to Next Router / PE
    //--------------------------------------------------

    output [`PACKET_WIDTH-1:0] packet_out,
    output packet_valid,

    //--------------------------------------------------
    // FIFO Status
    //--------------------------------------------------

    output full,
    output empty
);

////////////////////////////////////////////////////////////
// Internal Signals
////////////////////////////////////////////////////////////

wire fifo_read_en;


////////////////////////////////////////////////////////////
// Output Buffer
////////////////////////////////////////////////////////////

output_buffer OUTPUT_BUFFER
(
    .clk      (clk),
    .rst      (rst),

    .write_en (write_en),
    .read_en  (fifo_read_en),

    .packet_in  (packet_in),
    .packet_out (packet_out),

    .full  (full),
    .empty (empty)
);


////////////////////////////////////////////////////////////
// Packet Valid
//
// FIFO contains a packet whenever it is not empty.
////////////////////////////////////////////////////////////

assign packet_valid = !empty;


////////////////////////////////////////////////////////////
// FIFO Read Enable
//
// A read is allowed only when:
//
//     1. Downstream requests a read
//     2. FIFO contains valid data
////////////////////////////////////////////////////////////

assign fifo_read_en = read_en && !empty;


endmodule