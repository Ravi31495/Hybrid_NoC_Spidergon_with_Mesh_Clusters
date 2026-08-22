`timescale 1ns/1ps
`include "noc_defines.vh"

module router_controller
(
    input clk,
    input rst,

    // =========================================================
    // REQUESTS FROM SIX INPUT PORTS
    //
    // 0 = LOCAL
    // 1 = NORTH
    // 2 = SOUTH
    // 3 = EAST
    // 4 = WEST
    // 5 = GATEWAY
    // =========================================================

    input [5:0] request,

    input [2:0] dir0,
    input [2:0] dir1,
    input [2:0] dir2,
    input [2:0] dir3,
    input [2:0] dir4,
    input [2:0] dir5,

    // =========================================================
    // GRANTS TO SIX OUTPUT PORTS
    // =========================================================

    output [5:0] local_grant,
    output [5:0] north_grant,
    output [5:0] south_grant,
    output [5:0] east_grant,
    output [5:0] west_grant,
    output [5:0] gateway_grant
);


    // =========================================================
    // CLASSIFIED REQUESTS
    // =========================================================

    wire [5:0] local_req;
    wire [5:0] north_req;
    wire [5:0] south_req;
    wire [5:0] east_req;
    wire [5:0] west_req;
    wire [5:0] gateway_req;


    // =========================================================
    // REQUEST CLASSIFIER
    // =========================================================

    request_classifier REQUEST_CLASSIFIER
    (
        .request(request),

        .dir0(dir0),
        .dir1(dir1),
        .dir2(dir2),
        .dir3(dir3),
        .dir4(dir4),
        .dir5(dir5),

        .local_req(local_req),
        .north_req(north_req),
        .south_req(south_req),
        .east_req(east_req),
        .west_req(west_req),
        .gateway_req(gateway_req)
    );


    // =========================================================
    // ARBITER BANK
    // =========================================================

    arbiter_bank ARBITER_BANK
    (
        .clk(clk),
        .rst(rst),

        .local_req(local_req),
        .north_req(north_req),
        .south_req(south_req),
        .east_req(east_req),
        .west_req(west_req),
        .gateway_req(gateway_req),

        .local_grant(local_grant),
        .north_grant(north_grant),
        .south_grant(south_grant),
        .east_grant(east_grant),
        .west_grant(west_grant),
        .gateway_grant(gateway_grant)
    );

endmodule