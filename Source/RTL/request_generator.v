`timescale 1ns / 1ps
`include "noc_defines.vh"

module request_generator
(
    input fifo_empty,
    input fifo_almost_empty,
    input read_enable,
    output request
);

    // A request means that a packet is present at the FIFO head.
    // Do not suppress the request using read_enable.
    assign request = !fifo_empty;

endmodule
