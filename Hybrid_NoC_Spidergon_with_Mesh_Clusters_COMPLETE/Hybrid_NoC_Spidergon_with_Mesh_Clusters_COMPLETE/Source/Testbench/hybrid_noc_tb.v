`timescale 1ns/1ps
`include "noc_defines.vh"

module hybrid_noc_tb;

    reg clk;
    reg rst;

    // =========================================================
    // INPUTS : 4 clusters × 4 local routers
    // =========================================================

    reg [`PACKET_WIDTH-1:0] c0_in0, c0_in1, c0_in2, c0_in3;
    reg [`PACKET_WIDTH-1:0] c1_in0, c1_in1, c1_in2, c1_in3;
    reg [`PACKET_WIDTH-1:0] c2_in0, c2_in1, c2_in2, c2_in3;
    reg [`PACKET_WIDTH-1:0] c3_in0, c3_in1, c3_in2, c3_in3;

    reg c0_w0, c0_w1, c0_w2, c0_w3;
    reg c1_w0, c1_w1, c1_w2, c1_w3;
    reg c2_w0, c2_w1, c2_w2, c2_w3;
    reg c3_w0, c3_w1, c3_w2, c3_w3;

    // =========================================================
    // OUTPUTS
    // =========================================================

    wire [`PACKET_WIDTH-1:0] c0_out0, c0_out1, c0_out2, c0_out3;
    wire [`PACKET_WIDTH-1:0] c1_out0, c1_out1, c1_out2, c1_out3;
    wire [`PACKET_WIDTH-1:0] c2_out0, c2_out1, c2_out2, c2_out3;
    wire [`PACKET_WIDTH-1:0] c3_out0, c3_out1, c3_out2, c3_out3;

    wire c0_v0, c0_v1, c0_v2, c0_v3;
    wire c1_v0, c1_v1, c1_v2, c1_v3;
    wire c2_v0, c2_v1, c2_v2, c2_v3;
    wire c3_v0, c3_v1, c3_v2, c3_v3;

    // =========================================================
    // TEST COUNTERS
    // =========================================================

    integer tests_run;
    integer tests_passed;
    integer tests_failed;

    integer src_cluster;
    integer src_port;
    integer dst_cluster;
    integer dst_port;

    integer src_row;
    integer src_col;

    integer dst_row;
    integer dst_col;

    integer i;

    reg [`PACKET_WIDTH-1:0] test_packet;
    reg [`PACKET_WIDTH-1:0] expected_packet;

    // =========================================================
    // CLOCK
    // =========================================================

    always #5 clk = ~clk;

    // =========================================================
    // DUT
    // =========================================================

    hybrid_noc DUT
    (
        .clk(clk),
        .rst(rst),

        // -----------------------------------------------------
        // C0 INPUTS
        // -----------------------------------------------------

        .c0_local_packet_in0(c0_in0),
        .c0_local_packet_in1(c0_in1),
        .c0_local_packet_in2(c0_in2),
        .c0_local_packet_in3(c0_in3),

        .c0_local_write0(c0_w0),
        .c0_local_write1(c0_w1),
        .c0_local_write2(c0_w2),
        .c0_local_write3(c0_w3),

        // -----------------------------------------------------
        // C1 INPUTS
        // -----------------------------------------------------

        .c1_local_packet_in0(c1_in0),
        .c1_local_packet_in1(c1_in1),
        .c1_local_packet_in2(c1_in2),
        .c1_local_packet_in3(c1_in3),

        .c1_local_write0(c1_w0),
        .c1_local_write1(c1_w1),
        .c1_local_write2(c1_w2),
        .c1_local_write3(c1_w3),

        // -----------------------------------------------------
        // C2 INPUTS
        // -----------------------------------------------------

        .c2_local_packet_in0(c2_in0),
        .c2_local_packet_in1(c2_in1),
        .c2_local_packet_in2(c2_in2),
        .c2_local_packet_in3(c2_in3),

        .c2_local_write0(c2_w0),
        .c2_local_write1(c2_w1),
        .c2_local_write2(c2_w2),
        .c2_local_write3(c2_w3),

        // -----------------------------------------------------
        // C3 INPUTS
        // -----------------------------------------------------

        .c3_local_packet_in0(c3_in0),
        .c3_local_packet_in1(c3_in1),
        .c3_local_packet_in2(c3_in2),
        .c3_local_packet_in3(c3_in3),

        .c3_local_write0(c3_w0),
        .c3_local_write1(c3_w1),
        .c3_local_write2(c3_w2),
        .c3_local_write3(c3_w3),

        // -----------------------------------------------------
        // C0 OUTPUTS
        // -----------------------------------------------------

        .c0_local_packet_out0(c0_out0),
        .c0_local_packet_out1(c0_out1),
        .c0_local_packet_out2(c0_out2),
        .c0_local_packet_out3(c0_out3),

        .c0_local_valid0(c0_v0),
        .c0_local_valid1(c0_v1),
        .c0_local_valid2(c0_v2),
        .c0_local_valid3(c0_v3),

        // -----------------------------------------------------
        // C1 OUTPUTS
        // -----------------------------------------------------

        .c1_local_packet_out0(c1_out0),
        .c1_local_packet_out1(c1_out1),
        .c1_local_packet_out2(c1_out2),
        .c1_local_packet_out3(c1_out3),

        .c1_local_valid0(c1_v0),
        .c1_local_valid1(c1_v1),
        .c1_local_valid2(c1_v2),
        .c1_local_valid3(c1_v3),

        // -----------------------------------------------------
        // C2 OUTPUTS
        // -----------------------------------------------------

        .c2_local_packet_out0(c2_out0),
        .c2_local_packet_out1(c2_out1),
        .c2_local_packet_out2(c2_out2),
        .c2_local_packet_out3(c2_out3),

        .c2_local_valid0(c2_v0),
        .c2_local_valid1(c2_v1),
        .c2_local_valid2(c2_v2),
        .c2_local_valid3(c2_v3),

        // -----------------------------------------------------
        // C3 OUTPUTS
        // -----------------------------------------------------

        .c3_local_packet_out0(c3_out0),
        .c3_local_packet_out1(c3_out1),
        .c3_local_packet_out2(c3_out2),
        .c3_local_packet_out3(c3_out3),

        .c3_local_valid0(c3_v0),
        .c3_local_valid1(c3_v1),
        .c3_local_valid2(c3_v2),
        .c3_local_valid3(c3_v3)
    );


    // =========================================================
    // CLEAR ALL INPUTS
    // =========================================================

    task clear_inputs;
    begin

        c0_in0 = 0;
        c0_in1 = 0;
        c0_in2 = 0;
        c0_in3 = 0;

        c1_in0 = 0;
        c1_in1 = 0;
        c1_in2 = 0;
        c1_in3 = 0;

        c2_in0 = 0;
        c2_in1 = 0;
        c2_in2 = 0;
        c2_in3 = 0;

        c3_in0 = 0;
        c3_in1 = 0;
        c3_in2 = 0;
        c3_in3 = 0;

        c0_w0 = 0;
        c0_w1 = 0;
        c0_w2 = 0;
        c0_w3 = 0;

        c1_w0 = 0;
        c1_w1 = 0;
        c1_w2 = 0;
        c1_w3 = 0;

        c2_w0 = 0;
        c2_w1 = 0;
        c2_w2 = 0;
        c2_w3 = 0;

        c3_w0 = 0;
        c3_w1 = 0;
        c3_w2 = 0;
        c3_w3 = 0;

    end
    endtask


    // =========================================================
    // RESET DUT
    // =========================================================

    task reset_dut;
    begin

        clear_inputs;

        rst = 1;

        repeat(3)
            @(posedge clk);

        rst = 0;

        repeat(2)
            @(posedge clk);

    end
    endtask


    // =========================================================
    // GET ROUTER COORDINATES
    //
    // Port 0 = R0 = (0,0)
    // Port 1 = R1 = (0,1)
    // Port 2 = R2 = (1,0)
    // Port 3 = R3 = (1,1)
    // =========================================================

    task get_coordinates;
        input integer port;
        output integer row;
        output integer col;

        begin

            case(port)

                0:
                begin
                    row = 0;
                    col = 0;
                end

                1:
                begin
                    row = 0;
                    col = 1;
                end

                2:
                begin
                    row = 1;
                    col = 0;
                end

                3:
                begin
                    row = 1;
                    col = 1;
                end

                default:
                begin
                    row = 0;
                    col = 0;
                end

            endcase

        end
    endtask


    // =========================================================
    // INJECT PACKET
    // =========================================================

    task inject_packet;
        input integer cluster;
        input integer port;
        input [`PACKET_WIDTH-1:0] packet;

        begin

            case(cluster)

                0:
                begin
                    case(port)
                        0: begin c0_in0 = packet; c0_w0 = 1; end
                        1: begin c0_in1 = packet; c0_w1 = 1; end
                        2: begin c0_in2 = packet; c0_w2 = 1; end
                        3: begin c0_in3 = packet; c0_w3 = 1; end
                    endcase
                end

                1:
                begin
                    case(port)
                        0: begin c1_in0 = packet; c1_w0 = 1; end
                        1: begin c1_in1 = packet; c1_w1 = 1; end
                        2: begin c1_in2 = packet; c1_w2 = 1; end
                        3: begin c1_in3 = packet; c1_w3 = 1; end
                    endcase
                end

                2:
                begin
                    case(port)
                        0: begin c2_in0 = packet; c2_w0 = 1; end
                        1: begin c2_in1 = packet; c2_w1 = 1; end
                        2: begin c2_in2 = packet; c2_w2 = 1; end
                        3: begin c2_in3 = packet; c2_w3 = 1; end
                    endcase
                end

                3:
                begin
                    case(port)
                        0: begin c3_in0 = packet; c3_w0 = 1; end
                        1: begin c3_in1 = packet; c3_w1 = 1; end
                        2: begin c3_in2 = packet; c3_w2 = 1; end
                        3: begin c3_in3 = packet; c3_w3 = 1; end
                    endcase
                end

            endcase

            @(negedge clk);

            clear_inputs;

        end
    endtask


    // =========================================================
    // CHECK DESTINATION
    // =========================================================

    task check_destination;
        input integer cluster;
        input integer port;
        input [`PACKET_WIDTH-1:0] expected;

        reg valid;
        reg [`PACKET_WIDTH-1:0] received;

        begin

            valid = 0;
            received = 0;

            case(cluster)

                0:
                begin
                    case(port)
                        0: begin valid = c0_v0; received = c0_out0; end
                        1: begin valid = c0_v1; received = c0_out1; end
                        2: begin valid = c0_v2; received = c0_out2; end
                        3: begin valid = c0_v3; received = c0_out3; end
                    endcase
                end

                1:
                begin
                    case(port)
                        0: begin valid = c1_v0; received = c1_out0; end
                        1: begin valid = c1_v1; received = c1_out1; end
                        2: begin valid = c1_v2; received = c1_out2; end
                        3: begin valid = c1_v3; received = c1_out3; end
                    endcase
                end

                2:
                begin
                    case(port)
                        0: begin valid = c2_v0; received = c2_out0; end
                        1: begin valid = c2_v1; received = c2_out1; end
                        2: begin valid = c2_v2; received = c2_out2; end
                        3: begin valid = c2_v3; received = c2_out3; end
                    endcase
                end

                3:
                begin
                    case(port)
                        0: begin valid = c3_v0; received = c3_out0; end
                        1: begin valid = c3_v1; received = c3_out1; end
                        2: begin valid = c3_v2; received = c3_out2; end
                        3: begin valid = c3_v3; received = c3_out3; end
                    endcase
                end

            endcase


            i = 0;

            while ((i < 120) && !valid)
            begin
                @(posedge clk);

                case(cluster)

                    0:
                    begin
                        case(port)
                            0: begin valid = c0_v0; received = c0_out0; end
                            1: begin valid = c0_v1; received = c0_out1; end
                            2: begin valid = c0_v2; received = c0_out2; end
                            3: begin valid = c0_v3; received = c0_out3; end
                        endcase
                    end

                    1:
                    begin
                        case(port)
                            0: begin valid = c1_v0; received = c1_out0; end
                            1: begin valid = c1_v1; received = c1_out1; end
                            2: begin valid = c1_v2; received = c1_out2; end
                            3: begin valid = c1_v3; received = c1_out3; end
                        endcase
                    end

                    2:
                    begin
                        case(port)
                            0: begin valid = c2_v0; received = c2_out0; end
                            1: begin valid = c2_v1; received = c2_out1; end
                            2: begin valid = c2_v2; received = c2_out2; end
                            3: begin valid = c2_v3; received = c2_out3; end
                        endcase
                    end

                    3:
                    begin
                        case(port)
                            0: begin valid = c3_v0; received = c3_out0; end
                            1: begin valid = c3_v1; received = c3_out1; end
                            2: begin valid = c3_v2; received = c3_out2; end
                            3: begin valid = c3_v3; received = c3_out3; end
                        endcase
                    end

                endcase

                i = i + 1;

            end


            tests_run = tests_run + 1;


            if (valid && received == expected)
            begin

                tests_passed = tests_passed + 1;

            end
            else
            begin

                tests_failed = tests_failed + 1;

                $display("");
                $display("FAIL");
                $display(
                    "SOURCE C%0d/R%0d -> DEST C%0d/R%0d",
                    src_cluster,
                    src_port,
                    cluster,
                    port
                );

                $display(
                    "Expected = %h",
                    expected
                );

                $display(
                    "Received = %h",
                    received
                );

                $display(
                    "Valid    = %b",
                    valid
                );

            end

        end
    endtask


    // =========================================================
    // SINGLE PACKET TEST
    // =========================================================

    task run_single_test;

        input integer s_cluster;
        input integer s_port;

        input integer d_cluster;
        input integer d_port;

        reg [`PACKET_WIDTH-1:0] packet;

        begin

            get_coordinates(
                s_port,
                src_row,
                src_col
            );

            get_coordinates(
                d_port,
                dst_row,
                dst_col
            );

            packet =
            {
                d_cluster[1:0],
                dst_row[1:0],
                dst_col[1:0],

                s_cluster[1:0],
                src_row[1:0],
                src_col[1:0],

                2'd0,
                2'd0,

                32'h1000_0000 |
                (s_cluster << 20) |
                (s_port    << 16) |
                (d_cluster << 12) |
                (d_port    << 8)
            };

            reset_dut;

            inject_packet(
                s_cluster,
                s_port,
                packet
            );

            check_destination(
                d_cluster,
                d_port,
                packet
            );

        end

    endtask


    // =========================================================
    // MAIN TEST
    // =========================================================

    initial
    begin

        clk = 0;
        rst = 1;

        tests_run = 0;
        tests_passed = 0;
        tests_failed = 0;

        clear_inputs;


        $display("");
        $display("======================================================");
        $display("       COMPREHENSIVE HYBRID NoC TEST");
        $display("======================================================");
        $display("");
        $display("Testing all 16 routers as sources");
        $display("Testing all 16 routers as destinations");
        $display("Total combinations = 256");
        $display("");


        // =====================================================
        // EXHAUSTIVE 16 × 16 TEST
        // =====================================================

        for (src_cluster = 0;
             src_cluster < 4;
             src_cluster = src_cluster + 1)
        begin

            for (src_port = 0;
                 src_port < 4;
                 src_port = src_port + 1)
            begin

                for (dst_cluster = 0;
                     dst_cluster < 4;
                     dst_cluster = dst_cluster + 1)
                begin

                    for (dst_port = 0;
                         dst_port < 4;
                         dst_port = dst_port + 1)
                    begin

                        run_single_test(
                            src_cluster,
                            src_port,
                            dst_cluster,
                            dst_port
                        );

                    end

                end

            end

            $display(
                "Completed source cluster C%0d",
                src_cluster
            );

        end


        // =====================================================
        // FINAL SUMMARY
        // =====================================================

        $display("");
        $display("======================================================");
        $display("             HYBRID NoC FINAL SUMMARY");
        $display("======================================================");

        $display(
            "Tests Run    : %0d",
            tests_run
        );

        $display(
            "Tests Passed : %0d",
            tests_passed
        );

        $display(
            "Tests Failed : %0d",
            tests_failed
        );

        $display("");

        if (tests_failed == 0)
        begin

            $display(
                "RESULT : ALL HYBRID NoC TESTS PASSED"
            );

        end
        else
        begin

            $display(
                "RESULT : HYBRID NoC VERIFICATION FAILED"
            );

        end

        $display("======================================================");

        #50;

        $finish;

    end

endmodule