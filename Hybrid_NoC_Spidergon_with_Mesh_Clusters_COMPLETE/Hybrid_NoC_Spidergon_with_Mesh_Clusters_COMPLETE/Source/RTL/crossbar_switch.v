`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name : crossbar_switch
// Description : 6x6 combinational crossbar
//
// Port numbering:
//   0 = LOCAL
//   1 = NORTH
//   2 = SOUTH
//   3 = EAST
//   4 = WEST
//   5 = GATEWAY
//////////////////////////////////////////////////////////////////////////////////

module crossbar_switch
#(
    parameter PACKET_WIDTH = 48
)
(
    //==================================================
    // INPUTS
    //==================================================

    input [PACKET_WIDTH-1:0] in0,
    input [PACKET_WIDTH-1:0] in1,
    input [PACKET_WIDTH-1:0] in2,
    input [PACKET_WIDTH-1:0] in3,
    input [PACKET_WIDTH-1:0] in4,
    input [PACKET_WIDTH-1:0] in5,

    //==================================================
    // SELECTS
    //==================================================

    input [2:0] sel0,
    input [2:0] sel1,
    input [2:0] sel2,
    input [2:0] sel3,
    input [2:0] sel4,
    input [2:0] sel5,

    //==================================================
    // OUTPUTS
    //==================================================

    output reg [PACKET_WIDTH-1:0] out0,
    output reg [PACKET_WIDTH-1:0] out1,
    output reg [PACKET_WIDTH-1:0] out2,
    output reg [PACKET_WIDTH-1:0] out3,
    output reg [PACKET_WIDTH-1:0] out4,
    output reg [PACKET_WIDTH-1:0] out5
);

always @(*)
begin

    //==================================================
    // OUTPUT 0
    //==================================================

    case(sel0)
        3'd0: out0 = in0;
        3'd1: out0 = in1;
        3'd2: out0 = in2;
        3'd3: out0 = in3;
        3'd4: out0 = in4;
        3'd5: out0 = in5;
        default: out0 = {PACKET_WIDTH{1'b0}};
    endcase

    //==================================================
    // OUTPUT 1
    //==================================================

    case(sel1)
        3'd0: out1 = in0;
        3'd1: out1 = in1;
        3'd2: out1 = in2;
        3'd3: out1 = in3;
        3'd4: out1 = in4;
        3'd5: out1 = in5;
        default: out1 = {PACKET_WIDTH{1'b0}};
    endcase

    //==================================================
    // OUTPUT 2
    //==================================================

    case(sel2)
        3'd0: out2 = in0;
        3'd1: out2 = in1;
        3'd2: out2 = in2;
        3'd3: out2 = in3;
        3'd4: out2 = in4;
        3'd5: out2 = in5;
        default: out2 = {PACKET_WIDTH{1'b0}};
    endcase

    //==================================================
    // OUTPUT 3
    //==================================================

    case(sel3)
        3'd0: out3 = in0;
        3'd1: out3 = in1;
        3'd2: out3 = in2;
        3'd3: out3 = in3;
        3'd4: out3 = in4;
        3'd5: out3 = in5;
        default: out3 = {PACKET_WIDTH{1'b0}};
    endcase

    //==================================================
    // OUTPUT 4
    //==================================================

    case(sel4)
        3'd0: out4 = in0;
        3'd1: out4 = in1;
        3'd2: out4 = in2;
        3'd3: out4 = in3;
        3'd4: out4 = in4;
        3'd5: out4 = in5;
        default: out4 = {PACKET_WIDTH{1'b0}};
    endcase

    //==================================================
    // OUTPUT 5
    //==================================================

    case(sel5)
        3'd0: out5 = in0;
        3'd1: out5 = in1;
        3'd2: out5 = in2;
        3'd3: out5 = in3;
        3'd4: out5 = in4;
        3'd5: out5 = in5;
        default: out5 = {PACKET_WIDTH{1'b0}};
    endcase

end

endmodule