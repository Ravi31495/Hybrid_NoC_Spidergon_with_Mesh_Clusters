`timescale 1ns/1ps

module router_control_logic
(
    input clk,
    input rst,

    // =========================================================
    // ARBITER GRANTS
    // =========================================================

    input [5:0] local_grant,
    input [5:0] north_grant,
    input [5:0] south_grant,
    input [5:0] east_grant,
    input [5:0] west_grant,
    input [5:0] gateway_grant,

    // =========================================================
    // OUTPUT READY SIGNALS
    // =========================================================

    input local_ready,
    input north_ready,
    input south_ready,
    input east_ready,
    input west_ready,
    input gateway_ready,

    // =========================================================
    // CROSSBAR SELECT SIGNALS
    // =========================================================

    output [2:0] sel0,
    output [2:0] sel1,
    output [2:0] sel2,
    output [2:0] sel3,
    output [2:0] sel4,
    output [2:0] sel5,

    // =========================================================
    // INPUT FIFO READ ENABLES
    // =========================================================

    output read_enable0,
    output read_enable1,
    output read_enable2,
    output read_enable3,
    output read_enable4,
    output read_enable5,

    // =========================================================
    // OUTPUT FIFO WRITE ENABLES
    // =========================================================

    output write_enable0,
    output write_enable1,
    output write_enable2,
    output write_enable3,
    output write_enable4,
    output write_enable5,

    // =========================================================
    // OUTPUT FIFO READ ENABLES
    // =========================================================

    output read_out0,
    output read_out1,
    output read_out2,
    output read_out3,
    output read_out4,
    output read_out5
);


    // =========================================================
    // GRANT -> CROSSBAR SELECT
    // =========================================================

    grant_to_select GTS0
    (
        .grant(local_grant),
        .sel(sel0)
    );

    grant_to_select GTS1
    (
        .grant(north_grant),
        .sel(sel1)
    );

    grant_to_select GTS2
    (
        .grant(south_grant),
        .sel(sel2)
    );

    grant_to_select GTS3
    (
        .grant(east_grant),
        .sel(sel3)
    );

    grant_to_select GTS4
    (
        .grant(west_grant),
        .sel(sel4)
    );

    grant_to_select GTS5
    (
        .grant(gateway_grant),
        .sel(sel5)
    );


    // =========================================================
    // INPUT FIFO READ ENABLE
    //
    // Input i is read whenever it wins ANY output arbitration.
    // =========================================================

    assign read_enable0 =
          local_grant[0]
        | north_grant[0]
        | south_grant[0]
        | east_grant[0]
        | west_grant[0]
        | gateway_grant[0];

    assign read_enable1 =
          local_grant[1]
        | north_grant[1]
        | south_grant[1]
        | east_grant[1]
        | west_grant[1]
        | gateway_grant[1];

    assign read_enable2 =
          local_grant[2]
        | north_grant[2]
        | south_grant[2]
        | east_grant[2]
        | west_grant[2]
        | gateway_grant[2];

    assign read_enable3 =
          local_grant[3]
        | north_grant[3]
        | south_grant[3]
        | east_grant[3]
        | west_grant[3]
        | gateway_grant[3];

    assign read_enable4 =
          local_grant[4]
        | north_grant[4]
        | south_grant[4]
        | east_grant[4]
        | west_grant[4]
        | gateway_grant[4];

    assign read_enable5 =
          local_grant[5]
        | north_grant[5]
        | south_grant[5]
        | east_grant[5]
        | west_grant[5]
        | gateway_grant[5];


    // =========================================================
    // OUTPUT FIFO WRITE ENABLE
    // =========================================================

    assign write_enable0 = |local_grant;
    assign write_enable1 = |north_grant;
    assign write_enable2 = |south_grant;
    assign write_enable3 = |east_grant;
    assign write_enable4 = |west_grant;
    assign write_enable5 = |gateway_grant;


    // =========================================================
    // OUTPUT FIFO READ ENABLE
    //
    // Always consume when downstream is ready.
    // =========================================================

    assign read_out0 = local_ready;
    assign read_out1 = north_ready;
    assign read_out2 = south_ready;
    assign read_out3 = east_ready;
    assign read_out4 = west_ready;
    assign read_out5 = gateway_ready;

endmodule