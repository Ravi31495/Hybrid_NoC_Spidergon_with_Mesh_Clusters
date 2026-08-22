`timescale 1ns/1ps
`include "noc_defines.vh"

module global_network_4cluster_tb;

    reg clk;
    reg rst;

    // =========================================================
    // CLUSTER INTERFACES
    // =========================================================

    reg [`PACKET_WIDTH-1:0] c0_packet_in;
    reg c0_valid_in;
    wire c0_ready_out;
    wire [`PACKET_WIDTH-1:0] c0_packet_out;
    wire c0_valid_out;
    reg c0_ready_in;
    reg [2:0] c0_route_direction;

    reg [`PACKET_WIDTH-1:0] c1_packet_in;
    reg c1_valid_in;
    wire c1_ready_out;
    wire [`PACKET_WIDTH-1:0] c1_packet_out;
    wire c1_valid_out;
    reg c1_ready_in;
    reg [2:0] c1_route_direction;

    reg [`PACKET_WIDTH-1:0] c2_packet_in;
    reg c2_valid_in;
    wire c2_ready_out;
    wire [`PACKET_WIDTH-1:0] c2_packet_out;
    wire c2_valid_out;
    reg c2_ready_in;
    reg [2:0] c2_route_direction;

    reg [`PACKET_WIDTH-1:0] c3_packet_in;
    reg c3_valid_in;
    wire c3_ready_out;
    wire [`PACKET_WIDTH-1:0] c3_packet_out;
    wire c3_valid_out;
    reg c3_ready_in;
    reg [2:0] c3_route_direction;

    integer tests_run;
    integer tests_passed;
    integer tests_failed;

    // =========================================================
    // CLOCK
    // =========================================================

    always #5 clk = ~clk;

    // =========================================================
    // DUT
    // =========================================================

    global_network_4cluster DUT
    (
        .clk(clk),
        .rst(rst),

        .c0_packet_in(c0_packet_in),
        .c0_valid_in(c0_valid_in),
        .c0_ready_out(c0_ready_out),
        .c0_packet_out(c0_packet_out),
        .c0_valid_out(c0_valid_out),
        .c0_ready_in(c0_ready_in),
        .c0_route_direction(c0_route_direction),

        .c1_packet_in(c1_packet_in),
        .c1_valid_in(c1_valid_in),
        .c1_ready_out(c1_ready_out),
        .c1_packet_out(c1_packet_out),
        .c1_valid_out(c1_valid_out),
        .c1_ready_in(c1_ready_in),
        .c1_route_direction(c1_route_direction),

        .c2_packet_in(c2_packet_in),
        .c2_valid_in(c2_valid_in),
        .c2_ready_out(c2_ready_out),
        .c2_packet_out(c2_packet_out),
        .c2_valid_out(c2_valid_out),
        .c2_ready_in(c2_ready_in),
        .c2_route_direction(c2_route_direction),

        .c3_packet_in(c3_packet_in),
        .c3_valid_in(c3_valid_in),
        .c3_ready_out(c3_ready_out),
        .c3_packet_out(c3_packet_out),
        .c3_valid_out(c3_valid_out),
        .c3_ready_in(c3_ready_in),
        .c3_route_direction(c3_route_direction)
    );


    // =========================================================
    // RESET / DEFAULTS
    // =========================================================

    task clear_inputs;
    begin
        c0_packet_in = 0;
        c1_packet_in = 0;
        c2_packet_in = 0;
        c3_packet_in = 0;

        c0_valid_in = 0;
        c1_valid_in = 0;
        c2_valid_in = 0;
        c3_valid_in = 0;

        c0_ready_in = 1;
        c1_ready_in = 1;
        c2_ready_in = 1;
        c3_ready_in = 1;

        c0_route_direction = `LOCAL;
        c1_route_direction = `LOCAL;
        c2_route_direction = `LOCAL;
        c3_route_direction = `LOCAL;
    end
    endtask


    // =========================================================
    // GENERIC DIRECTED TEST
    // =========================================================

    task test_c0_to_c1;
    begin
        $display("TEST : C0 -> C1");

        c0_route_direction = `EAST;
        c0_packet_in = 48'h0000_0000_0001;
        c0_valid_in = 1;

        #1;

        tests_run = tests_run + 1;

        if (
            c1_valid_out &&
            c1_packet_out == 48'h0000_0000_0001
        )
        begin
            tests_passed = tests_passed + 1;
            $display("PASS : C0 -> C1");
        end
        else
        begin
            tests_failed = tests_failed + 1;
            $display("FAIL : C0 -> C1");
        end

        c0_valid_in = 0;
    end
    endtask


    task test_c0_to_c2;
    begin
        $display("TEST : C0 -> C2");

        c0_route_direction = `SOUTH;
        c0_packet_in = 48'h0000_0000_0002;
        c0_valid_in = 1;

        #1;

        tests_run = tests_run + 1;

        if (
            c2_valid_out &&
            c2_packet_out == 48'h0000_0000_0002
        )
        begin
            tests_passed = tests_passed + 1;
            $display("PASS : C0 -> C2");
        end
        else
        begin
            tests_failed = tests_failed + 1;
            $display("FAIL : C0 -> C2");
        end

        c0_valid_in = 0;
    end
    endtask


    task test_c0_to_c3;
    begin
        $display("TEST : C0 -> C3");

        c0_route_direction = `WEST;
        c0_packet_in = 48'h0000_0000_0003;
        c0_valid_in = 1;

        #1;

        tests_run = tests_run + 1;

        if (
            c3_valid_out &&
            c3_packet_out == 48'h0000_0000_0003
        )
        begin
            tests_passed = tests_passed + 1;
            $display("PASS : C0 -> C3");
        end
        else
        begin
            tests_failed = tests_failed + 1;
            $display("FAIL : C0 -> C3");
        end

        c0_valid_in = 0;
    end
    endtask


    task test_c1_to_c0;
    begin
        $display("TEST : C1 -> C0");

        c1_route_direction = `NORTH;
        c1_packet_in = 48'h0000_0000_0010;
        c1_valid_in = 1;

        #1;

        tests_run = tests_run + 1;

        if (
            c0_valid_out &&
            c0_packet_out == 48'h0000_0000_0010
        )
        begin
            tests_passed = tests_passed + 1;
            $display("PASS : C1 -> C0");
        end
        else
        begin
            tests_failed = tests_failed + 1;
            $display("FAIL : C1 -> C0");
        end

        c1_valid_in = 0;
    end
    endtask


    task test_c1_to_c2;
    begin
        $display("TEST : C1 -> C2");

        c1_route_direction = `SOUTH;
        c1_packet_in = 48'h0000_0000_0011;
        c1_valid_in = 1;

        #1;

        tests_run = tests_run + 1;

        if (
            c2_valid_out &&
            c2_packet_out == 48'h0000_0000_0011
        )
        begin
            tests_passed = tests_passed + 1;
            $display("PASS : C1 -> C2");
        end
        else
        begin
            tests_failed = tests_failed + 1;
            $display("FAIL : C1 -> C2");
        end

        c1_valid_in = 0;
    end
    endtask


    task test_c1_to_c3;
    begin
        $display("TEST : C1 -> C3");

        c1_route_direction = `WEST;
        c1_packet_in = 48'h0000_0000_0012;
        c1_valid_in = 1;

        #1;

        tests_run = tests_run + 1;

        if (
            c3_valid_out &&
            c3_packet_out == 48'h0000_0000_0012
        )
        begin
            tests_passed = tests_passed + 1;
            $display("PASS : C1 -> C3");
        end
        else
        begin
            tests_failed = tests_failed + 1;
            $display("FAIL : C1 -> C3");
        end

        c1_valid_in = 0;
    end
    endtask


    task test_c2_to_c0;
    begin
        $display("TEST : C2 -> C0");

        c2_route_direction = `NORTH;
        c2_packet_in = 48'h0000_0000_0020;
        c2_valid_in = 1;

        #1;

        tests_run = tests_run + 1;

        if (
            c0_valid_out &&
            c0_packet_out == 48'h0000_0000_0020
        )
        begin
            tests_passed = tests_passed + 1;
            $display("PASS : C2 -> C0");
        end
        else
        begin
            tests_failed = tests_failed + 1;
            $display("FAIL : C2 -> C0");
        end

        c2_valid_in = 0;
    end
    endtask


    task test_c2_to_c1;
    begin
        $display("TEST : C2 -> C1");

        c2_route_direction = `EAST;
        c2_packet_in = 48'h0000_0000_0021;
        c2_valid_in = 1;

        #1;

        tests_run = tests_run + 1;

        if (
            c1_valid_out &&
            c1_packet_out == 48'h0000_0000_0021
        )
        begin
            tests_passed = tests_passed + 1;
            $display("PASS : C2 -> C1");
        end
        else
        begin
            tests_failed = tests_failed + 1;
            $display("FAIL : C2 -> C1");
        end

        c2_valid_in = 0;
    end
    endtask


    task test_c2_to_c3;
    begin
        $display("TEST : C2 -> C3");

        c2_route_direction = `WEST;
        c2_packet_in = 48'h0000_0000_0022;
        c2_valid_in = 1;

        #1;

        tests_run = tests_run + 1;

        if (
            c3_valid_out &&
            c3_packet_out == 48'h0000_0000_0022
        )
        begin
            tests_passed = tests_passed + 1;
            $display("PASS : C2 -> C3");
        end
        else
        begin
            tests_failed = tests_failed + 1;
            $display("FAIL : C2 -> C3");
        end

        c2_valid_in = 0;
    end
    endtask


    task test_c3_to_c0;
    begin
        $display("TEST : C3 -> C0");

        c3_route_direction = `NORTH;
        c3_packet_in = 48'h0000_0000_0030;
        c3_valid_in = 1;

        #1;

        tests_run = tests_run + 1;

        if (
            c0_valid_out &&
            c0_packet_out == 48'h0000_0000_0030
        )
        begin
            tests_passed = tests_passed + 1;
            $display("PASS : C3 -> C0");
        end
        else
        begin
            tests_failed = tests_failed + 1;
            $display("FAIL : C3 -> C0");
        end

        c3_valid_in = 0;
    end
    endtask


    task test_c3_to_c1;
    begin
        $display("TEST : C3 -> C1");

        c3_route_direction = `EAST;
        c3_packet_in = 48'h0000_0000_0031;
        c3_valid_in = 1;

        #1;

        tests_run = tests_run + 1;

        if (
            c1_valid_out &&
            c1_packet_out == 48'h0000_0000_0031
        )
        begin
            tests_passed = tests_passed + 1;
            $display("PASS : C3 -> C1");
        end
        else
        begin
            tests_failed = tests_failed + 1;
            $display("FAIL : C3 -> C1");
        end

        c3_valid_in = 0;
    end
    endtask


    task test_c3_to_c2;
    begin
        $display("TEST : C3 -> C2");

        c3_route_direction = `SOUTH;
        c3_packet_in = 48'h0000_0000_0032;
        c3_valid_in = 1;

        #1;

        tests_run = tests_run + 1;

        if (
            c2_valid_out &&
            c2_packet_out == 48'h0000_0000_0032
        )
        begin
            tests_passed = tests_passed + 1;
            $display("PASS : C3 -> C2");
        end
        else
        begin
            tests_failed = tests_failed + 1;
            $display("FAIL : C3 -> C2");
        end

        c3_valid_in = 0;
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

        repeat(3)
            @(posedge clk);

        rst = 0;

        #1;


        $display("");
        $display("================================================");
        $display("       4-CLUSTER GLOBAL NETWORK TEST");
        $display("================================================");


        // 12 directed connections

        test_c0_to_c1();
        test_c0_to_c2();
        test_c0_to_c3();

        test_c1_to_c0();
        test_c1_to_c2();
        test_c1_to_c3();

        test_c2_to_c0();
        test_c2_to_c1();
        test_c2_to_c3();

        test_c3_to_c0();
        test_c3_to_c1();
        test_c3_to_c2();


        // =====================================================
        // SUMMARY
        // =====================================================

        $display("");
        $display("================================================");
        $display("          GLOBAL NETWORK SUMMARY");
        $display("================================================");

        $display("Tests Run    : %0d", tests_run);
        $display("Tests Passed : %0d", tests_passed);
        $display("Tests Failed : %0d", tests_failed);

        if (tests_failed == 0)
            $display("RESULT : ALL GLOBAL LINKS PASSED");
        else
            $display("RESULT : GLOBAL LINK TEST FAILED");

        $display("================================================");

        #20;
        $finish;

    end

endmodule