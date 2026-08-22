
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : congestion_checker
// Description : Checks whether the selected output direction is congested.
//////////////////////////////////////////////////////////////////////////////////

module congestion_checker
(
    input  local_busy,
    input  north_busy,
    input  south_busy,
    input  east_busy,
    input  west_busy,

    input  [2:0] direction,

    output reg congested
);

// Direction Encoding
localparam LOCAL = 3'b000;
localparam NORTH = 3'b001;
localparam SOUTH = 3'b010;
localparam EAST  = 3'b011;
localparam WEST  = 3'b100;

always @(*)
begin

    case(direction)

        LOCAL : congested = local_busy;

        NORTH : congested = north_busy;

        SOUTH : congested = south_busy;

        EAST  : congested = east_busy;

        WEST  : congested = west_busy;

        default : congested = 1'b0;

    endcase

end

endmodule

