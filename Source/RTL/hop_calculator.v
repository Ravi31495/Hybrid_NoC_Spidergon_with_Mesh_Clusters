
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : hop_calculator
// Description : Calculates Manhattan distance (XY hops)
//               between current router and destination router.
//////////////////////////////////////////////////////////////////////////////////

module hop_calculator
(
    input  [1:0] current_row,
    input  [1:0] current_col,

    input  [1:0] dest_row,
    input  [1:0] dest_col,

    output [2:0] total_hops
);

wire [1:0] row_hops;
wire [1:0] col_hops;

assign row_hops =
    (dest_row >= current_row) ?
    (dest_row - current_row) :
    (current_row - dest_row);

assign col_hops =
    (dest_col >= current_col) ?
    (dest_col - current_col) :
    (current_col - dest_col);

assign total_hops = row_hops + col_hops;

endmodule

