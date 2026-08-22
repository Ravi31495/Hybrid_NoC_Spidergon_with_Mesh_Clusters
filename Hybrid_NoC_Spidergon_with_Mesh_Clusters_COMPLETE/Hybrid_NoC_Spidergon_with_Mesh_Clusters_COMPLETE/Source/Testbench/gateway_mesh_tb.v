`timescale 1ns/1ps
`include "noc_defines.vh"

module gateway_mesh_tb;

    reg clk;
    reg rst;

    reg [`PACKET_WIDTH-1:0] local_packet_in0;
    reg [`PACKET_WIDTH-1:0] local_packet_in1;
    reg [`PACKET_WIDTH-1:0] local_packet_in2;
    reg [`PACKET_WIDTH-1:0] local_packet_in3;

    reg local_write0;
    reg local_write1;
    reg local_write2;
    reg local_write3;

    wire [`PACKET_WIDTH-1:0] local_packet_out0;
    wire [`PACKET_WIDTH-1:0] local_packet_out1;
    wire [`PACKET_WIDTH-1:0] local_packet_out2;
    wire [`PACKET_WIDTH-1:0] local_packet_out3;

    wire local_valid0;
    wire local_valid1;
    wire local_valid2;
    wire local_valid3;

    reg [`PACKET_WIDTH-1:0] gateway_packet_in;
    reg gateway_write;
    reg gateway_busy;

    wire [`PACKET_WIDTH-1:0] gateway_packet_out;
    wire gateway_valid;
    wire gateway_full;

    integer tests_run;
    integer tests_passed;
    integer tests_failed;

    reg [`PACKET_WIDTH-1:0] expected_packet;

    integer i;
    reg found;


    // =========================================================
    // CLOCK
    // =========================================================

    always #5 clk = ~clk;


    // =========================================================
    // DUT
    // =========================================================

    mesh_2x2 DUT
    (
        .clk(clk),
        .rst(rst),

        .local_packet_in0(local_packet_in0),
        .local_packet_in1(local_packet_in1),
        .local_packet_in2(local_packet_in2),
        .local_packet_in3(local_packet_in3),

        .local_write0(local_write0),
        .local_write1(local_write1),
        .local_write2(local_write2),
        .local_write3(local_write3),

        .local_packet_out0(local_packet_out0),
        .local_packet_out1(local_packet_out1),
        .local_packet_out2(local_packet_out2),
        .local_packet_out3(local_packet_out3),

        .local_valid0(local_valid0),
        .local_valid1(local_valid1),
        .local_valid2(local_valid2),
        .local_valid3(local_valid3),

        .gateway_packet_in(gateway_packet_in),
        .gateway_write(gateway_write),
        .gateway_busy(gateway_busy),

        .gateway_packet_out(gateway_packet_out),
        .gateway_valid(gateway_valid),
        .gateway_full(gateway_full)
    );


    // =========================================================
    // PACKET BUILDER
    // =========================================================

    function [`PACKET_WIDTH-1:0] make_packet;

        input [1:0] dst_cluster;
        input [1:0] dst_row;
        input [1:0] dst_col;

        input [1:0] src_cluster;
        input [1:0] src_row;
        input [1:0] src_col;

        input [1:0] ptype;
        input [1:0] priority;

        input [31:0] payload;

        begin

            make_packet =
            {
                dst_cluster,
                dst_row,
                dst_col,

                src_cluster,
                src_row,
                src_col,

                ptype,
                priority,

                payload
            };

        end

    endfunction


    // =========================================================
    // CLEAR INPUTS
    // =========================================================

    task clear_inputs;

        begin

            local_packet_in0 = 0;
            local_packet_in1 = 0;
            local_packet_in2 = 0;
            local_packet_in3 = 0;

            local_write0 = 0;
            local_write1 = 0;
            local_write2 = 0;
            local_write3 = 0;

            gateway_packet_in = 0;
            gateway_write = 0;
            gateway_busy = 0;

        end

    endtask


    // =========================================================
    // LOCAL R0 INJECTION
    // =========================================================

    task inject_r0;

        input [`PACKET_WIDTH-1:0] pkt;

        begin

            @(negedge clk);

            local_packet_in0 = pkt;
            local_write0 = 1'b1;

            @(negedge clk);

            local_write0 = 1'b0;
            local_packet_in0 = 0;

        end

    endtask


    // =========================================================
    // GATEWAY INJECTION
    // =========================================================

    task inject_gateway;

        input [`PACKET_WIDTH-1:0] pkt;

        begin

            @(negedge clk);

            gateway_packet_in = pkt;
            gateway_write = 1'b1;

            @(negedge clk);

            gateway_write = 1'b0;
            gateway_packet_in = 0;

        end

    endtask


    // =========================================================
    // TEST R0 -> GATEWAY
    // =========================================================

    task test_r0_to_gateway;

        input [`PACKET_WIDTH-1:0] pkt;

        begin

            found = 0;

            for (i = 0; i < 50; i = i + 1)
            begin

                @(posedge clk);

                if (
                    gateway_valid &&
                    gateway_packet_out == pkt
                )
                begin
                    found = 1;
                    i = 50;
                end

            end

            tests_run = tests_run + 1;

            if (found)
            begin

                tests_passed = tests_passed + 1;

                $display(
                    "PASS : R0 -> GATEWAY | %h",
                    pkt
                );

            end
            else
            begin

                tests_failed = tests_failed + 1;

                $display(
                    "FAIL : R0 -> GATEWAY"
                );

                $display(
                    "Expected : %h",
                    pkt
                );

                $display(
                    "Actual   : %h",
                    gateway_packet_out
                );

                $display(
                    "Valid    : %b",
                    gateway_valid
                );

            end

        end

    endtask


    // =========================================================
    // TEST GATEWAY -> R0
    // =========================================================

    task test_gateway_to_r0;

        input [`PACKET_WIDTH-1:0] pkt;

        begin

            found = 0;

            for (i = 0; i < 50; i = i + 1)
            begin

                @(posedge clk);

                if (
                    local_valid0 &&
                    local_packet_out0 == pkt
                )
                begin
                    found = 1;
                    i = 50;
                end

            end

            tests_run = tests_run + 1;

            if (found)
            begin

                tests_passed = tests_passed + 1;

                $display(
                    "PASS : GATEWAY -> R0 | %h",
                    pkt
                );

            end
            else
            begin

                tests_failed = tests_failed + 1;

                $display(
                    "FAIL : GATEWAY -> R0"
                );

                $display(
                    "Expected : %h",
                    pkt
                );

                $display(
                    "Actual   : %h",
                    local_packet_out0
                );

                $display(
                    "Valid    : %b",
                    local_valid0
                );

            end

        end

    endtask


    // =========================================================
    // MAIN
    // =========================================================

    initial
    begin

        clk = 0;
        rst = 1;

        tests_run = 0;
        tests_passed = 0;
        tests_failed = 0;

        clear_inputs();


        $display("");
        $display("================================================");
        $display("       GATEWAY PORT TEST");
        $display("================================================");


        repeat (5)
            @(posedge clk);

        rst = 0;

        repeat (2)
            @(posedge clk);


        // =====================================================
        // TEST 1
        // R0 -> GATEWAY
        // =====================================================

        $display("");
        $display("TEST 1 : R0 -> GATEWAY");

        expected_packet =
            make_packet(
                2'd1,
                2'd0,
                2'd0,

                2'd0,
                2'd0,
                2'd0,

                2'd0,
                2'd0,

                32'hAAAA_AAAA
            );

        inject_r0(expected_packet);

        test_r0_to_gateway(expected_packet);


        // =====================================================
        // TEST 2
        // GATEWAY -> R0
        // =====================================================

        $display("");
        $display("TEST 2 : GATEWAY -> R0");

        expected_packet =
            make_packet(
                2'd0,
                2'd0,
                2'd0,

                2'd1,
                2'd0,
                2'd0,

                2'd0,
                2'd0,

                32'hBBBB_BBBB
            );

        inject_gateway(expected_packet);

        test_gateway_to_r0(expected_packet);


        // =====================================================
        // SUMMARY
        // =====================================================

        $display("");
        $display("================================================");
        $display("          GATEWAY PORT SUMMARY");
        $display("================================================");

        $display("Tests Run    : %0d", tests_run);
        $display("Tests Passed : %0d", tests_passed);
        $display("Tests Failed : %0d", tests_failed);

        if (tests_failed == 0)
            $display("RESULT       : ALL GATEWAY TESTS PASSED");
        else
            $display("RESULT       : GATEWAY TESTS FAILED");

        $display("================================================");

        #50;

        $finish;

    end

endmodule