`timescale 1ns / 1ps
`include "noc_defines.vh"

module routing_unit
(
    input [1:0] current_cluster,
    input [1:0] current_row,
    input [1:0] current_col,

    input [1:0] dest_cluster,
    input [1:0] dest_row,
    input [1:0] dest_col,

    input local_busy,
    input north_busy,
    input south_busy,
    input east_busy,
    input west_busy,

    output [2:0] final_direction
);

    // =========================================================
    // Direction encoding
    // =========================================================

    localparam [2:0] LOCAL   = 3'b000;
    localparam [2:0] NORTH   = 3'b001;
    localparam [2:0] SOUTH   = 3'b010;
    localparam [2:0] EAST    = 3'b011;
    localparam [2:0] WEST    = 3'b100;
    localparam [2:0] GATEWAY = 3'b101;


    // =========================================================
    // Internal signals
    // =========================================================

    wire       gateway_required;

    wire [2:0] xy_direction;
    wire [2:0] global_direction;

    wire [2:0] preferred_direction;
    wire [2:0] adaptive_direction;

    wire congested;


    // =========================================================
    // Gateway decision
    // =========================================================

    gateway_selector GS
    (
        .current_cluster(current_cluster),
        .dest_cluster(dest_cluster),
        .gateway_required(gateway_required)
    );


    // =========================================================
    // Local XY routing
    // =========================================================

    xy_routing XY
    (
        .current_row(current_row),
        .current_col(current_col),
        .dest_row(dest_row),
        .dest_col(dest_col),
        .direction(xy_direction)
    );


    // =========================================================
    // Global routing
    // =========================================================

    spidergon_routing SP
    (
        .current_gateway(current_cluster),
        .dest_gateway(dest_cluster),
        .direction(global_direction)
    );


    // =========================================================
    // Preferred direction
    //
    // Same cluster:
    //     XY
    //
    // Different cluster:
    //     Spidergon global direction
    // =========================================================

    assign preferred_direction =
        gateway_required ?
        global_direction :
        xy_direction;


    // =========================================================
    // Congestion checker
    //
    // Kept here because the module is part of the existing
    // architecture.
    // =========================================================

    congestion_checker CC
    (
        .local_busy(local_busy),
        .north_busy(north_busy),
        .south_busy(south_busy),
        .east_busy(east_busy),
        .west_busy(west_busy),

        .direction(preferred_direction),

        .congested(congested)
    );


    // =========================================================
    // Adaptive routing
    //
    // Still instantiated for the existing architecture.
    //
    // IMPORTANT:
    // Same-cluster traffic will NOT use adaptive_direction
    // below.
    // =========================================================

    adaptive_routing AR
    (
        .preferred_direction(preferred_direction),
        .congested(congested),

        .north_busy(north_busy),
        .south_busy(south_busy),
        .east_busy(east_busy),
        .west_busy(west_busy),

        .final_direction(adaptive_direction)
    );


    // =========================================================
    // FINAL ROUTING DECISION
    //
    // ---------------------------------------------------------
    // INTER-CLUSTER PACKET
    //
    // Packet must first reach R0, the gateway router.
    //
    // If row != 0:
    //     move NORTH toward R0
    //
    // If row == 0 and col != 0:
    //     move WEST toward R0
    //
    // If already at R0:
    //     GATEWAY
    //
    // ---------------------------------------------------------
    //
    // SAME-CLUSTER PACKET
    //
    // Use PURE XY routing.
    //
    // We intentionally bypass adaptive routing here.
    //
    // This prevents a packet such as:
    //
    //     C1/R0 -> C1/R2
    //
    // from being changed from:
    //
    //     SOUTH
    //
    // to:
    //
    //     EAST
    //
    // merely because another packet is occupying a path.
    // =========================================================

    assign final_direction =
        gateway_required ?
        (
            (current_row != 2'd0) ? NORTH :
            (current_col != 2'd0) ? WEST  :
                                     GATEWAY
        ) :
        xy_direction;


endmodule