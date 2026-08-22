
`timescale 1ns / 1ps

module output_buffer
#(
    parameter DATA_WIDTH = 48,
    parameter DEPTH      = 16
)
(
    input                       clk,
    input                       rst,

    input                       write_en,
    input                       read_en,

    input  [DATA_WIDTH-1:0]     packet_in,

    output [DATA_WIDTH-1:0]     packet_out,

    output                      full,
    output                      empty
);

    //----------------------------------------------------
    // FIFO Instance
    //----------------------------------------------------

    fifo
    #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    )
    FIFO_INST
    (
        .clk(clk),
        .rst(rst),

        .wr_en(write_en),
        .rd_en(read_en),

        .data_in(packet_in),
        .data_out(packet_out),

        .full(full),
        .empty(empty)
    );

endmodule

