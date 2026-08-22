
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : adaptive_routing
// Description : Selects an alternate direction when the preferred
//               direction is congested.
//////////////////////////////////////////////////////////////////////////////////

module adaptive_routing
(
    input  [2:0] preferred_direction,
    input        congested,

    input north_busy,
    input south_busy,
    input east_busy,
    input west_busy,

    output reg [2:0] final_direction
);

localparam LOCAL = 3'b000;
localparam NORTH = 3'b001;
localparam SOUTH = 3'b010;
localparam EAST  = 3'b011;
localparam WEST  = 3'b100;

always @(*)
begin

    // Preferred direction is available
    if(!congested)
    begin
        final_direction = preferred_direction;
    end

    // Preferred direction is congested
    else
    begin
        if(!north_busy)
            final_direction = NORTH;

        else if(!south_busy)
            final_direction = SOUTH;

        else if(!east_busy)
            final_direction = EAST;

        else if(!west_busy)
            final_direction = WEST;

        else
            final_direction = preferred_direction;
    end

end

endmodule

