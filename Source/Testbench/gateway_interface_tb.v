`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name : gateway_interface_tb
//
// Description :
// Standalone testbench for gateway_interface.
//
// Tests:
//
// 1. Local -> NORTH
// 2. Local -> SOUTH
// 3. Local -> EAST
// 4. Local -> WEST
// 5. NORTH -> Local
// 6. SOUTH -> Local
// 7. EAST -> Local
// 8. WEST -> Local
// 9. Local back-pressure
//////////////////////////////////////////////////////////////////////////////////

module gateway_interface_tb;


    //////////////////////////////////////////////////////
    // Direction Encoding
    //////////////////////////////////////////////////////

    localparam LOCAL = 3'b000;
    localparam NORTH = 3'b001;
    localparam SOUTH = 3'b010;
    localparam EAST  = 3'b011;
    localparam WEST  = 3'b100;


    //////////////////////////////////////////////////////
    // Clock / Reset
    //////////////////////////////////////////////////////

    reg clk;
    reg rst;


    //////////////////////////////////////////////////////
    // Local side
    //////////////////////////////////////////////////////

    reg  [47:0] local_packet_in;
    reg         local_valid_in;
    wire        local_ready_out;

    wire [47:0] local_packet_out;
    wire        local_valid_out;
    reg         local_ready_in;


    //////////////////////////////////////////////////////
    // Routing direction
    //////////////////////////////////////////////////////

    reg [2:0] route_direction;


    //////////////////////////////////////////////////////
    // NORTH
    //////////////////////////////////////////////////////

    wire [47:0] north_packet_out;
    wire        north_valid_out;
    reg         north_ready_in;

    reg  [47:0] north_packet_in;
    reg         north_valid_in;
    wire        north_ready_out;


    //////////////////////////////////////////////////////
    // SOUTH
    //////////////////////////////////////////////////////

    wire [47:0] south_packet_out;
    wire        south_valid_out;
    reg         south_ready_in;

    reg  [47:0] south_packet_in;
    reg         south_valid_in;
    wire        south_ready_out;


    //////////////////////////////////////////////////////
    // EAST
    //////////////////////////////////////////////////////

    wire [47:0] east_packet_out;
    wire        east_valid_out;
    reg         east_ready_in;

    reg  [47:0] east_packet_in;
    reg         east_valid_in;
    wire        east_ready_out;


    //////////////////////////////////////////////////////
    // WEST
    //////////////////////////////////////////////////////

    wire [47:0] west_packet_out;
    wire        west_valid_out;
    reg         west_ready_in;

    reg  [47:0] west_packet_in;
    reg         west_valid_in;
    wire        west_ready_out;


    //////////////////////////////////////////////////////
    // DUT
    //////////////////////////////////////////////////////

    gateway_interface DUT
    (
        .clk(clk),
        .rst(rst),

        .local_packet_in(local_packet_in),
        .local_valid_in(local_valid_in),
        .local_ready_out(local_ready_out),

        .local_packet_out(local_packet_out),
        .local_valid_out(local_valid_out),
        .local_ready_in(local_ready_in),

        .route_direction(route_direction),

        .north_packet_out(north_packet_out),
        .north_valid_out(north_valid_out),
        .north_ready_in(north_ready_in),

        .north_packet_in(north_packet_in),
        .north_valid_in(north_valid_in),
        .north_ready_out(north_ready_out),

        .south_packet_out(south_packet_out),
        .south_valid_out(south_valid_out),
        .south_ready_in(south_ready_in),

        .south_packet_in(south_packet_in),
        .south_valid_in(south_valid_in),
        .south_ready_out(south_ready_out),

        .east_packet_out(east_packet_out),
        .east_valid_out(east_valid_out),
        .east_ready_in(east_ready_in),

        .east_packet_in(east_packet_in),
        .east_valid_in(east_valid_in),
        .east_ready_out(east_ready_out),

        .west_packet_out(west_packet_out),
        .west_valid_out(west_valid_out),
        .west_ready_in(west_ready_in),

        .west_packet_in(west_packet_in),
        .west_valid_in(west_valid_in),
        .west_ready_out(west_ready_out)
    );


    //////////////////////////////////////////////////////
    // Clock
    //////////////////////////////////////////////////////

    initial
    begin
        clk = 1'b0;

        forever
            #5 clk = ~clk;
    end


    //////////////////////////////////////////////////////
    // Test
    //////////////////////////////////////////////////////

    initial
    begin

        //////////////////////////////////////////////////
        // Initial state
        //////////////////////////////////////////////////

        rst = 1'b1;

        local_packet_in = 48'h0;
        local_valid_in  = 1'b0;
        local_ready_in  = 1'b1;

        route_direction = LOCAL;

        north_ready_in = 1'b1;
        south_ready_in = 1'b1;
        east_ready_in  = 1'b1;
        west_ready_in  = 1'b1;

        north_packet_in = 48'h0;
        south_packet_in = 48'h0;
        east_packet_in  = 48'h0;
        west_packet_in  = 48'h0;

        north_valid_in = 1'b0;
        south_valid_in = 1'b0;
        east_valid_in  = 1'b0;
        west_valid_in  = 1'b0;


        #20;

        rst = 1'b0;


        //////////////////////////////////////////////////
        // TEST 1
        // Local -> NORTH
        //////////////////////////////////////////////////

        $display("");
        $display("==============================================");
        $display("TEST 1 : LOCAL -> NORTH");
        $display("==============================================");

        local_packet_in = 48'h111111111111;
        local_valid_in  = 1'b1;
        route_direction = NORTH;

        #10;

        $display("NORTH VALID  = %b", north_valid_out);
        $display("NORTH PACKET = %h", north_packet_out);

        if ((north_valid_out == 1'b1) &&
            (north_packet_out == 48'h111111111111))
            $display("RESULT       = PASS");
        else
            $display("RESULT       = FAIL");

        local_valid_in = 1'b0;


        //////////////////////////////////////////////////
        // TEST 2
        // Local -> SOUTH
        //////////////////////////////////////////////////

        $display("");
        $display("==============================================");
        $display("TEST 2 : LOCAL -> SOUTH");
        $display("==============================================");

        local_packet_in = 48'h222222222222;
        local_valid_in  = 1'b1;
        route_direction = SOUTH;

        #10;

        $display("SOUTH VALID  = %b", south_valid_out);
        $display("SOUTH PACKET = %h", south_packet_out);

        if ((south_valid_out == 1'b1) &&
            (south_packet_out == 48'h222222222222))
            $display("RESULT       = PASS");
        else
            $display("RESULT       = FAIL");

        local_valid_in = 1'b0;


        //////////////////////////////////////////////////
        // TEST 3
        // Local -> EAST
        //////////////////////////////////////////////////

        $display("");
        $display("==============================================");
        $display("TEST 3 : LOCAL -> EAST");
        $display("==============================================");

        local_packet_in = 48'h333333333333;
        local_valid_in  = 1'b1;
        route_direction = EAST;

        #10;

        $display("EAST VALID   = %b", east_valid_out);
        $display("EAST PACKET  = %h", east_packet_out);

        if ((east_valid_out == 1'b1) &&
            (east_packet_out == 48'h333333333333))
            $display("RESULT       = PASS");
        else
            $display("RESULT       = FAIL");

        local_valid_in = 1'b0;


        //////////////////////////////////////////////////
        // TEST 4
        // Local -> WEST
        //////////////////////////////////////////////////

        $display("");
        $display("==============================================");
        $display("TEST 4 : LOCAL -> WEST");
        $display("==============================================");

        local_packet_in = 48'h444444444444;
        local_valid_in  = 1'b1;
        route_direction = WEST;

        #10;

        $display("WEST VALID   = %b", west_valid_out);
        $display("WEST PACKET  = %h", west_packet_out);

        if ((west_valid_out == 1'b1) &&
            (west_packet_out == 48'h444444444444))
            $display("RESULT       = PASS");
        else
            $display("RESULT       = FAIL");

        local_valid_in = 1'b0;


        //////////////////////////////////////////////////
        // TEST 5
        // NORTH -> Local
        //////////////////////////////////////////////////

        $display("");
        $display("==============================================");
        $display("TEST 5 : NORTH -> LOCAL");
        $display("==============================================");

        north_packet_in = 48'h555555555555;
        north_valid_in  = 1'b1;

        #10;

        $display("LOCAL VALID  = %b", local_valid_out);
        $display("LOCAL PACKET = %h", local_packet_out);

        if ((local_valid_out == 1'b1) &&
            (local_packet_out == 48'h555555555555))
            $display("RESULT       = PASS");
        else
            $display("RESULT       = FAIL");

        north_valid_in = 1'b0;


        //////////////////////////////////////////////////
        // TEST 6
        // SOUTH -> Local
        //////////////////////////////////////////////////

        $display("");
        $display("==============================================");
        $display("TEST 6 : SOUTH -> LOCAL");
        $display("==============================================");

        south_packet_in = 48'h666666666666;
        south_valid_in  = 1'b1;

        #10;

        $display("LOCAL VALID  = %b", local_valid_out);
        $display("LOCAL PACKET = %h", local_packet_out);

        if ((local_valid_out == 1'b1) &&
            (local_packet_out == 48'h666666666666))
            $display("RESULT       = PASS");
        else
            $display("RESULT       = FAIL");

        south_valid_in = 1'b0;


        //////////////////////////////////////////////////
        // TEST 7
        // EAST -> Local
        //////////////////////////////////////////////////

        $display("");
        $display("==============================================");
        $display("TEST 7 : EAST -> LOCAL");
        $display("==============================================");

        east_packet_in = 48'h777777777777;
        east_valid_in  = 1'b1;

        #10;

        $display("LOCAL VALID  = %b", local_valid_out);
        $display("LOCAL PACKET = %h", local_packet_out);

        if ((local_valid_out == 1'b1) &&
            (local_packet_out == 48'h777777777777))
            $display("RESULT       = PASS");
        else
            $display("RESULT       = FAIL");

        east_valid_in = 1'b0;


        //////////////////////////////////////////////////
        // TEST 8
        // WEST -> Local
        //////////////////////////////////////////////////

        $display("");
        $display("==============================================");
        $display("TEST 8 : WEST -> LOCAL");
        $display("==============================================");

        west_packet_in = 48'h888888888888;
        west_valid_in  = 1'b1;

        #10;

        $display("LOCAL VALID  = %b", local_valid_out);
        $display("LOCAL PACKET = %h", local_packet_out);

        if ((local_valid_out == 1'b1) &&
            (local_packet_out == 48'h888888888888))
            $display("RESULT       = PASS");
        else
            $display("RESULT       = FAIL");

        west_valid_in = 1'b0;


        //////////////////////////////////////////////////
        // TEST 9
        // Back-pressure
        //////////////////////////////////////////////////

        $display("");
        $display("==============================================");
        $display("TEST 9 : BACK-PRESSURE");
        $display("==============================================");

        route_direction = EAST;

        east_ready_in = 1'b0;
        local_valid_in = 1'b1;
        local_packet_in = 48'h999999999999;

        #10;

        $display("LOCAL READY   = %b", local_ready_out);
        $display("EAST VALID    = %b", east_valid_out);

        if (local_ready_out == 1'b0)
            $display("RESULT        = PASS");
        else
            $display("RESULT        = FAIL");

        local_valid_in = 1'b0;
        east_ready_in = 1'b1;


        //////////////////////////////////////////////////
        // Complete
        //////////////////////////////////////////////////

        #10;

        $display("");
        $display("==============================================");
        $display("GATEWAY INTERFACE TEST COMPLETE");
        $display("==============================================");

        $finish;

    end

endmodule