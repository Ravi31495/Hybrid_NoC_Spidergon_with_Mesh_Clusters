`timescale 1ns / 1ps
`include "noc_defines.vh"

module request_classifier
(
    // 0=LOCAL, 1=NORTH, 2=SOUTH, 3=EAST, 4=WEST, 5=GATEWAY
    input [5:0] request,

    input [2:0] dir0,
    input [2:0] dir1,
    input [2:0] dir2,
    input [2:0] dir3,
    input [2:0] dir4,
    input [2:0] dir5,

    output reg [5:0] local_req,
    output reg [5:0] north_req,
    output reg [5:0] south_req,
    output reg [5:0] east_req,
    output reg [5:0] west_req,
    output reg [5:0] gateway_req
);

always @(*)
begin

    // ---------------------------------------------------------
    // Default
    // ---------------------------------------------------------

    local_req   = 6'b000000;
    north_req   = 6'b000000;
    south_req   = 6'b000000;
    east_req    = 6'b000000;
    west_req    = 6'b000000;
    gateway_req = 6'b000000;


    // ---------------------------------------------------------
    // Input 0
    // ---------------------------------------------------------

    if (request[0])
    begin
        case (dir0)

            `LOCAL:   local_req[0]   = 1'b1;
            `NORTH:   north_req[0]   = 1'b1;
            `SOUTH:   south_req[0]   = 1'b1;
            `EAST:    east_req[0]    = 1'b1;
            `WEST:    west_req[0]    = 1'b1;
            `GATEWAY: gateway_req[0] = 1'b1;

            default: ;

        endcase
    end


    // ---------------------------------------------------------
    // Input 1
    // ---------------------------------------------------------

    if (request[1])
    begin
        case (dir1)

            `LOCAL:   local_req[1]   = 1'b1;
            `NORTH:   north_req[1]   = 1'b1;
            `SOUTH:   south_req[1]   = 1'b1;
            `EAST:    east_req[1]    = 1'b1;
            `WEST:    west_req[1]    = 1'b1;
            `GATEWAY: gateway_req[1] = 1'b1;

            default: ;

        endcase
    end


    // ---------------------------------------------------------
    // Input 2
    // ---------------------------------------------------------

    if (request[2])
    begin
        case (dir2)

            `LOCAL:   local_req[2]   = 1'b1;
            `NORTH:   north_req[2]   = 1'b1;
            `SOUTH:   south_req[2]   = 1'b1;
            `EAST:    east_req[2]    = 1'b1;
            `WEST:    west_req[2]    = 1'b1;
            `GATEWAY: gateway_req[2] = 1'b1;

            default: ;

        endcase
    end


    // ---------------------------------------------------------
    // Input 3
    // ---------------------------------------------------------

    if (request[3])
    begin
        case (dir3)

            `LOCAL:   local_req[3]   = 1'b1;
            `NORTH:   north_req[3]   = 1'b1;
            `SOUTH:   south_req[3]   = 1'b1;
            `EAST:    east_req[3]    = 1'b1;
            `WEST:    west_req[3]    = 1'b1;
            `GATEWAY: gateway_req[3] = 1'b1;

            default: ;

        endcase
    end


    // ---------------------------------------------------------
    // Input 4
    // ---------------------------------------------------------

    if (request[4])
    begin
        case (dir4)

            `LOCAL:   local_req[4]   = 1'b1;
            `NORTH:   north_req[4]   = 1'b1;
            `SOUTH:   south_req[4]   = 1'b1;
            `EAST:    east_req[4]    = 1'b1;
            `WEST:    west_req[4]    = 1'b1;
            `GATEWAY: gateway_req[4] = 1'b1;

            default: ;

        endcase
    end


    // ---------------------------------------------------------
    // Input 5 = GATEWAY
    // ---------------------------------------------------------

    if (request[5])
    begin
        case (dir5)

            `LOCAL:   local_req[5]   = 1'b1;
            `NORTH:   north_req[5]   = 1'b1;
            `SOUTH:   south_req[5]   = 1'b1;
            `EAST:    east_req[5]    = 1'b1;
            `WEST:    west_req[5]    = 1'b1;
            `GATEWAY: gateway_req[5] = 1'b1;

            default: ;

        endcase
    end

end

endmodule