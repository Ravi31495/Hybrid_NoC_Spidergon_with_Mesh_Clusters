`timescale 1ns / 1ps
`include "noc_defines.vh"

//////////////////////////////////////////////////////////////////////////////////
// Module Name : gateway_interface
//
// Description :
// Interface between the local gateway router and the global
// 4-cluster network.
//
// Local side:
//     local_packet_in  -> packet from gateway router
//     local_packet_out -> packet toward gateway router
//
// Global side:
//     NORTH
//     SOUTH
//     EAST
//     WEST
//
// The routing decision is supplied by route_direction.
//
// The module is intentionally combinational at this stage.
// FIFO buffering and arbitration will be added after the
// basic interface has been verified.
//////////////////////////////////////////////////////////////////////////////////

module gateway_interface
(
    input clk,
    input rst,

    //--------------------------------------------------
    // Local side
    //--------------------------------------------------

    input  [`PACKET_WIDTH-1:0] local_packet_in,
    input                       local_valid_in,
    output                      local_ready_out,

    output [`PACKET_WIDTH-1:0] local_packet_out,
    output                      local_valid_out,
    input                       local_ready_in,

    //--------------------------------------------------
    // Routing direction
    //--------------------------------------------------

    input [2:0] route_direction,

    //--------------------------------------------------
    // NORTH
    //--------------------------------------------------

    output [`PACKET_WIDTH-1:0] north_packet_out,
    output                      north_valid_out,
    input                       north_ready_in,

    input  [`PACKET_WIDTH-1:0] north_packet_in,
    input                       north_valid_in,
    output                      north_ready_out,

    //--------------------------------------------------
    // SOUTH
    //--------------------------------------------------

    output [`PACKET_WIDTH-1:0] south_packet_out,
    output                      south_valid_out,
    input                       south_ready_in,

    input  [`PACKET_WIDTH-1:0] south_packet_in,
    input                       south_valid_in,
    output                      south_ready_out,

    //--------------------------------------------------
    // EAST
    //--------------------------------------------------

    output [`PACKET_WIDTH-1:0] east_packet_out,
    output                      east_valid_out,
    input                       east_ready_in,

    input  [`PACKET_WIDTH-1:0] east_packet_in,
    input                       east_valid_in,
    output                      east_ready_out,

    //--------------------------------------------------
    // WEST
    //--------------------------------------------------

    output [`PACKET_WIDTH-1:0] west_packet_out,
    output                      west_valid_out,
    input                       west_ready_in,

    input  [`PACKET_WIDTH-1:0] west_packet_in,
    input                       west_valid_in,
    output                      west_ready_out
);


    //////////////////////////////////////////////////////
    // Direction Encoding
    //////////////////////////////////////////////////////

    localparam LOCAL = 3'b000;
    localparam NORTH = 3'b001;
    localparam SOUTH = 3'b010;
    localparam EAST  = 3'b011;
    localparam WEST  = 3'b100;


    //////////////////////////////////////////////////////
    // LOCAL -> GLOBAL
    //////////////////////////////////////////////////////

    assign north_packet_out = local_packet_in;
    assign south_packet_out = local_packet_in;
    assign east_packet_out  = local_packet_in;
    assign west_packet_out  = local_packet_in;


    //--------------------------------------------------
    // Only selected direction gets VALID
    //--------------------------------------------------

    assign north_valid_out =
        local_valid_in && (route_direction == NORTH);

    assign south_valid_out =
        local_valid_in && (route_direction == SOUTH);

    assign east_valid_out =
        local_valid_in && (route_direction == EAST);

    assign west_valid_out =
        local_valid_in && (route_direction == WEST);


    //--------------------------------------------------
    // Back-pressure to local router
    //--------------------------------------------------

    assign local_ready_out =
        (route_direction == NORTH) ? north_ready_in :
        (route_direction == SOUTH) ? south_ready_in :
        (route_direction == EAST ) ? east_ready_in  :
        (route_direction == WEST ) ? west_ready_in  :
        1'b1;


    //////////////////////////////////////////////////////
    // GLOBAL -> LOCAL
    //////////////////////////////////////////////////////

    assign local_packet_out =
        north_valid_in ? north_packet_in :
        south_valid_in ? south_packet_in :
        east_valid_in  ? east_packet_in  :
        west_valid_in  ? west_packet_in  :
        {`PACKET_WIDTH{1'b0}};


    assign local_valid_out =
        north_valid_in ||
        south_valid_in ||
        east_valid_in  ||
        west_valid_in;


    //////////////////////////////////////////////////////
    // GLOBAL -> LOCAL READY
    //
    // Fixed priority:
    //
    // NORTH > SOUTH > EAST > WEST
    //
    // Only the highest-priority active input is
    // granted to the local side.
    //////////////////////////////////////////////////////

    assign north_ready_out =
        local_ready_in;

    assign south_ready_out =
        local_ready_in && !north_valid_in;

    assign east_ready_out =
        local_ready_in &&
        !north_valid_in &&
        !south_valid_in;

    assign west_ready_out =
        local_ready_in &&
        !north_valid_in &&
        !south_valid_in &&
        !east_valid_in;


endmodule