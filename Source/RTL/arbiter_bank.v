`timescale 1ns/1ps
`include "noc_defines.vh"

module arbiter_bank
(
    input clk,
    input rst,

    // =========================================================
    // SIX INPUT REQUEST VECTORS
    // =========================================================

    input [5:0] local_req,
    input [5:0] north_req,
    input [5:0] south_req,
    input [5:0] east_req,
    input [5:0] west_req,
    input [5:0] gateway_req,

    // =========================================================
    // SIX OUTPUT GRANT VECTORS
    // =========================================================

    output [5:0] local_grant,
    output [5:0] north_grant,
    output [5:0] south_grant,
    output [5:0] east_grant,
    output [5:0] west_grant,
    output [5:0] gateway_grant
);


    // =========================================================
    // LOCAL OUTPUT ARBITER
    // =========================================================

    round_robin_arbiter RR_LOCAL
    (
        .clk(clk),
        .rst(rst),
        .request(local_req),
        .grant(local_grant)
    );


    // =========================================================
    // NORTH OUTPUT ARBITER
    // =========================================================

    round_robin_arbiter RR_NORTH
    (
        .clk(clk),
        .rst(rst),
        .request(north_req),
        .grant(north_grant)
    );


    // =========================================================
    // SOUTH OUTPUT ARBITER
    // =========================================================

    round_robin_arbiter RR_SOUTH
    (
        .clk(clk),
        .rst(rst),
        .request(south_req),
        .grant(south_grant)
    );


    // =========================================================
    // EAST OUTPUT ARBITER
    // =========================================================

    round_robin_arbiter RR_EAST
    (
        .clk(clk),
        .rst(rst),
        .request(east_req),
        .grant(east_grant)
    );


    // =========================================================
    // WEST OUTPUT ARBITER
    // =========================================================

    round_robin_arbiter RR_WEST
    (
        .clk(clk),
        .rst(rst),
        .request(west_req),
        .grant(west_grant)
    );


    // =========================================================
    // GATEWAY OUTPUT ARBITER
    // =========================================================

    round_robin_arbiter RR_GATEWAY
    (
        .clk(clk),
        .rst(rst),
        .request(gateway_req),
        .grant(gateway_grant)
    );

endmodule