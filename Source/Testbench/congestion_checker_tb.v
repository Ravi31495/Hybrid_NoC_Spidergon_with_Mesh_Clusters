`timescale 1ns / 1ps

module congestion_checker_tb;

reg local_busy;
reg north_busy;
reg south_busy;
reg east_busy;
reg west_busy;

reg [2:0] direction;

wire congested;

congestion_checker DUT
(
.local_busy(local_busy),
.north_busy(north_busy),
.south_busy(south_busy),
.east_busy(east_busy),
.west_busy(west_busy),
.direction(direction),
.congested(congested)
);

initial
begin

    // Initially all ports are free
    local_busy = 0;
    north_busy = 0;
    south_busy = 0;
    east_busy  = 0;
    west_busy  = 0;

    //-----------------------------
    // Test 1 : EAST free
    //-----------------------------
    direction = 3'b011;
    #20;

    //-----------------------------
    // Test 2 : EAST busy
    //-----------------------------
    east_busy = 1;
    #20;

    //-----------------------------
    // Test 3 : NORTH busy
    //-----------------------------
    east_busy = 0;
    north_busy = 1;
    direction = 3'b001;
    #20;

    //-----------------------------
    // Test 4 : LOCAL free
    //-----------------------------
    north_busy = 0;
    direction = 3'b000;
    #20;

    //-----------------------------
    // Test 5 : WEST busy
    //-----------------------------
    west_busy = 1;
    direction = 3'b100;
    #20;

    $finish;

end

endmodule