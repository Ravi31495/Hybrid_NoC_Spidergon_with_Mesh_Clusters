`timescale 1ns/1ps
`include "noc_defines.vh"

// ============================================================================
// HYBRID NoC V2 - METRICS SANITY TESTBENCH
//
// FROZEN DUT:
//   4 clusters x 4x4 mesh = 64 routers
//
// PURPOSE:
//   Validate the measurement layer before any throughput/load sweep.
//
// PHASE A:
//   10 packets: C0/R0 -> C0/R3
//   Expected implemented local hop count = 3
//
// PHASE B:
//   10 packets: C0/R0 -> C2/R3
//   Expected implemented hybrid hop count = 4
//   (0 local source-to-gateway + 1 global transfer + 3 destination-local)
//
// IMPORTANT:
//   This TB does NOT modify the V2 DUT.
//   The packet format remains the existing 48-bit format.
// ============================================================================

module hybrid_noc_v2_metrics_sanity_tb;

    localparam integer NUM_ROUTERS = 64;
    localparam integer PACKET_W    = `PACKET_WIDTH;

    reg clk;
    reg rst;

    reg  [PACKET_W-1:0] in_pkt [0:63];
    reg                 in_wr  [0:63];

    wire [PACKET_W-1:0] out_pkt   [0:63];
    wire                out_valid [0:63];

    // ========================================================================
    // PACKET GENERATOR IP
    // ========================================================================

    reg [1:0]  gen_dst_cluster;
    reg [1:0]  gen_dst_row;
    reg [1:0]  gen_dst_col;

    reg [1:0]  gen_src_cluster;
    reg [1:0]  gen_src_row;
    reg [1:0]  gen_src_col;

    reg [1:0]  gen_type;
    reg [1:0]  gen_priority;
    reg [31:0] gen_payload;

    wire [PACKET_W-1:0] gen_packet;
    wire                gen_valid;

    packet_generator GEN
    (
        .dst_cluster(gen_dst_cluster),
        .dst_row(gen_dst_row),
        .dst_col(gen_dst_col),

        .src_cluster(gen_src_cluster),
        .src_row(gen_src_row),
        .src_col(gen_src_col),

        .packet_type(gen_type),
        .priority(gen_priority),
        .payload(gen_payload),

        .packet(gen_packet),
        .packet_valid(gen_valid)
    );

    // ========================================================================
    // PACKET RECEIVER A
    // Destination C0/R0/C3 = flat index 3
    // ========================================================================

    wire        rxA_received;
    wire [1:0]  rxA_src_cluster;
    wire [1:0]  rxA_src_row;
    wire [1:0]  rxA_src_col;
    wire [1:0]  rxA_type;
    wire [1:0]  rxA_priority;
    wire [31:0] rxA_payload;

    packet_receiver RX_A
    (
        .clk(clk),
        .rst(rst),
        .packet_in(out_pkt[3]),
        .packet_valid_in(out_valid[3]),

        .my_cluster(2'd0),
        .my_row(2'd0),
        .my_col(2'd3),

        .packet_received(rxA_received),
        .src_cluster(rxA_src_cluster),
        .src_row(rxA_src_row),
        .src_col(rxA_src_col),
        .packet_type(rxA_type),
        .priority(rxA_priority),
        .payload(rxA_payload)
    );

    // ========================================================================
    // PACKET RECEIVER B
    // Destination C2/R0/C3 = flat index 35
    // ========================================================================

    wire        rxB_received;
    wire [1:0]  rxB_src_cluster;
    wire [1:0]  rxB_src_row;
    wire [1:0]  rxB_src_col;
    wire [1:0]  rxB_type;
    wire [1:0]  rxB_priority;
    wire [31:0] rxB_payload;

    packet_receiver RX_B
    (
        .clk(clk),
        .rst(rst),
        .packet_in(out_pkt[35]),
        .packet_valid_in(out_valid[35]),

        .my_cluster(2'd2),
        .my_row(2'd0),
        .my_col(2'd3),

        .packet_received(rxB_received),
        .src_cluster(rxB_src_cluster),
        .src_row(rxB_src_row),
        .src_col(rxB_src_col),
        .packet_type(rxB_type),
        .priority(rxB_priority),
        .payload(rxB_payload)
    );

    // ========================================================================
    // FROZEN V2 DUT
    // ========================================================================

    hybrid_noc_v2 DUT
    (
        .clk(clk),
        .rst(rst),
        .c0_local_packet_in0(in_pkt[0]),
        .c0_local_packet_in1(in_pkt[1]),
        .c0_local_packet_in2(in_pkt[2]),
        .c0_local_packet_in3(in_pkt[3]),
        .c0_local_packet_in4(in_pkt[4]),
        .c0_local_packet_in5(in_pkt[5]),
        .c0_local_packet_in6(in_pkt[6]),
        .c0_local_packet_in7(in_pkt[7]),
        .c0_local_packet_in8(in_pkt[8]),
        .c0_local_packet_in9(in_pkt[9]),
        .c0_local_packet_in10(in_pkt[10]),
        .c0_local_packet_in11(in_pkt[11]),
        .c0_local_packet_in12(in_pkt[12]),
        .c0_local_packet_in13(in_pkt[13]),
        .c0_local_packet_in14(in_pkt[14]),
        .c0_local_packet_in15(in_pkt[15]),
        .c1_local_packet_in0(in_pkt[16]),
        .c1_local_packet_in1(in_pkt[17]),
        .c1_local_packet_in2(in_pkt[18]),
        .c1_local_packet_in3(in_pkt[19]),
        .c1_local_packet_in4(in_pkt[20]),
        .c1_local_packet_in5(in_pkt[21]),
        .c1_local_packet_in6(in_pkt[22]),
        .c1_local_packet_in7(in_pkt[23]),
        .c1_local_packet_in8(in_pkt[24]),
        .c1_local_packet_in9(in_pkt[25]),
        .c1_local_packet_in10(in_pkt[26]),
        .c1_local_packet_in11(in_pkt[27]),
        .c1_local_packet_in12(in_pkt[28]),
        .c1_local_packet_in13(in_pkt[29]),
        .c1_local_packet_in14(in_pkt[30]),
        .c1_local_packet_in15(in_pkt[31]),
        .c2_local_packet_in0(in_pkt[32]),
        .c2_local_packet_in1(in_pkt[33]),
        .c2_local_packet_in2(in_pkt[34]),
        .c2_local_packet_in3(in_pkt[35]),
        .c2_local_packet_in4(in_pkt[36]),
        .c2_local_packet_in5(in_pkt[37]),
        .c2_local_packet_in6(in_pkt[38]),
        .c2_local_packet_in7(in_pkt[39]),
        .c2_local_packet_in8(in_pkt[40]),
        .c2_local_packet_in9(in_pkt[41]),
        .c2_local_packet_in10(in_pkt[42]),
        .c2_local_packet_in11(in_pkt[43]),
        .c2_local_packet_in12(in_pkt[44]),
        .c2_local_packet_in13(in_pkt[45]),
        .c2_local_packet_in14(in_pkt[46]),
        .c2_local_packet_in15(in_pkt[47]),
        .c3_local_packet_in0(in_pkt[48]),
        .c3_local_packet_in1(in_pkt[49]),
        .c3_local_packet_in2(in_pkt[50]),
        .c3_local_packet_in3(in_pkt[51]),
        .c3_local_packet_in4(in_pkt[52]),
        .c3_local_packet_in5(in_pkt[53]),
        .c3_local_packet_in6(in_pkt[54]),
        .c3_local_packet_in7(in_pkt[55]),
        .c3_local_packet_in8(in_pkt[56]),
        .c3_local_packet_in9(in_pkt[57]),
        .c3_local_packet_in10(in_pkt[58]),
        .c3_local_packet_in11(in_pkt[59]),
        .c3_local_packet_in12(in_pkt[60]),
        .c3_local_packet_in13(in_pkt[61]),
        .c3_local_packet_in14(in_pkt[62]),
        .c3_local_packet_in15(in_pkt[63]),
        .c0_local_write0(in_wr[0]),
        .c0_local_write1(in_wr[1]),
        .c0_local_write2(in_wr[2]),
        .c0_local_write3(in_wr[3]),
        .c0_local_write4(in_wr[4]),
        .c0_local_write5(in_wr[5]),
        .c0_local_write6(in_wr[6]),
        .c0_local_write7(in_wr[7]),
        .c0_local_write8(in_wr[8]),
        .c0_local_write9(in_wr[9]),
        .c0_local_write10(in_wr[10]),
        .c0_local_write11(in_wr[11]),
        .c0_local_write12(in_wr[12]),
        .c0_local_write13(in_wr[13]),
        .c0_local_write14(in_wr[14]),
        .c0_local_write15(in_wr[15]),
        .c1_local_write0(in_wr[16]),
        .c1_local_write1(in_wr[17]),
        .c1_local_write2(in_wr[18]),
        .c1_local_write3(in_wr[19]),
        .c1_local_write4(in_wr[20]),
        .c1_local_write5(in_wr[21]),
        .c1_local_write6(in_wr[22]),
        .c1_local_write7(in_wr[23]),
        .c1_local_write8(in_wr[24]),
        .c1_local_write9(in_wr[25]),
        .c1_local_write10(in_wr[26]),
        .c1_local_write11(in_wr[27]),
        .c1_local_write12(in_wr[28]),
        .c1_local_write13(in_wr[29]),
        .c1_local_write14(in_wr[30]),
        .c1_local_write15(in_wr[31]),
        .c2_local_write0(in_wr[32]),
        .c2_local_write1(in_wr[33]),
        .c2_local_write2(in_wr[34]),
        .c2_local_write3(in_wr[35]),
        .c2_local_write4(in_wr[36]),
        .c2_local_write5(in_wr[37]),
        .c2_local_write6(in_wr[38]),
        .c2_local_write7(in_wr[39]),
        .c2_local_write8(in_wr[40]),
        .c2_local_write9(in_wr[41]),
        .c2_local_write10(in_wr[42]),
        .c2_local_write11(in_wr[43]),
        .c2_local_write12(in_wr[44]),
        .c2_local_write13(in_wr[45]),
        .c2_local_write14(in_wr[46]),
        .c2_local_write15(in_wr[47]),
        .c3_local_write0(in_wr[48]),
        .c3_local_write1(in_wr[49]),
        .c3_local_write2(in_wr[50]),
        .c3_local_write3(in_wr[51]),
        .c3_local_write4(in_wr[52]),
        .c3_local_write5(in_wr[53]),
        .c3_local_write6(in_wr[54]),
        .c3_local_write7(in_wr[55]),
        .c3_local_write8(in_wr[56]),
        .c3_local_write9(in_wr[57]),
        .c3_local_write10(in_wr[58]),
        .c3_local_write11(in_wr[59]),
        .c3_local_write12(in_wr[60]),
        .c3_local_write13(in_wr[61]),
        .c3_local_write14(in_wr[62]),
        .c3_local_write15(in_wr[63]),
        .c0_local_packet_out0(out_pkt[0]),
        .c0_local_packet_out1(out_pkt[1]),
        .c0_local_packet_out2(out_pkt[2]),
        .c0_local_packet_out3(out_pkt[3]),
        .c0_local_packet_out4(out_pkt[4]),
        .c0_local_packet_out5(out_pkt[5]),
        .c0_local_packet_out6(out_pkt[6]),
        .c0_local_packet_out7(out_pkt[7]),
        .c0_local_packet_out8(out_pkt[8]),
        .c0_local_packet_out9(out_pkt[9]),
        .c0_local_packet_out10(out_pkt[10]),
        .c0_local_packet_out11(out_pkt[11]),
        .c0_local_packet_out12(out_pkt[12]),
        .c0_local_packet_out13(out_pkt[13]),
        .c0_local_packet_out14(out_pkt[14]),
        .c0_local_packet_out15(out_pkt[15]),
        .c1_local_packet_out0(out_pkt[16]),
        .c1_local_packet_out1(out_pkt[17]),
        .c1_local_packet_out2(out_pkt[18]),
        .c1_local_packet_out3(out_pkt[19]),
        .c1_local_packet_out4(out_pkt[20]),
        .c1_local_packet_out5(out_pkt[21]),
        .c1_local_packet_out6(out_pkt[22]),
        .c1_local_packet_out7(out_pkt[23]),
        .c1_local_packet_out8(out_pkt[24]),
        .c1_local_packet_out9(out_pkt[25]),
        .c1_local_packet_out10(out_pkt[26]),
        .c1_local_packet_out11(out_pkt[27]),
        .c1_local_packet_out12(out_pkt[28]),
        .c1_local_packet_out13(out_pkt[29]),
        .c1_local_packet_out14(out_pkt[30]),
        .c1_local_packet_out15(out_pkt[31]),
        .c2_local_packet_out0(out_pkt[32]),
        .c2_local_packet_out1(out_pkt[33]),
        .c2_local_packet_out2(out_pkt[34]),
        .c2_local_packet_out3(out_pkt[35]),
        .c2_local_packet_out4(out_pkt[36]),
        .c2_local_packet_out5(out_pkt[37]),
        .c2_local_packet_out6(out_pkt[38]),
        .c2_local_packet_out7(out_pkt[39]),
        .c2_local_packet_out8(out_pkt[40]),
        .c2_local_packet_out9(out_pkt[41]),
        .c2_local_packet_out10(out_pkt[42]),
        .c2_local_packet_out11(out_pkt[43]),
        .c2_local_packet_out12(out_pkt[44]),
        .c2_local_packet_out13(out_pkt[45]),
        .c2_local_packet_out14(out_pkt[46]),
        .c2_local_packet_out15(out_pkt[47]),
        .c3_local_packet_out0(out_pkt[48]),
        .c3_local_packet_out1(out_pkt[49]),
        .c3_local_packet_out2(out_pkt[50]),
        .c3_local_packet_out3(out_pkt[51]),
        .c3_local_packet_out4(out_pkt[52]),
        .c3_local_packet_out5(out_pkt[53]),
        .c3_local_packet_out6(out_pkt[54]),
        .c3_local_packet_out7(out_pkt[55]),
        .c3_local_packet_out8(out_pkt[56]),
        .c3_local_packet_out9(out_pkt[57]),
        .c3_local_packet_out10(out_pkt[58]),
        .c3_local_packet_out11(out_pkt[59]),
        .c3_local_packet_out12(out_pkt[60]),
        .c3_local_packet_out13(out_pkt[61]),
        .c3_local_packet_out14(out_pkt[62]),
        .c3_local_packet_out15(out_pkt[63]),
        .c0_local_valid0(out_valid[0]),
        .c0_local_valid1(out_valid[1]),
        .c0_local_valid2(out_valid[2]),
        .c0_local_valid3(out_valid[3]),
        .c0_local_valid4(out_valid[4]),
        .c0_local_valid5(out_valid[5]),
        .c0_local_valid6(out_valid[6]),
        .c0_local_valid7(out_valid[7]),
        .c0_local_valid8(out_valid[8]),
        .c0_local_valid9(out_valid[9]),
        .c0_local_valid10(out_valid[10]),
        .c0_local_valid11(out_valid[11]),
        .c0_local_valid12(out_valid[12]),
        .c0_local_valid13(out_valid[13]),
        .c0_local_valid14(out_valid[14]),
        .c0_local_valid15(out_valid[15]),
        .c1_local_valid0(out_valid[16]),
        .c1_local_valid1(out_valid[17]),
        .c1_local_valid2(out_valid[18]),
        .c1_local_valid3(out_valid[19]),
        .c1_local_valid4(out_valid[20]),
        .c1_local_valid5(out_valid[21]),
        .c1_local_valid6(out_valid[22]),
        .c1_local_valid7(out_valid[23]),
        .c1_local_valid8(out_valid[24]),
        .c1_local_valid9(out_valid[25]),
        .c1_local_valid10(out_valid[26]),
        .c1_local_valid11(out_valid[27]),
        .c1_local_valid12(out_valid[28]),
        .c1_local_valid13(out_valid[29]),
        .c1_local_valid14(out_valid[30]),
        .c1_local_valid15(out_valid[31]),
        .c2_local_valid0(out_valid[32]),
        .c2_local_valid1(out_valid[33]),
        .c2_local_valid2(out_valid[34]),
        .c2_local_valid3(out_valid[35]),
        .c2_local_valid4(out_valid[36]),
        .c2_local_valid5(out_valid[37]),
        .c2_local_valid6(out_valid[38]),
        .c2_local_valid7(out_valid[39]),
        .c2_local_valid8(out_valid[40]),
        .c2_local_valid9(out_valid[41]),
        .c2_local_valid10(out_valid[42]),
        .c2_local_valid11(out_valid[43]),
        .c2_local_valid12(out_valid[44]),
        .c2_local_valid13(out_valid[45]),
        .c2_local_valid14(out_valid[46]),
        .c2_local_valid15(out_valid[47]),
        .c3_local_valid0(out_valid[48]),
        .c3_local_valid1(out_valid[49]),
        .c3_local_valid2(out_valid[50]),
        .c3_local_valid3(out_valid[51]),
        .c3_local_valid4(out_valid[52]),
        .c3_local_valid5(out_valid[53]),
        .c3_local_valid6(out_valid[54]),
        .c3_local_valid7(out_valid[55]),
        .c3_local_valid8(out_valid[56]),
        .c3_local_valid9(out_valid[57]),
        .c3_local_valid10(out_valid[58]),
        .c3_local_valid11(out_valid[59]),
        .c3_local_valid12(out_valid[60]),
        .c3_local_valid13(out_valid[61]),
        .c3_local_valid14(out_valid[62]),
        .c3_local_valid15(out_valid[63])
    );

    // ========================================================================
    // METRICS EVENT BUSES
    // ========================================================================

    wire [63:0] inject_event;
    wire [63:0] receive_event;

    wire [64*PACKET_W-1:0] inject_packet_bus;
    wire [64*PACKET_W-1:0] receive_packet_bus;

    assign inject_event[0] = in_wr[0];
    assign inject_packet_bus[0 +: 48] = in_pkt[0];
    assign receive_event[0] = out_valid[0];
    assign receive_packet_bus[0 +: 48] = out_pkt[0];
    assign inject_event[1] = in_wr[1];
    assign inject_packet_bus[48 +: 48] = in_pkt[1];
    assign receive_event[1] = out_valid[1];
    assign receive_packet_bus[48 +: 48] = out_pkt[1];
    assign inject_event[2] = in_wr[2];
    assign inject_packet_bus[96 +: 48] = in_pkt[2];
    assign receive_event[2] = out_valid[2];
    assign receive_packet_bus[96 +: 48] = out_pkt[2];
    assign inject_event[3] = in_wr[3];
    assign inject_packet_bus[144 +: 48] = in_pkt[3];
    assign receive_event[3] = out_valid[3];
    assign receive_packet_bus[144 +: 48] = out_pkt[3];
    assign inject_event[4] = in_wr[4];
    assign inject_packet_bus[192 +: 48] = in_pkt[4];
    assign receive_event[4] = out_valid[4];
    assign receive_packet_bus[192 +: 48] = out_pkt[4];
    assign inject_event[5] = in_wr[5];
    assign inject_packet_bus[240 +: 48] = in_pkt[5];
    assign receive_event[5] = out_valid[5];
    assign receive_packet_bus[240 +: 48] = out_pkt[5];
    assign inject_event[6] = in_wr[6];
    assign inject_packet_bus[288 +: 48] = in_pkt[6];
    assign receive_event[6] = out_valid[6];
    assign receive_packet_bus[288 +: 48] = out_pkt[6];
    assign inject_event[7] = in_wr[7];
    assign inject_packet_bus[336 +: 48] = in_pkt[7];
    assign receive_event[7] = out_valid[7];
    assign receive_packet_bus[336 +: 48] = out_pkt[7];
    assign inject_event[8] = in_wr[8];
    assign inject_packet_bus[384 +: 48] = in_pkt[8];
    assign receive_event[8] = out_valid[8];
    assign receive_packet_bus[384 +: 48] = out_pkt[8];
    assign inject_event[9] = in_wr[9];
    assign inject_packet_bus[432 +: 48] = in_pkt[9];
    assign receive_event[9] = out_valid[9];
    assign receive_packet_bus[432 +: 48] = out_pkt[9];
    assign inject_event[10] = in_wr[10];
    assign inject_packet_bus[480 +: 48] = in_pkt[10];
    assign receive_event[10] = out_valid[10];
    assign receive_packet_bus[480 +: 48] = out_pkt[10];
    assign inject_event[11] = in_wr[11];
    assign inject_packet_bus[528 +: 48] = in_pkt[11];
    assign receive_event[11] = out_valid[11];
    assign receive_packet_bus[528 +: 48] = out_pkt[11];
    assign inject_event[12] = in_wr[12];
    assign inject_packet_bus[576 +: 48] = in_pkt[12];
    assign receive_event[12] = out_valid[12];
    assign receive_packet_bus[576 +: 48] = out_pkt[12];
    assign inject_event[13] = in_wr[13];
    assign inject_packet_bus[624 +: 48] = in_pkt[13];
    assign receive_event[13] = out_valid[13];
    assign receive_packet_bus[624 +: 48] = out_pkt[13];
    assign inject_event[14] = in_wr[14];
    assign inject_packet_bus[672 +: 48] = in_pkt[14];
    assign receive_event[14] = out_valid[14];
    assign receive_packet_bus[672 +: 48] = out_pkt[14];
    assign inject_event[15] = in_wr[15];
    assign inject_packet_bus[720 +: 48] = in_pkt[15];
    assign receive_event[15] = out_valid[15];
    assign receive_packet_bus[720 +: 48] = out_pkt[15];
    assign inject_event[16] = in_wr[16];
    assign inject_packet_bus[768 +: 48] = in_pkt[16];
    assign receive_event[16] = out_valid[16];
    assign receive_packet_bus[768 +: 48] = out_pkt[16];
    assign inject_event[17] = in_wr[17];
    assign inject_packet_bus[816 +: 48] = in_pkt[17];
    assign receive_event[17] = out_valid[17];
    assign receive_packet_bus[816 +: 48] = out_pkt[17];
    assign inject_event[18] = in_wr[18];
    assign inject_packet_bus[864 +: 48] = in_pkt[18];
    assign receive_event[18] = out_valid[18];
    assign receive_packet_bus[864 +: 48] = out_pkt[18];
    assign inject_event[19] = in_wr[19];
    assign inject_packet_bus[912 +: 48] = in_pkt[19];
    assign receive_event[19] = out_valid[19];
    assign receive_packet_bus[912 +: 48] = out_pkt[19];
    assign inject_event[20] = in_wr[20];
    assign inject_packet_bus[960 +: 48] = in_pkt[20];
    assign receive_event[20] = out_valid[20];
    assign receive_packet_bus[960 +: 48] = out_pkt[20];
    assign inject_event[21] = in_wr[21];
    assign inject_packet_bus[1008 +: 48] = in_pkt[21];
    assign receive_event[21] = out_valid[21];
    assign receive_packet_bus[1008 +: 48] = out_pkt[21];
    assign inject_event[22] = in_wr[22];
    assign inject_packet_bus[1056 +: 48] = in_pkt[22];
    assign receive_event[22] = out_valid[22];
    assign receive_packet_bus[1056 +: 48] = out_pkt[22];
    assign inject_event[23] = in_wr[23];
    assign inject_packet_bus[1104 +: 48] = in_pkt[23];
    assign receive_event[23] = out_valid[23];
    assign receive_packet_bus[1104 +: 48] = out_pkt[23];
    assign inject_event[24] = in_wr[24];
    assign inject_packet_bus[1152 +: 48] = in_pkt[24];
    assign receive_event[24] = out_valid[24];
    assign receive_packet_bus[1152 +: 48] = out_pkt[24];
    assign inject_event[25] = in_wr[25];
    assign inject_packet_bus[1200 +: 48] = in_pkt[25];
    assign receive_event[25] = out_valid[25];
    assign receive_packet_bus[1200 +: 48] = out_pkt[25];
    assign inject_event[26] = in_wr[26];
    assign inject_packet_bus[1248 +: 48] = in_pkt[26];
    assign receive_event[26] = out_valid[26];
    assign receive_packet_bus[1248 +: 48] = out_pkt[26];
    assign inject_event[27] = in_wr[27];
    assign inject_packet_bus[1296 +: 48] = in_pkt[27];
    assign receive_event[27] = out_valid[27];
    assign receive_packet_bus[1296 +: 48] = out_pkt[27];
    assign inject_event[28] = in_wr[28];
    assign inject_packet_bus[1344 +: 48] = in_pkt[28];
    assign receive_event[28] = out_valid[28];
    assign receive_packet_bus[1344 +: 48] = out_pkt[28];
    assign inject_event[29] = in_wr[29];
    assign inject_packet_bus[1392 +: 48] = in_pkt[29];
    assign receive_event[29] = out_valid[29];
    assign receive_packet_bus[1392 +: 48] = out_pkt[29];
    assign inject_event[30] = in_wr[30];
    assign inject_packet_bus[1440 +: 48] = in_pkt[30];
    assign receive_event[30] = out_valid[30];
    assign receive_packet_bus[1440 +: 48] = out_pkt[30];
    assign inject_event[31] = in_wr[31];
    assign inject_packet_bus[1488 +: 48] = in_pkt[31];
    assign receive_event[31] = out_valid[31];
    assign receive_packet_bus[1488 +: 48] = out_pkt[31];
    assign inject_event[32] = in_wr[32];
    assign inject_packet_bus[1536 +: 48] = in_pkt[32];
    assign receive_event[32] = out_valid[32];
    assign receive_packet_bus[1536 +: 48] = out_pkt[32];
    assign inject_event[33] = in_wr[33];
    assign inject_packet_bus[1584 +: 48] = in_pkt[33];
    assign receive_event[33] = out_valid[33];
    assign receive_packet_bus[1584 +: 48] = out_pkt[33];
    assign inject_event[34] = in_wr[34];
    assign inject_packet_bus[1632 +: 48] = in_pkt[34];
    assign receive_event[34] = out_valid[34];
    assign receive_packet_bus[1632 +: 48] = out_pkt[34];
    assign inject_event[35] = in_wr[35];
    assign inject_packet_bus[1680 +: 48] = in_pkt[35];
    assign receive_event[35] = out_valid[35];
    assign receive_packet_bus[1680 +: 48] = out_pkt[35];
    assign inject_event[36] = in_wr[36];
    assign inject_packet_bus[1728 +: 48] = in_pkt[36];
    assign receive_event[36] = out_valid[36];
    assign receive_packet_bus[1728 +: 48] = out_pkt[36];
    assign inject_event[37] = in_wr[37];
    assign inject_packet_bus[1776 +: 48] = in_pkt[37];
    assign receive_event[37] = out_valid[37];
    assign receive_packet_bus[1776 +: 48] = out_pkt[37];
    assign inject_event[38] = in_wr[38];
    assign inject_packet_bus[1824 +: 48] = in_pkt[38];
    assign receive_event[38] = out_valid[38];
    assign receive_packet_bus[1824 +: 48] = out_pkt[38];
    assign inject_event[39] = in_wr[39];
    assign inject_packet_bus[1872 +: 48] = in_pkt[39];
    assign receive_event[39] = out_valid[39];
    assign receive_packet_bus[1872 +: 48] = out_pkt[39];
    assign inject_event[40] = in_wr[40];
    assign inject_packet_bus[1920 +: 48] = in_pkt[40];
    assign receive_event[40] = out_valid[40];
    assign receive_packet_bus[1920 +: 48] = out_pkt[40];
    assign inject_event[41] = in_wr[41];
    assign inject_packet_bus[1968 +: 48] = in_pkt[41];
    assign receive_event[41] = out_valid[41];
    assign receive_packet_bus[1968 +: 48] = out_pkt[41];
    assign inject_event[42] = in_wr[42];
    assign inject_packet_bus[2016 +: 48] = in_pkt[42];
    assign receive_event[42] = out_valid[42];
    assign receive_packet_bus[2016 +: 48] = out_pkt[42];
    assign inject_event[43] = in_wr[43];
    assign inject_packet_bus[2064 +: 48] = in_pkt[43];
    assign receive_event[43] = out_valid[43];
    assign receive_packet_bus[2064 +: 48] = out_pkt[43];
    assign inject_event[44] = in_wr[44];
    assign inject_packet_bus[2112 +: 48] = in_pkt[44];
    assign receive_event[44] = out_valid[44];
    assign receive_packet_bus[2112 +: 48] = out_pkt[44];
    assign inject_event[45] = in_wr[45];
    assign inject_packet_bus[2160 +: 48] = in_pkt[45];
    assign receive_event[45] = out_valid[45];
    assign receive_packet_bus[2160 +: 48] = out_pkt[45];
    assign inject_event[46] = in_wr[46];
    assign inject_packet_bus[2208 +: 48] = in_pkt[46];
    assign receive_event[46] = out_valid[46];
    assign receive_packet_bus[2208 +: 48] = out_pkt[46];
    assign inject_event[47] = in_wr[47];
    assign inject_packet_bus[2256 +: 48] = in_pkt[47];
    assign receive_event[47] = out_valid[47];
    assign receive_packet_bus[2256 +: 48] = out_pkt[47];
    assign inject_event[48] = in_wr[48];
    assign inject_packet_bus[2304 +: 48] = in_pkt[48];
    assign receive_event[48] = out_valid[48];
    assign receive_packet_bus[2304 +: 48] = out_pkt[48];
    assign inject_event[49] = in_wr[49];
    assign inject_packet_bus[2352 +: 48] = in_pkt[49];
    assign receive_event[49] = out_valid[49];
    assign receive_packet_bus[2352 +: 48] = out_pkt[49];
    assign inject_event[50] = in_wr[50];
    assign inject_packet_bus[2400 +: 48] = in_pkt[50];
    assign receive_event[50] = out_valid[50];
    assign receive_packet_bus[2400 +: 48] = out_pkt[50];
    assign inject_event[51] = in_wr[51];
    assign inject_packet_bus[2448 +: 48] = in_pkt[51];
    assign receive_event[51] = out_valid[51];
    assign receive_packet_bus[2448 +: 48] = out_pkt[51];
    assign inject_event[52] = in_wr[52];
    assign inject_packet_bus[2496 +: 48] = in_pkt[52];
    assign receive_event[52] = out_valid[52];
    assign receive_packet_bus[2496 +: 48] = out_pkt[52];
    assign inject_event[53] = in_wr[53];
    assign inject_packet_bus[2544 +: 48] = in_pkt[53];
    assign receive_event[53] = out_valid[53];
    assign receive_packet_bus[2544 +: 48] = out_pkt[53];
    assign inject_event[54] = in_wr[54];
    assign inject_packet_bus[2592 +: 48] = in_pkt[54];
    assign receive_event[54] = out_valid[54];
    assign receive_packet_bus[2592 +: 48] = out_pkt[54];
    assign inject_event[55] = in_wr[55];
    assign inject_packet_bus[2640 +: 48] = in_pkt[55];
    assign receive_event[55] = out_valid[55];
    assign receive_packet_bus[2640 +: 48] = out_pkt[55];
    assign inject_event[56] = in_wr[56];
    assign inject_packet_bus[2688 +: 48] = in_pkt[56];
    assign receive_event[56] = out_valid[56];
    assign receive_packet_bus[2688 +: 48] = out_pkt[56];
    assign inject_event[57] = in_wr[57];
    assign inject_packet_bus[2736 +: 48] = in_pkt[57];
    assign receive_event[57] = out_valid[57];
    assign receive_packet_bus[2736 +: 48] = out_pkt[57];
    assign inject_event[58] = in_wr[58];
    assign inject_packet_bus[2784 +: 48] = in_pkt[58];
    assign receive_event[58] = out_valid[58];
    assign receive_packet_bus[2784 +: 48] = out_pkt[58];
    assign inject_event[59] = in_wr[59];
    assign inject_packet_bus[2832 +: 48] = in_pkt[59];
    assign receive_event[59] = out_valid[59];
    assign receive_packet_bus[2832 +: 48] = out_pkt[59];
    assign inject_event[60] = in_wr[60];
    assign inject_packet_bus[2880 +: 48] = in_pkt[60];
    assign receive_event[60] = out_valid[60];
    assign receive_packet_bus[2880 +: 48] = out_pkt[60];
    assign inject_event[61] = in_wr[61];
    assign inject_packet_bus[2928 +: 48] = in_pkt[61];
    assign receive_event[61] = out_valid[61];
    assign receive_packet_bus[2928 +: 48] = out_pkt[61];
    assign inject_event[62] = in_wr[62];
    assign inject_packet_bus[2976 +: 48] = in_pkt[62];
    assign receive_event[62] = out_valid[62];
    assign receive_packet_bus[2976 +: 48] = out_pkt[62];
    assign inject_event[63] = in_wr[63];
    assign inject_packet_bus[3024 +: 48] = in_pkt[63];
    assign receive_event[63] = out_valid[63];
    assign receive_packet_bus[3024 +: 48] = out_pkt[63];

    // ========================================================================
    // METRICS MONITOR
    // ========================================================================

    wire [31:0] packets_injected;
    wire [31:0] packets_received;
    wire [31:0] unmatched_receives;

    wire [63:0] total_latency;
    wire [63:0] min_latency;
    wire [63:0] max_latency;

    wire [63:0] total_hops;
    wire [31:0] min_hops;
    wire [31:0] max_hops;

    wire [63:0] experiment_cycles;

    noc_v2_metrics_monitor #(.MAX_INFLIGHT(1024)) METRICS
    (
        .clk(clk),
        .rst(rst),

        .inject_event(inject_event),
        .receive_event(receive_event),

        .inject_packet_bus(inject_packet_bus),
        .receive_packet_bus(receive_packet_bus),

        .packets_injected(packets_injected),
        .packets_received(packets_received),
        .unmatched_receives(unmatched_receives),

        .total_latency(total_latency),
        .min_latency(min_latency),
        .max_latency(max_latency),

        .total_hops(total_hops),
        .min_hops(min_hops),
        .max_hops(max_hops),

        .experiment_cycles(experiment_cycles)
    );

    // ========================================================================
    // TEST VARIABLES
    // ========================================================================

    integer k;
    integer count;

    integer start_injected;
    integer start_received;
    integer start_latency;
    integer start_hops;
    integer start_unmatched;

    integer phase_injected;
    integer phase_received;
    integer phase_latency;
    integer phase_hops;
    integer phase_unmatched;

    integer cumulative_injected;
    integer cumulative_received;
    integer cumulative_latency;
    integer cumulative_hops;
    integer cumulative_unmatched;

    integer local_pass;
    integer global_pass;

    reg [PACKET_W-1:0] expected_packet;

    always #5 clk = ~clk;

    // ========================================================================
    // CLEAR ALL 64 INJECTION PORTS
    // ========================================================================

    task clear_inputs;
    begin
        in_pkt[0] = {`PACKET_WIDTH{1'b0}}; in_wr[0] = 1'b0;
        in_pkt[1] = {`PACKET_WIDTH{1'b0}}; in_wr[1] = 1'b0;
        in_pkt[2] = {`PACKET_WIDTH{1'b0}}; in_wr[2] = 1'b0;
        in_pkt[3] = {`PACKET_WIDTH{1'b0}}; in_wr[3] = 1'b0;
        in_pkt[4] = {`PACKET_WIDTH{1'b0}}; in_wr[4] = 1'b0;
        in_pkt[5] = {`PACKET_WIDTH{1'b0}}; in_wr[5] = 1'b0;
        in_pkt[6] = {`PACKET_WIDTH{1'b0}}; in_wr[6] = 1'b0;
        in_pkt[7] = {`PACKET_WIDTH{1'b0}}; in_wr[7] = 1'b0;
        in_pkt[8] = {`PACKET_WIDTH{1'b0}}; in_wr[8] = 1'b0;
        in_pkt[9] = {`PACKET_WIDTH{1'b0}}; in_wr[9] = 1'b0;
        in_pkt[10] = {`PACKET_WIDTH{1'b0}}; in_wr[10] = 1'b0;
        in_pkt[11] = {`PACKET_WIDTH{1'b0}}; in_wr[11] = 1'b0;
        in_pkt[12] = {`PACKET_WIDTH{1'b0}}; in_wr[12] = 1'b0;
        in_pkt[13] = {`PACKET_WIDTH{1'b0}}; in_wr[13] = 1'b0;
        in_pkt[14] = {`PACKET_WIDTH{1'b0}}; in_wr[14] = 1'b0;
        in_pkt[15] = {`PACKET_WIDTH{1'b0}}; in_wr[15] = 1'b0;
        in_pkt[16] = {`PACKET_WIDTH{1'b0}}; in_wr[16] = 1'b0;
        in_pkt[17] = {`PACKET_WIDTH{1'b0}}; in_wr[17] = 1'b0;
        in_pkt[18] = {`PACKET_WIDTH{1'b0}}; in_wr[18] = 1'b0;
        in_pkt[19] = {`PACKET_WIDTH{1'b0}}; in_wr[19] = 1'b0;
        in_pkt[20] = {`PACKET_WIDTH{1'b0}}; in_wr[20] = 1'b0;
        in_pkt[21] = {`PACKET_WIDTH{1'b0}}; in_wr[21] = 1'b0;
        in_pkt[22] = {`PACKET_WIDTH{1'b0}}; in_wr[22] = 1'b0;
        in_pkt[23] = {`PACKET_WIDTH{1'b0}}; in_wr[23] = 1'b0;
        in_pkt[24] = {`PACKET_WIDTH{1'b0}}; in_wr[24] = 1'b0;
        in_pkt[25] = {`PACKET_WIDTH{1'b0}}; in_wr[25] = 1'b0;
        in_pkt[26] = {`PACKET_WIDTH{1'b0}}; in_wr[26] = 1'b0;
        in_pkt[27] = {`PACKET_WIDTH{1'b0}}; in_wr[27] = 1'b0;
        in_pkt[28] = {`PACKET_WIDTH{1'b0}}; in_wr[28] = 1'b0;
        in_pkt[29] = {`PACKET_WIDTH{1'b0}}; in_wr[29] = 1'b0;
        in_pkt[30] = {`PACKET_WIDTH{1'b0}}; in_wr[30] = 1'b0;
        in_pkt[31] = {`PACKET_WIDTH{1'b0}}; in_wr[31] = 1'b0;
        in_pkt[32] = {`PACKET_WIDTH{1'b0}}; in_wr[32] = 1'b0;
        in_pkt[33] = {`PACKET_WIDTH{1'b0}}; in_wr[33] = 1'b0;
        in_pkt[34] = {`PACKET_WIDTH{1'b0}}; in_wr[34] = 1'b0;
        in_pkt[35] = {`PACKET_WIDTH{1'b0}}; in_wr[35] = 1'b0;
        in_pkt[36] = {`PACKET_WIDTH{1'b0}}; in_wr[36] = 1'b0;
        in_pkt[37] = {`PACKET_WIDTH{1'b0}}; in_wr[37] = 1'b0;
        in_pkt[38] = {`PACKET_WIDTH{1'b0}}; in_wr[38] = 1'b0;
        in_pkt[39] = {`PACKET_WIDTH{1'b0}}; in_wr[39] = 1'b0;
        in_pkt[40] = {`PACKET_WIDTH{1'b0}}; in_wr[40] = 1'b0;
        in_pkt[41] = {`PACKET_WIDTH{1'b0}}; in_wr[41] = 1'b0;
        in_pkt[42] = {`PACKET_WIDTH{1'b0}}; in_wr[42] = 1'b0;
        in_pkt[43] = {`PACKET_WIDTH{1'b0}}; in_wr[43] = 1'b0;
        in_pkt[44] = {`PACKET_WIDTH{1'b0}}; in_wr[44] = 1'b0;
        in_pkt[45] = {`PACKET_WIDTH{1'b0}}; in_wr[45] = 1'b0;
        in_pkt[46] = {`PACKET_WIDTH{1'b0}}; in_wr[46] = 1'b0;
        in_pkt[47] = {`PACKET_WIDTH{1'b0}}; in_wr[47] = 1'b0;
        in_pkt[48] = {`PACKET_WIDTH{1'b0}}; in_wr[48] = 1'b0;
        in_pkt[49] = {`PACKET_WIDTH{1'b0}}; in_wr[49] = 1'b0;
        in_pkt[50] = {`PACKET_WIDTH{1'b0}}; in_wr[50] = 1'b0;
        in_pkt[51] = {`PACKET_WIDTH{1'b0}}; in_wr[51] = 1'b0;
        in_pkt[52] = {`PACKET_WIDTH{1'b0}}; in_wr[52] = 1'b0;
        in_pkt[53] = {`PACKET_WIDTH{1'b0}}; in_wr[53] = 1'b0;
        in_pkt[54] = {`PACKET_WIDTH{1'b0}}; in_wr[54] = 1'b0;
        in_pkt[55] = {`PACKET_WIDTH{1'b0}}; in_wr[55] = 1'b0;
        in_pkt[56] = {`PACKET_WIDTH{1'b0}}; in_wr[56] = 1'b0;
        in_pkt[57] = {`PACKET_WIDTH{1'b0}}; in_wr[57] = 1'b0;
        in_pkt[58] = {`PACKET_WIDTH{1'b0}}; in_wr[58] = 1'b0;
        in_pkt[59] = {`PACKET_WIDTH{1'b0}}; in_wr[59] = 1'b0;
        in_pkt[60] = {`PACKET_WIDTH{1'b0}}; in_wr[60] = 1'b0;
        in_pkt[61] = {`PACKET_WIDTH{1'b0}}; in_wr[61] = 1'b0;
        in_pkt[62] = {`PACKET_WIDTH{1'b0}}; in_wr[62] = 1'b0;
        in_pkt[63] = {`PACKET_WIDTH{1'b0}}; in_wr[63] = 1'b0;
    end
    endtask

    // ========================================================================
    // RESET SYSTEM
    // ========================================================================

    task reset_system;
    begin
        clear_inputs;

        rst = 1'b1;
        repeat(5) @(posedge clk);

        rst = 1'b0;
        repeat(3) @(posedge clk);
    end
    endtask

    // ========================================================================
    // INJECT ONE PACKET
    //
    // The source router for both sanity experiments is C0/R0 = flat index 0.
    // ========================================================================

    task inject_generated;
        input integer source_index;
    begin
        @(negedge clk);

        in_pkt[source_index] = gen_packet;
        in_wr[source_index]  = 1'b1;

        @(negedge clk);

        in_wr[source_index]  = 1'b0;
        in_pkt[source_index] = {PACKET_W{1'b0}};
    end
    endtask

    // ========================================================================
    // PRINT PHASE RESULT
    // ========================================================================

    task print_phase;
        input [8*32-1:0] phase_name;
        input integer expected_count;
        input integer expected_hops;
        input integer phase_start_injected;
        input integer phase_start_received;
        input integer phase_start_latency;
        input integer phase_start_hops;
        input integer phase_start_unmatched;
    begin

        phase_injected =
            packets_injected - phase_start_injected;

        phase_received =
            packets_received - phase_start_received;

        phase_latency =
            total_latency - phase_start_latency;

        phase_hops =
            total_hops - phase_start_hops;

        phase_unmatched =
            unmatched_receives - phase_start_unmatched;

        $display("");
        $display("------------------------------------------------------");
        $display("%0s", phase_name);
        $display("------------------------------------------------------");

        $display("Injected          : %0d", phase_injected);
        $display("Received          : %0d", phase_received);
        $display("Unmatched         : %0d", phase_unmatched);

        if (phase_received > 0)
        begin
            $display("Total latency     : %0d cycles",
                     phase_latency);

            $display("Average latency   : %0d.%0d cycles",
                     phase_latency / phase_received,
                     ((phase_latency % phase_received) * 10)
                     / phase_received);

            $display("Total hops        : %0d",
                     phase_hops);

            $display("Average hops      : %0d.%0d",
                     phase_hops / phase_received,
                     ((phase_hops % phase_received) * 10)
                     / phase_received);
        end
        else
        begin
            $display("Total latency     : N/A");
            $display("Average latency   : N/A");
            $display("Total hops        : N/A");
            $display("Average hops      : N/A");
        end

        $display("Min latency       : %0d cycles", min_latency);
        $display("Max latency       : %0d cycles", max_latency);
        $display("Min hops          : %0d", min_hops);
        $display("Max hops          : %0d", max_hops);

        if ((phase_injected == expected_count) &&
            (phase_received == expected_count) &&
            (phase_unmatched == 0) &&
            (phase_received > 0) &&
            (phase_hops == expected_count * expected_hops))
        begin
            $display("PHASE RESULT      : PASS");
        end
        else
        begin
            $display("PHASE RESULT      : FAIL");
        end
    end
    endtask

    // ========================================================================
    // WAIT FOR N RECEIVED PACKETS
    // ========================================================================

    task wait_for_received;
        input integer expected_total;
        input integer timeout_cycles;
        integer t;
    begin
        for (t = 0; t < timeout_cycles; t = t + 1)
        begin
            @(posedge clk);

            if (packets_received >= expected_total)
                t = timeout_cycles;
        end
    end
    endtask

    // ========================================================================
    // MAIN TEST
    // ========================================================================

    initial
    begin

        clk = 1'b0;
        rst = 1'b1;

        cumulative_injected  = 0;
        cumulative_received  = 0;
        cumulative_latency   = 0;
        cumulative_hops      = 0;
        cumulative_unmatched = 0;

        local_pass  = 0;
        global_pass = 0;

        clear_inputs;

        gen_src_cluster = 2'd0;
        gen_src_row     = 2'd0;
        gen_src_col     = 2'd0;

        gen_type     = 2'd0;
        gen_priority = 2'd0;
        gen_payload  = 32'd0;

        $display("");
        $display("======================================================");
        $display("       HYBRID NoC V2 METRICS SANITY TEST");
        $display("======================================================");
        $display("DUT            : 64 routers");
        $display("Topology       : 4 clusters x 4x4 Mesh");
        $display("Packet width   : %0d bits", PACKET_W);
        $display("Transaction ID : payload[31:0]");
        $display("");

        // ================================================================
        // PHASE A
        // C0/R0 -> C0/R3
        // Expected local Manhattan distance = 3
        // ================================================================

        $display("TEST A : 10 LOCAL PACKETS");
        $display("SOURCE      : C0/R0");
        $display("DESTINATION : C0/R3");
        $display("EXPECTED HOPS : 3");

        reset_system;

        start_injected = packets_injected;
        start_received = packets_received;
        start_latency  = total_latency;
        start_hops     = total_hops;
        start_unmatched = unmatched_receives;

        for (k = 0; k < 10; k = k + 1)
        begin
            gen_dst_cluster = 2'd0;
            gen_dst_row     = 2'd0;
            gen_dst_col     = 2'd3;

            gen_payload = 32'hA0000000 + k;

            #1;
            expected_packet = gen_packet;

            $display("INJECT LOCAL  : payload=%h packet=%h",
                     gen_payload, expected_packet);

            inject_generated(0);
        end

        wait_for_received(start_received + 10, 500);

        #2;

        print_phase(
            "PHASE A : LOCAL",
            10,
            3,
            start_injected,
            start_received,
            start_latency,
            start_hops,
            start_unmatched
        );

        phase_injected =
            packets_injected - start_injected;

        phase_received =
            packets_received - start_received;

        phase_latency =
            total_latency - start_latency;

        phase_hops =
            total_hops - start_hops;

        phase_unmatched =
            unmatched_receives - start_unmatched;

        if ((phase_injected == 10) &&
            (phase_received == 10) &&
            (phase_unmatched == 0) &&
            (phase_hops == 30))
            local_pass = 1;
        else
            local_pass = 0;

        // Save Phase A before resetting metric monitor for Phase B.
        cumulative_injected  = cumulative_injected + phase_injected;
        cumulative_received  = cumulative_received + phase_received;
        cumulative_latency   = cumulative_latency + phase_latency;
        cumulative_hops      = cumulative_hops + phase_hops;
        cumulative_unmatched = cumulative_unmatched + phase_unmatched;

        // ================================================================
        // PHASE B
        // C0/R0 -> C2/R3
        //
        // Current implemented global network:
        //   source gateway distance = 0
        //   global transfer        = 1
        //   destination local      = 3
        //   total                  = 4
        // ================================================================

        $display("");
        $display("TEST B : 10 INTER-CLUSTER PACKETS");
        $display("SOURCE      : C0/R0");
        $display("DESTINATION : C2/R3");
        $display("EXPECTED HOPS : 4");

        reset_system;

        start_injected = packets_injected;
        start_received = packets_received;
        start_latency  = total_latency;
        start_hops     = total_hops;
        start_unmatched = unmatched_receives;

        for (k = 0; k < 10; k = k + 1)
        begin
            gen_dst_cluster = 2'd2;
            gen_dst_row     = 2'd0;
            gen_dst_col     = 2'd3;

            gen_payload = 32'hB0000000 + k;

            #1;
            expected_packet = gen_packet;

            $display("INJECT GLOBAL : payload=%h packet=%h",
                     gen_payload, expected_packet);

            inject_generated(0);
        end

        wait_for_received(start_received + 10, 700);

        #2;

        print_phase(
            "PHASE B : INTER-CLUSTER",
            10,
            4,
            start_injected,
            start_received,
            start_latency,
            start_hops,
            start_unmatched
        );

        phase_injected =
            packets_injected - start_injected;

        phase_received =
            packets_received - start_received;

        phase_latency =
            total_latency - start_latency;

        phase_hops =
            total_hops - start_hops;

        phase_unmatched =
            unmatched_receives - start_unmatched;

        if ((phase_injected == 10) &&
            (phase_received == 10) &&
            (phase_unmatched == 0) &&
            (phase_hops == 40))
            global_pass = 1;
        else
            global_pass = 0;

        cumulative_injected  = cumulative_injected + phase_injected;
        cumulative_received  = cumulative_received + phase_received;
        cumulative_latency   = cumulative_latency + phase_latency;
        cumulative_hops      = cumulative_hops + phase_hops;
        cumulative_unmatched = cumulative_unmatched + phase_unmatched;

        // ================================================================
        // FINAL SUMMARY
        // ================================================================

        $display("");
        $display("======================================================");
        $display("              METRICS SANITY SUMMARY");
        $display("======================================================");

        $display("Cumulative injected   : %0d",
                 cumulative_injected);

        $display("Cumulative received   : %0d",
                 cumulative_received);

        $display("Cumulative unmatched  : %0d",
                 cumulative_unmatched);

        $display("Cumulative latency    : %0d cycles",
                 cumulative_latency);

        $display("Cumulative hop count  : %0d",
                 cumulative_hops);

        if (cumulative_received > 0)
        begin
            $display("Overall avg latency   : %0d.%0d cycles",
                     cumulative_latency / cumulative_received,
                     ((cumulative_latency % cumulative_received) * 10)
                     / cumulative_received);

            $display("Overall avg hops      : %0d.%0d",
                     cumulative_hops / cumulative_received,
                     ((cumulative_hops % cumulative_received) * 10)
                     / cumulative_received);
        end
        else
        begin
            $display("Overall avg latency   : N/A");
            $display("Overall avg hops      : N/A");
        end

        $display("");
        $display("LOCAL PHASE          : %s",
                 local_pass ? "PASS" : "FAIL");

        $display("INTER-CLUSTER PHASE  : %s",
                 global_pass ? "PASS" : "FAIL");

        if ((cumulative_injected == 20) &&
            (cumulative_received == 20) &&
            (cumulative_unmatched == 0) &&
            (cumulative_hops == 70) &&
            local_pass &&
            global_pass)
        begin
            $display("");
            $display("RESULT : METRICS SANITY PASS");
        end
        else
        begin
            $display("");
            $display("RESULT : METRICS SANITY FAIL");
        end

        $display("======================================================");

        #20;
        $finish;

    end

endmodule
