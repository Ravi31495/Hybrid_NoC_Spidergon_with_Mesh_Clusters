`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name : crossbar_switch_tb
// Description : Testbench for 6x6 Hybrid NoC crossbar switch.
//
// Port mapping:
//
//   0 = LOCAL
//   1 = NORTH
//   2 = SOUTH
//   3 = EAST
//   4 = WEST
//   5 = GATEWAY
//
// Valid select values = 0 through 5
// Invalid select values = 6 and 7
//////////////////////////////////////////////////////////////////////////////////

module crossbar_switch_tb;

    parameter PACKET_WIDTH = 48;

    //--------------------------------------------------
    // Inputs
    //--------------------------------------------------

    reg [PACKET_WIDTH-1:0] in0;
    reg [PACKET_WIDTH-1:0] in1;
    reg [PACKET_WIDTH-1:0] in2;
    reg [PACKET_WIDTH-1:0] in3;
    reg [PACKET_WIDTH-1:0] in4;
    reg [PACKET_WIDTH-1:0] in5;

    reg [2:0] sel0;
    reg [2:0] sel1;
    reg [2:0] sel2;
    reg [2:0] sel3;
    reg [2:0] sel4;
    reg [2:0] sel5;

    //--------------------------------------------------
    // Outputs
    //--------------------------------------------------

    wire [PACKET_WIDTH-1:0] out0;
    wire [PACKET_WIDTH-1:0] out1;
    wire [PACKET_WIDTH-1:0] out2;
    wire [PACKET_WIDTH-1:0] out3;
    wire [PACKET_WIDTH-1:0] out4;
    wire [PACKET_WIDTH-1:0] out5;

    integer errors;

    //--------------------------------------------------
    // DUT
    //--------------------------------------------------

    crossbar_switch
    #(
        .PACKET_WIDTH(PACKET_WIDTH)
    )
    DUT
    (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),

        .sel0(sel0),
        .sel1(sel1),
        .sel2(sel2),
        .sel3(sel3),
        .sel4(sel4),
        .sel5(sel5),

        .out0(out0),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4),
        .out5(out5)
    );

    //--------------------------------------------------
    // Check all outputs
    //--------------------------------------------------

    task check_outputs;

        input [PACKET_WIDTH-1:0] expected0;
        input [PACKET_WIDTH-1:0] expected1;
        input [PACKET_WIDTH-1:0] expected2;
        input [PACKET_WIDTH-1:0] expected3;
        input [PACKET_WIDTH-1:0] expected4;
        input [PACKET_WIDTH-1:0] expected5;

        input [8*80-1:0] test_name;

        begin

            #1;

            if ((out0 !== expected0) ||
                (out1 !== expected1) ||
                (out2 !== expected2) ||
                (out3 !== expected3) ||
                (out4 !== expected4) ||
                (out5 !== expected5))
            begin

                $display("FAIL: %0s", test_name);

                $display("  Expected:");
                $display("    OUT0 = %h", expected0);
                $display("    OUT1 = %h", expected1);
                $display("    OUT2 = %h", expected2);
                $display("    OUT3 = %h", expected3);
                $display("    OUT4 = %h", expected4);
                $display("    OUT5 = %h", expected5);

                $display("  Actual:");
                $display("    OUT0 = %h", out0);
                $display("    OUT1 = %h", out1);
                $display("    OUT2 = %h", out2);
                $display("    OUT3 = %h", out3);
                $display("    OUT4 = %h", out4);
                $display("    OUT5 = %h", out5);

                errors = errors + 1;
            end
            else
            begin
                $display("PASS: %0s", test_name);
            end

        end

    endtask


    //--------------------------------------------------
    // Test
    //--------------------------------------------------

    initial
    begin

        errors = 0;

        //--------------------------------------------------
        // Give each input a unique value
        //--------------------------------------------------

        in0 = 48'h000000000001;
        in1 = 48'h000000000002;
        in2 = 48'h000000000003;
        in3 = 48'h000000000004;
        in4 = 48'h000000000005;
        in5 = 48'h000000000006;

        //--------------------------------------------------
        // Initial selects
        //--------------------------------------------------

        sel0 = 3'd0;
        sel1 = 3'd1;
        sel2 = 3'd2;
        sel3 = 3'd3;
        sel4 = 3'd4;
        sel5 = 3'd5;

        $display("");
        $display("================================================");
        $display("          CROSSBAR SWITCH UNIT TEST");
        $display("================================================");
        $display("");


        //--------------------------------------------------
        // TEST 1 : STRAIGHT THROUGH
        //--------------------------------------------------

        sel0 = 3'd0;
        sel1 = 3'd1;
        sel2 = 3'd2;
        sel3 = 3'd3;
        sel4 = 3'd4;
        sel5 = 3'd5;

        check_outputs(
            in0,
            in1,
            in2,
            in3,
            in4,
            in5,
            "STRAIGHT THROUGH"
        );


        //--------------------------------------------------
        // TEST 2 : ALL OUTPUTS SELECT INPUT 0
        //--------------------------------------------------

        sel0 = 3'd0;
        sel1 = 3'd0;
        sel2 = 3'd0;
        sel3 = 3'd0;
        sel4 = 3'd0;
        sel5 = 3'd0;

        check_outputs(
            in0,
            in0,
            in0,
            in0,
            in0,
            in0,
            "ALL OUTPUTS INPUT 0"
        );


        //--------------------------------------------------
        // TEST 3 : REVERSE ORDER
        //--------------------------------------------------

        sel0 = 3'd5;
        sel1 = 3'd4;
        sel2 = 3'd3;
        sel3 = 3'd2;
        sel4 = 3'd1;
        sel5 = 3'd0;

        check_outputs(
            in5,
            in4,
            in3,
            in2,
            in1,
            in0,
            "REVERSE ORDER"
        );


        //--------------------------------------------------
        // TEST 4 : RANDOM PERMUTATION
        //--------------------------------------------------

        sel0 = 3'd2;
        sel1 = 3'd5;
        sel2 = 3'd0;
        sel3 = 3'd4;
        sel4 = 3'd1;
        sel5 = 3'd3;

        check_outputs(
            in2,
            in5,
            in0,
            in4,
            in1,
            in3,
            "RANDOM PERMUTATION"
        );


        //--------------------------------------------------
        // TEST 5 : OUTPUT 0 SELECT INPUT 0
        //--------------------------------------------------

        sel0 = 3'd0;
        sel1 = 3'd1;
        sel2 = 3'd2;
        sel3 = 3'd3;
        sel4 = 3'd4;
        sel5 = 3'd5;

        check_outputs(
            in0,
            in1,
            in2,
            in3,
            in4,
            in5,
            "OUTPUT 0 INPUT 0"
        );


        //--------------------------------------------------
        // TEST 6 : OUTPUT 0 SELECT INPUT 1
        //--------------------------------------------------

        sel0 = 3'd1;

        check_outputs(
            in1,
            in1,
            in2,
            in3,
            in4,
            in5,
            "OUTPUT 0 INPUT 1"
        );


        //--------------------------------------------------
        // TEST 7 : OUTPUT 0 SELECT INPUT 2
        //--------------------------------------------------

        sel0 = 3'd2;

        check_outputs(
            in2,
            in1,
            in2,
            in3,
            in4,
            in5,
            "OUTPUT 0 INPUT 2"
        );


        //--------------------------------------------------
        // TEST 8 : OUTPUT 0 SELECT INPUT 3
        //--------------------------------------------------

        sel0 = 3'd3;

        check_outputs(
            in3,
            in1,
            in2,
            in3,
            in4,
            in5,
            "OUTPUT 0 INPUT 3"
        );


        //--------------------------------------------------
        // TEST 9 : OUTPUT 0 SELECT INPUT 4
        //--------------------------------------------------

        sel0 = 3'd4;

        check_outputs(
            in4,
            in1,
            in2,
            in3,
            in4,
            in5,
            "OUTPUT 0 INPUT 4"
        );


        //--------------------------------------------------
        // TEST 10 : FULL PERMUTATION
        //
        // Every output selects a different input.
        //--------------------------------------------------

        sel0 = 3'd5;
        sel1 = 3'd0;
        sel2 = 3'd4;
        sel3 = 3'd1;
        sel4 = 3'd3;
        sel5 = 3'd2;

        check_outputs(
            in5,
            in0,
            in4,
            in1,
            in3,
            in2,
            "FULL PERMUTATION"
        );


        //--------------------------------------------------
        // TEST 11 : SELECT 5 IS VALID
        //
        // Select 5 corresponds to GATEWAY input.
        //--------------------------------------------------

        sel0 = 3'd5;
        sel1 = 3'd1;
        sel2 = 3'd2;
        sel3 = 3'd3;
        sel4 = 3'd4;
        sel5 = 3'd0;

        check_outputs(
            in5,
            in1,
            in2,
            in3,
            in4,
            in0,
            "VALID SELECT 5 GATEWAY"
        );


        //--------------------------------------------------
        // TEST 12 : INVALID SELECT 6
        //
        // Select 6 is outside the valid 0-5 range.
        // Output must be zero.
        //--------------------------------------------------

        sel0 = 3'd6;
        sel1 = 3'd1;
        sel2 = 3'd2;
        sel3 = 3'd3;
        sel4 = 3'd4;
        sel5 = 3'd5;

        check_outputs(
            {PACKET_WIDTH{1'b0}},
            in1,
            in2,
            in3,
            in4,
            in5,
            "INVALID SELECT 6"
        );


        //--------------------------------------------------
        // TEST 13 : INVALID SELECT 7
        //
        // Select 7 is outside the valid 0-5 range.
        // Output must be zero.
        //--------------------------------------------------

        sel0 = 3'd7;
        sel1 = 3'd1;
        sel2 = 3'd2;
        sel3 = 3'd3;
        sel4 = 3'd4;
        sel5 = 3'd5;

        check_outputs(
            {PACKET_WIDTH{1'b0}},
            in1,
            in2,
            in3,
            in4,
            in5,
            "INVALID SELECT 7"
        );


        //--------------------------------------------------
        // RESULT
        //--------------------------------------------------

        $display("");
        $display("================================================");

        if (errors == 0)
            $display("RESULT : ALL CROSSBAR SWITCH TESTS PASSED");
        else
            $display("RESULT : %0d CROSSBAR SWITCH TESTS FAILED", errors);

        $display("================================================");
        $display("");

        $finish;

    end

endmodule