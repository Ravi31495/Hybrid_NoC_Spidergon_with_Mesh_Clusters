`timescale 1ns/1ps
`include "noc_defines.vh"

module gateway_integration_tb;

    reg clk;
    reg rst;

    // =========================================================
    // LOCAL MESH INPUTS
    // =========================================================

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

    // =========================================================
    // GATEWAY PORT OF R0
    // =========================================================

    reg [`PACKET_WIDTH-1:0] gateway_packet_in;
    reg gateway_write;
    reg gateway_busy;

    wire [`PACKET_WIDTH-1:0] gateway_packet_out;
    wire gateway_valid;
    wire gateway_full;

    // =========================================================
    // ROUTE DIRECTION
    // =========================================================

    reg [2:0] route_direction;

    // =========================================================
    // GATEWAY INTERFACE - GLOBAL OUTPUTS
    // =========================================================

    wire [`PACKET_WIDTH-1:0] north_packet_out;
    wire [`PACKET_WIDTH-1:0] south_packet_out;
    wire [`PACKET_WIDTH-1:0] east_packet_out;
    wire [`PACKET_WIDTH-1:0] west_packet_out;

    wire north_valid_out;
    wire south_valid_out;
    wire east_valid_out;
    wire west_valid_out;

    reg north_ready_in;
    reg south_ready_in;
    reg east_ready_in;
    reg west_ready_in;

    // =========================================================
    // GATEWAY INTERFACE - GLOBAL INPUTS
    // =========================================================

    reg [`PACKET_WIDTH-1:0] north_packet_in;
    reg [`PACKET_WIDTH-1:0] south_packet_in;
    reg [`PACKET_WIDTH-1:0] east_packet_in;
    reg [`PACKET_WIDTH-1:0] west_packet_in;

    reg north_valid_in;
    reg south_valid_in;
    reg east_valid_in;
    reg west_valid_in;

    wire north_ready_out;
    wire south_ready_out;
    wire east_ready_out;
    wire west_ready_out;

    // =========================================================
    // LOCAL SIDE OF GATEWAY INTERFACE
    // =========================================================

    wire [`PACKET_WIDTH-1:0] local_gateway_packet_out;
    wire local_gateway_valid_out;

    wire local_gateway_ready_out;
    reg local_gateway_ready_in;

    // =========================================================
    // TEST COUNTERS
    // =========================================================

    integer tests_run;
    integer tests_passed;
    integer tests_failed;


    // =========================================================
    // CLOCK
    // =========================================================

    always #5 clk = ~clk;


    // =========================================================
    // 2x2 MESH
    // =========================================================

    mesh_2x2 MESH
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
    // GATEWAY INTERFACE
    // =========================================================

    gateway_interface GATEWAY
    (
        .clk(clk),
        .rst(rst),

        // Local side
        .local_packet_in(gateway_packet_out),
        .local_valid_in(gateway_valid),
        .local_ready_out(local_gateway_ready_out),

        .local_packet_out(local_gateway_packet_out),
        .local_valid_out(local_gateway_valid_out),
        .local_ready_in(local_gateway_ready_in),

        // Routing direction
        .route_direction(route_direction),

        // NORTH
        .north_packet_out(north_packet_out),
        .north_valid_out(north_valid_out),
        .north_ready_in(north_ready_in),

        .north_packet_in(north_packet_in),
        .north_valid_in(north_valid_in),
        .north_ready_out(north_ready_out),

        // SOUTH
        .south_packet_out(south_packet_out),
        .south_valid_out(south_valid_out),
        .south_ready_in(south_ready_in),

        .south_packet_in(south_packet_in),
        .south_valid_in(south_valid_in),
        .south_ready_out(south_ready_out),

        // EAST
        .east_packet_out(east_packet_out),
        .east_valid_out(east_valid_out),
        .east_ready_in(east_ready_in),

        .east_packet_in(east_packet_in),
        .east_valid_in(east_valid_in),
        .east_ready_out(east_ready_out),

        // WEST
        .west_packet_out(west_packet_out),
        .west_valid_out(west_valid_out),
        .west_ready_in(west_ready_in),

        .west_packet_in(west_packet_in),
        .west_valid_in(west_valid_in),
        .west_ready_out(west_ready_out)
    );


    // =========================================================
    // INITIALIZATION
    // =========================================================

    initial
    begin

        clk = 0;
        rst = 1;

        tests_run = 0;
        tests_passed = 0;
        tests_failed = 0;

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

        route_direction = `LOCAL;

        north_ready_in = 1;
        south_ready_in = 1;
        east_ready_in  = 1;
        west_ready_in  = 1;

        north_packet_in = 0;
        south_packet_in = 0;
        east_packet_in  = 0;
        west_packet_in  = 0;

        north_valid_in = 0;
        south_valid_in = 0;
        east_valid_in = 0;
        west_valid_in = 0;

        local_gateway_ready_in = 1;


        $display("");
        $display("================================================");
        $display("      GATEWAY INTERFACE INTEGRATION TEST");
        $display("================================================");


        // Reset
        repeat(5)
            @(posedge clk);

        rst = 0;

        repeat(2)
            @(posedge clk);


        // =====================================================
        // TEST 1 : EAST
        // =====================================================

        $display("");
        $display("TEST 1 : R0 -> EAST");

        route_direction = `EAST;

        @(negedge clk);

        local_packet_in0 = 48'h1111_1111_1111;
        local_write0 = 1;

        @(negedge clk);

        local_write0 = 0;
        local_packet_in0 = 0;

        repeat(5)
            @(posedge clk);

        tests_run = tests_run + 1;

        if (
            east_valid_out &&
            east_packet_out == 48'h1111_1111_1111
        )
        begin
            tests_passed = tests_passed + 1;
            $display("PASS : R0 -> EAST");
        end
        else
        begin
            tests_failed = tests_failed + 1;
            $display("FAIL : R0 -> EAST");
            $display("valid = %b", east_valid_out);
            $display("packet = %h", east_packet_out);
        end


        // =====================================================
        // TEST 2 : SOUTH
        // =====================================================

        $display("");
        $display("TEST 2 : R0 -> SOUTH");

        route_direction = `SOUTH;

        @(negedge clk);

        local_packet_in0 = 48'h2222_2222_2222;
        local_write0 = 1;

        @(negedge clk);

        local_write0 = 0;
        local_packet_in0 = 0;

        repeat(5)
            @(posedge clk);

        tests_run = tests_run + 1;

        if (
            south_valid_out &&
            south_packet_out == 48'h2222_2222_2222
        )
        begin
            tests_passed = tests_passed + 1;
            $display("PASS : R0 -> SOUTH");
        end
        else
        begin
            tests_failed = tests_failed + 1;
            $display("FAIL : R0 -> SOUTH");
            $display("valid = %b", south_valid_out);
            $display("packet = %h", south_packet_out);
        end


        // =====================================================
        // TEST 3 : WEST
        // =====================================================

        $display("");
        $display("TEST 3 : R0 -> WEST");

        route_direction = `WEST;

        @(negedge clk);

        local_packet_in0 = 48'h3333_3333_3333;
        local_write0 = 1;

        @(negedge clk);

        local_write0 = 0;
        local_packet_in0 = 0;

        repeat(5)
            @(posedge clk);

        tests_run = tests_run + 1;

        if (
            west_valid_out &&
            west_packet_out == 48'h3333_3333_3333
        )
        begin
            tests_passed = tests_passed + 1;
            $display("PASS : R0 -> WEST");
        end
        else
        begin
            tests_failed = tests_failed + 1;
            $display("FAIL : R0 -> WEST");
            $display("valid = %b", west_valid_out);
            $display("packet = %h", west_packet_out);
        end


        // =====================================================
        // TEST 4 : GLOBAL -> LOCAL
        // =====================================================

        $display("");
        $display("TEST 4 : EAST -> R0");

        east_packet_in = 48'h4444_4444_4444;
        east_valid_in = 1;

        repeat(2)
            @(posedge clk);

        tests_run = tests_run + 1;

        if (
            local_gateway_valid_out &&
            local_gateway_packet_out == 48'h4444_4444_4444
        )
        begin
            tests_passed = tests_passed + 1;
            $display("PASS : EAST -> R0");
        end
        else
        begin
            tests_failed = tests_failed + 1;
            $display("FAIL : EAST -> R0");
        end

        east_valid_in = 0;
        east_packet_in = 0;


        // =====================================================
        // SUMMARY
        // =====================================================

        $display("");
        $display("================================================");
        $display("             TEST SUMMARY");
        $display("================================================");

        $display("Tests Run    : %0d", tests_run);
        $display("Tests Passed : %0d", tests_passed);
        $display("Tests Failed : %0d", tests_failed);

        if (tests_failed == 0)
            $display("RESULT : ALL TESTS PASSED");
        else
            $display("RESULT : TESTS FAILED");

        $display("================================================");

        #50;

        $finish;

    end

endmodule