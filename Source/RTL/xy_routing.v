
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : xy_routing
// Description : Determines the next output direction using
//               deterministic XY routing.
//////////////////////////////////////////////////////////////////////////////////

module xy_routing
(
    input [1:0] current_row,
    input [1:0] current_col,

    input [1:0] dest_row,
    input [1:0] dest_col,

    output reg [2:0] direction
);

localparam LOCAL = 3'b000;
localparam NORTH = 3'b001;
localparam SOUTH = 3'b010;
localparam EAST  = 3'b011;
localparam WEST  = 3'b100;

always @(*)
begin

    if(current_col < dest_col)
        direction = EAST;

    else if(current_col > dest_col)
        direction = WEST;

    else if(current_row < dest_row)
        direction = SOUTH;

    else if(current_row > dest_row)
        direction = NORTH;

    else
        direction = LOCAL;

end

endmodule
