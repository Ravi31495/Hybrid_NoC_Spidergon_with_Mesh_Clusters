`timescale 1ns / 1ps

`include "noc_defines.vh"

//////////////////////////////////////////////////////////////////////////////////
// Module Name : gateway_interface_tb
// Description : Functional verification of gateway_interface
//
// Tests:
//   1. LOCAL -> NORTH
//   2. LOCAL -> SOUTH
//   3. LOCAL -> EAST
//   4. LOCAL -> WEST
//   5. Back-pressure
//   6. NORTH -> LOCAL
//   7. SOUTH -> LOCAL
//   8. EAST  -> LOCAL
//   9. WEST  -> LOCAL
//  10. Global input priority
//  11. LOCAL direction isolation
//////////////////////////////////////////////////////////////////////////////////

module gateway_interface_tb;

    reg clk;
    reg rst;

    // Local side
    reg  [`PACKET_WIDTH-1:0] local_packet_in;
    reg                       local_valid_in;
    wire                      local_ready_out;

    wire [`PACKET_WIDTH-1:0] local_packet_out;
    wire                      local_valid_out;
    reg                       local_ready_in;

    // Routing direction
    reg [2:0] route_direction;

    // NORTH
    wire [`PACKET_WIDTH-1:0] north_packet_out;
    wire                      north_valid_out;
    reg                       north_ready_in;

    reg  [`PACKET_WIDTH-1:0] north_packet_in;
    reg                       north_valid_in;
    wire                      north_ready_out;

    // SOUTH
    wire [`PACKET_WIDTH-1:0] south_packet_out;
    wire                      south_valid_out;
    reg                       south_ready_in;

    reg  [`PACKET_WIDTH-1:0] south_packet_in;
    reg                       south_valid_in;
    wire                      south_ready_out;

    // EAST
    wire [`PACKET_WIDTH-1:0] east_packet_out;
    wire                      east_valid_out;
    reg                       east_ready_in;

    reg  [`PACKET_WIDTH-1:0] east_packet_in;
    reg                       east_valid_in;
    wire                      east_ready_out;

    // WEST
    wire [`PACKET_WIDTH-1:0] west_packet_out;
    wire                      west_valid_out;
    reg                       west_ready_in;

    reg  [`PACKET_WIDTH-1:0] west_packet_in;
    reg                       west_valid_in;
    wire                      west_ready_out;

    integer errors;


    ////////////////////////////////////////////////////////////////////////////
    // Direction definitions
    ////////////////////////////////////////////////////////////////////////////

    localparam LOCAL = 3'b000;
    localparam NORTH = 3'b001;
    localparam SOUTH = 3'b010;
    localparam EAST  = 3'b011;
    localparam WEST  = 3'b100;


    ////////////////////////////////////////////////////////////////////////////
    // DUT
    ////////////////////////////////////////////////////////////////////////////

    gateway_interface DUT
    (
        .clk              (clk),
        .rst              (rst),

        .local_packet_in  (local_packet_in),
        .local_valid_in   (local_valid_in),
        .local_ready_out  (local_ready_out),

        .local_packet_out (local_packet_out),
        .local_valid_out  (local_valid_out),
        .local_ready_in   (local_ready_in),

        .route_direction  (route_direction),

        .north_packet_out (north_packet_out),
        .north_valid_out  (north_valid_out),
        .north_ready_in   (north_ready_in),

        .north_packet_in  (north_packet_in),
        .north_valid_in   (north_valid_in),
        .north_ready_out  (north_ready_out),

        .south_packet_out (south_packet_out),
        .south_valid_out  (south_valid_out),
        .south_ready_in   (south_ready_in),

        .south_packet_in  (south_packet_in),
        .south_valid_in   (south_valid_in),
        .south_ready_out  (south_ready_out),

        .east_packet_out  (east_packet_out),
        .east_valid_out   (east_valid_out),
        .east_ready_in    (east_ready_in),

        .east_packet_in   (east_packet_in),
        .east_valid_in    (east_valid_in),
        .east_ready_out   (east_ready_out),

        .west_packet_out  (west_packet_out),
        .west_valid_out   (west_valid_out),
        .west_ready_in    (west_ready_in),

        .west_packet_in   (west_packet_in),
        .west_valid_in    (west_valid_in),
        .west_ready_out   (west_ready_out)
    );


    ////////////////////////////////////////////////////////////////////////////
    // Clock
    ////////////////////////////////////////////////////////////////////////////

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end


    ////////////////////////////////////////////////////////////////////////////
    // Test helper
    ////////////////////////////////////////////////////////////////////////////

    task clear_global_inputs;
    begin

        north_valid_in = 1'b0;
        south_valid_in = 1'b0;
        east_valid_in  = 1'b0;
        west_valid_in  = 1'b0;

        north_packet_in = 48'b0;
        south_packet_in = 48'b0;
        east_packet_in  = 48'b0;
        west_packet_in  = 48'b0;

    end
    endtask


    ////////////////////////////////////////////////////////////////////////////
    // Test 1 : LOCAL -> NORTH
    ////////////////////////////////////////////////////////////////////////////

    task test_local_north;
    begin

        local_packet_in = 48'h123456789ABC;
        local_valid_in  = 1'b1;
        route_direction = NORTH;

        north_ready_in = 1'b1;
        south_ready_in = 1'b0;
        east_ready_in  = 1'b0;
        west_ready_in  = 1'b0;

        #1;

        if (north_valid_out !== 1'b1) begin
            $display("ERROR: LOCAL -> NORTH valid");
            errors = errors + 1;
        end

        if (north_packet_out !== local_packet_in) begin
            $display("ERROR: LOCAL -> NORTH packet");
            errors = errors + 1;
        end

        if (local_ready_out !== 1'b1) begin
            $display("ERROR: LOCAL -> NORTH ready");
            errors = errors + 1;
        end

        if (south_valid_out !== 1'b0 ||
            east_valid_out  !== 1'b0 ||
            west_valid_out  !== 1'b0) begin

            $display("ERROR: LOCAL -> NORTH wrong outputs");
            errors = errors + 1;
        end

        $display("TEST 1 PASSED : LOCAL -> NORTH");

    end
    endtask


    ////////////////////////////////////////////////////////////////////////////
    // Test 2 : LOCAL -> SOUTH
    ////////////////////////////////////////////////////////////////////////////

    task test_local_south;
    begin

        local_packet_in = 48'h23456789ABCD;
        local_valid_in  = 1'b1;
        route_direction = SOUTH;

        north_ready_in = 1'b0;
        south_ready_in = 1'b1;
        east_ready_in  = 1'b0;
        west_ready_in  = 1'b0;

        #1;

        if (south_valid_out !== 1'b1) begin
            $display("ERROR: LOCAL -> SOUTH valid");
            errors = errors + 1;
        end

        if (south_packet_out !== local_packet_in) begin
            $display("ERROR: LOCAL -> SOUTH packet");
            errors = errors + 1;
        end

        if (local_ready_out !== 1'b1) begin
            $display("ERROR: LOCAL -> SOUTH ready");
            errors = errors + 1;
        end

        $display("TEST 2 PASSED : LOCAL -> SOUTH");

    end
    endtask


    ////////////////////////////////////////////////////////////////////////////
    // Test 3 : LOCAL -> EAST
    ////////////////////////////////////////////////////////////////////////////

    task test_local_east;
    begin

        local_packet_in = 48'h3456789ABCDE;
        local_valid_in  = 1'b1;
        route_direction = EAST;

        north_ready_in = 1'b0;
        south_ready_in = 1'b0;
        east_ready_in  = 1'b1;
        west_ready_in  = 1'b0;

        #1;

        if (east_valid_out !== 1'b1) begin
            $display("ERROR: LOCAL -> EAST valid");
            errors = errors + 1;
        end

        if (east_packet_out !== local_packet_in) begin
            $display("ERROR: LOCAL -> EAST packet");
            errors = errors + 1;
        end

        if (local_ready_out !== 1'b1) begin
            $display("ERROR: LOCAL -> EAST ready");
            errors = errors + 1;
        end

        $display("TEST 3 PASSED : LOCAL -> EAST");

    end
    endtask


    ////////////////////////////////////////////////////////////////////////////
    // Test 4 : LOCAL -> WEST
    ////////////////////////////////////////////////////////////////////////////

    task test_local_west;
    begin

        local_packet_in = 48'h456789ABCDEF;
        local_valid_in  = 1'b1;
        route_direction = WEST;

        north_ready_in = 1'b0;
        south_ready_in = 1'b0;
        east_ready_in  = 1'b0;
        west_ready_in  = 1'b1;

        #1;

        if (west_valid_out !== 1'b1) begin
            $display("ERROR: LOCAL -> WEST valid");
            errors = errors + 1;
        end

        if (west_packet_out !== local_packet_in) begin
            $display("ERROR: LOCAL -> WEST packet");
            errors = errors + 1;
        end

        if (local_ready_out !== 1'b1) begin
            $display("ERROR: LOCAL -> WEST ready");
            errors = errors + 1;
        end

        $display("TEST 4 PASSED : LOCAL -> WEST");

    end
    endtask


    ////////////////////////////////////////////////////////////////////////////
    // Test 5 : Back-pressure
    ////////////////////////////////////////////////////////////////////////////

    task test_backpressure;
    begin

        local_packet_in = 48'h56789ABCDEF0;
        local_valid_in  = 1'b1;
        route_direction = NORTH;

        north_ready_in = 1'b0;
        south_ready_in = 1'b0;
        east_ready_in  = 1'b0;
        west_ready_in  = 1'b0;

        #1;

        if (north_valid_out !== 1'b1) begin
            $display("ERROR: back-pressure valid");
            errors = errors + 1;
        end

        if (local_ready_out !== 1'b0) begin
            $display("ERROR: back-pressure ready");
            errors = errors + 1;
        end

        $display("TEST 5 PASSED : BACK-PRESSURE");

    end
    endtask


    ////////////////////////////////////////////////////////////////////////////
    // Test 6 : NORTH -> LOCAL
    ////////////////////////////////////////////////////////////////////////////

    task test_north_local;
    begin

        clear_global_inputs;

        north_packet_in = 48'h111122223333;
        north_valid_in  = 1'b1;
        local_ready_in  = 1'b1;

        #1;

        if (local_valid_out !== 1'b1) begin
            $display("ERROR: NORTH -> LOCAL valid");
            errors = errors + 1;
        end

        if (local_packet_out !== north_packet_in) begin
            $display("ERROR: NORTH -> LOCAL packet");
            errors = errors + 1;
        end

        if (north_ready_out !== 1'b1) begin
            $display("ERROR: NORTH -> LOCAL ready");
            errors = errors + 1;
        end

        $display("TEST 6 PASSED : NORTH -> LOCAL");

    end
    endtask


    ////////////////////////////////////////////////////////////////////////////
    // Test 7 : SOUTH -> LOCAL
    ////////////////////////////////////////////////////////////////////////////

    task test_south_local;
    begin

        clear_global_inputs;

        south_packet_in = 48'h222233334444;
        south_valid_in  = 1'b1;
        local_ready_in  = 1'b1;

        #1;

        if (local_valid_out !== 1'b1) begin
            $display("ERROR: SOUTH -> LOCAL valid");
            errors = errors + 1;
        end

        if (local_packet_out !== south_packet_in) begin
            $display("ERROR: SOUTH -> LOCAL packet");
            errors = errors + 1;
        end

        if (south_ready_out !== 1'b1) begin
            $display("ERROR: SOUTH -> LOCAL ready");
            errors = errors + 1;
        end

        $display("TEST 7 PASSED : SOUTH -> LOCAL");

    end
    endtask


    ////////////////////////////////////////////////////////////////////////////
    // Test 8 : EAST -> LOCAL
    ////////////////////////////////////////////////////////////////////////////

    task test_east_local;
    begin

        clear_global_inputs;

        east_packet_in = 48'h333344445555;
        east_valid_in  = 1'b1;
        local_ready_in = 1'b1;

        #1;

        if (local_valid_out !== 1'b1) begin
            $display("ERROR: EAST -> LOCAL valid");
            errors = errors + 1;
        end

        if (local_packet_out !== east_packet_in) begin
            $display("ERROR: EAST -> LOCAL packet");
            errors = errors + 1;
        end

        if (east_ready_out !== 1'b1) begin
            $display("ERROR: EAST -> LOCAL ready");
            errors = errors + 1;
        end

        $display("TEST 8 PASSED : EAST -> LOCAL");

    end
    endtask


    ////////////////////////////////////////////////////////////////////////////
    // Test 9 : WEST -> LOCAL
    ////////////////////////////////////////////////////////////////////////////

    task test_west_local;
    begin

        clear_global_inputs;

        west_packet_in = 48'h444455556666;
        west_valid_in  = 1'b1;
        local_ready_in = 1'b1;

        #1;

        if (local_valid_out !== 1'b1) begin
            $display("ERROR: WEST -> LOCAL valid");
            errors = errors + 1;
        end

        if (local_packet_out !== west_packet_in) begin
            $display("ERROR: WEST -> LOCAL packet");
            errors = errors + 1;
        end

        if (west_ready_out !== 1'b1) begin
            $display("ERROR: WEST -> LOCAL ready");
            errors = errors + 1;
        end

        $display("TEST 9 PASSED : WEST -> LOCAL");

    end
    endtask


    ////////////////////////////////////////////////////////////////////////////
    // Test 10 : Global priority
    //
    // NORTH > SOUTH > EAST > WEST
    ////////////////////////////////////////////////////////////////////////////

    task test_priority;
    begin

        clear_global_inputs;

        local_ready_in = 1'b1;

        north_packet_in = 48'hAAAA00000001;
        south_packet_in = 48'hBBBB00000002;
        east_packet_in  = 48'hCCCC00000003;
        west_packet_in  = 48'hDDDD00000004;

        north_valid_in = 1'b1;
        south_valid_in = 1'b1;
        east_valid_in  = 1'b1;
        west_valid_in  = 1'b1;

        #1;

        if (local_packet_out !== north_packet_in) begin
            $display("ERROR: Priority did not select NORTH");
            errors = errors + 1;
        end

        if (north_ready_out !== 1'b1) begin
            $display("ERROR: NORTH priority ready");
            errors = errors + 1;
        end

        if (south_ready_out !== 1'b0 ||
            east_ready_out  !== 1'b0 ||
            west_ready_out  !== 1'b0) begin

            $display("ERROR: Lower-priority inputs incorrectly granted");
            errors = errors + 1;
        end

        $display("TEST 10 PASSED : GLOBAL PRIORITY");

    end
    endtask


    ////////////////////////////////////////////////////////////////////////////
    // Test 11 : LOCAL direction isolation
    ////////////////////////////////////////////////////////////////////////////

    task test_local_direction;
    begin

        clear_global_inputs;

        local_packet_in = 48'h777788889999;
        local_valid_in  = 1'b1;
        route_direction = LOCAL;

        north_ready_in = 1'b1;
        south_ready_in = 1'b1;
        east_ready_in  = 1'b1;
        west_ready_in  = 1'b1;

        #1;

        if (north_valid_out !== 1'b0 ||
            south_valid_out !== 1'b0 ||
            east_valid_out  !== 1'b0 ||
            west_valid_out  !== 1'b0) begin

            $display("ERROR: LOCAL direction activated gateway output");
            errors = errors + 1;
        end

        if (local_ready_out !== 1'b0) begin
            $display("ERROR: LOCAL direction incorrectly ready");
            errors = errors + 1;
        end

        $display("TEST 11 PASSED : LOCAL DIRECTION ISOLATION");

    end
    endtask


    ////////////////////////////////////////////////////////////////////////////
    // Main test sequence
    ////////////////////////////////////////////////////////////////////////////

    initial begin

        errors = 0;

        rst = 1'b1;

        local_packet_in = 48'b0;
        local_valid_in  = 1'b0;
        local_ready_in  = 1'b0;

        route_direction = LOCAL;

        north_ready_in = 1'b0;
        south_ready_in = 1'b0;
        east_ready_in  = 1'b0;
        west_ready_in  = 1'b0;

        clear_global_inputs;

        #20;

        rst = 1'b0;

        #10;

        $display("");
        $display("===============================================");
        $display(" GATEWAY INTERFACE TEST");
        $display("===============================================");

        test_local_north;
        test_local_south;
        test_local_east;
        test_local_west;
        test_backpressure;

        test_north_local;
        test_south_local;
        test_east_local;
        test_west_local;

        test_priority;
        test_local_direction;

        #10;

        $display("");
        $display("===============================================");

        if (errors == 0)
            $display("RESULT : ALL TESTS PASSED");
        else
            $display("RESULT : %0d ERRORS", errors);

        $display("===============================================");
        $display("");

        $finish;

    end

endmodule