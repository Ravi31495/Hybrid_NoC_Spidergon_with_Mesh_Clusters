`timescale 1ns / 1ps
`include "noc_defines.vh"

//////////////////////////////////////////////////////////////////////////////////
// Project Name : Hybrid_NoC_Project
// Module Name  : router_controller_tb
// Description  : Unit test for Router Controller
//////////////////////////////////////////////////////////////////////////////////

module router_controller_tb;

reg clk;
reg rst;

reg [4:0] request;

reg [2:0] dir0;
reg [2:0] dir1;
reg [2:0] dir2;
reg [2:0] dir3;
reg [2:0] dir4;

wire [4:0] local_grant;
wire [4:0] north_grant;
wire [4:0] south_grant;
wire [4:0] east_grant;
wire [4:0] west_grant;

integer tests_run;
integer tests_passed;
integer tests_failed;


//////////////////////////////////////////////////////////////
// DUT
//////////////////////////////////////////////////////////////

router_controller DUT
(
    .clk(clk),
    .rst(rst),

    .request(request),

    .dir0(dir0),
    .dir1(dir1),
    .dir2(dir2),
    .dir3(dir3),
    .dir4(dir4),

    .local_grant(local_grant),
    .north_grant(north_grant),
    .south_grant(south_grant),
    .east_grant(east_grant),
    .west_grant(west_grant)
);


//////////////////////////////////////////////////////////////
// CLOCK
//////////////////////////////////////////////////////////////

always #5 clk = ~clk;


//////////////////////////////////////////////////////////////
// RESET TASK
//////////////////////////////////////////////////////////////

task reset_dut;
begin

    rst = 1'b1;
    request = 5'b00000;

    #12;

    rst = 1'b0;

    #3;

end
endtask


//////////////////////////////////////////////////////////////
// CHECK TASK
//////////////////////////////////////////////////////////////

task check_grants;

input [4:0] expected_local;
input [4:0] expected_north;
input [4:0] expected_south;
input [4:0] expected_east;
input [4:0] expected_west;

begin

    #1;

    tests_run = tests_run + 1;

    if ((local_grant === expected_local) &&
        (north_grant === expected_north) &&
        (south_grant === expected_south) &&
        (east_grant === expected_east) &&
        (west_grant === expected_west))
    begin

        tests_passed = tests_passed + 1;

        $display("PASS");

    end
    else
    begin

        tests_failed = tests_failed + 1;

        $display("FAIL");

        $display("      Expected LOCAL = %b", expected_local);
        $display("      Actual   LOCAL = %b", local_grant);

        $display("      Expected NORTH = %b", expected_north);
        $display("      Actual   NORTH = %b", north_grant);

        $display("      Expected SOUTH = %b", expected_south);
        $display("      Actual   SOUTH = %b", south_grant);

        $display("      Expected EAST  = %b", expected_east);
        $display("      Actual   EAST  = %b", east_grant);

        $display("      Expected WEST  = %b", expected_west);
        $display("      Actual   WEST  = %b", west_grant);

    end

end
endtask


//////////////////////////////////////////////////////////////
// TEST
//////////////////////////////////////////////////////////////

initial
begin

    tests_run    = 0;
    tests_passed = 0;
    tests_failed = 0;

    clk = 1'b0;
    rst = 1'b1;

    request = 5'b00000;

    dir0 = `LOCAL;
    dir1 = `LOCAL;
    dir2 = `LOCAL;
    dir3 = `LOCAL;
    dir4 = `LOCAL;


    $display("");
    $display("================================================");
    $display("          ROUTER CONTROLLER UNIT TEST");
    $display("================================================");
    $display("");


    //////////////////////////////////////////////////////////
    // TEST 1 : RESET / NO REQUESTS
    //////////////////////////////////////////////////////////

    reset_dut;

    check_grants(
        5'b00000,
        5'b00000,
        5'b00000,
        5'b00000,
        5'b00000
    );


    //////////////////////////////////////////////////////////
    // TEST 2 : ONE REQUEST PER DIRECTION
    //////////////////////////////////////////////////////////

    reset_dut;

    request = 5'b11111;

    dir0 = `LOCAL;
    dir1 = `NORTH;
    dir2 = `SOUTH;
    dir3 = `EAST;
    dir4 = `WEST;

    #5;

    check_grants(
        5'b00001,
        5'b00010,
        5'b00100,
        5'b01000,
        5'b10000
    );


    //////////////////////////////////////////////////////////
    // TEST 3 : MULTIPLE LOCAL REQUESTS
    //////////////////////////////////////////////////////////

    reset_dut;

    request = 5'b10101;

    dir0 = `LOCAL;
    dir1 = `NORTH;
    dir2 = `LOCAL;
    dir3 = `EAST;
    dir4 = `LOCAL;

    #5;

    check_grants(
        5'b00001,
        5'b00000,
        5'b00000,
        5'b00000,
        5'b00000
    );


    //////////////////////////////////////////////////////////
    // TEST 4 : MULTIPLE NORTH REQUESTS
    //////////////////////////////////////////////////////////

    reset_dut;

    request = 5'b01110;

    dir0 = `WEST;
    dir1 = `NORTH;
    dir2 = `NORTH;
    dir3 = `NORTH;
    dir4 = `LOCAL;

    #5;

    check_grants(
        5'b00000,
        5'b00010,
        5'b00000,
        5'b00000,
        5'b00000
    );


    //////////////////////////////////////////////////////////
    // TEST 5 : ALL SOUTH REQUESTS
    //////////////////////////////////////////////////////////

    reset_dut;

    request = 5'b11111;

    dir0 = `SOUTH;
    dir1 = `SOUTH;
    dir2 = `SOUTH;
    dir3 = `SOUTH;
    dir4 = `SOUTH;

    #5;

    check_grants(
        5'b00000,
        5'b00000,
        5'b00001,
        5'b00000,
        5'b00000
    );


    //////////////////////////////////////////////////////////
    // TEST 6 : MIXED REQUESTS
    //
    // request = 11011
    //
    // input 0 -> EAST
    // input 1 -> WEST
    // input 2 -> inactive
    // input 3 -> WEST
    // input 4 -> EAST
    //
    // Therefore:
    //
    // EAST = 00001
    // WEST = 00010
    //////////////////////////////////////////////////////////

    reset_dut;

    request = 5'b11011;

    dir0 = `EAST;
    dir1 = `WEST;
    dir2 = `LOCAL;
    dir3 = `WEST;
    dir4 = `EAST;

    @(posedge clk);
    #2;

    check_grants(
        5'b00000,
        5'b00000,
        5'b00000,
        5'b00001,
        5'b00010
    );


   //////////////////////////////////////////////////////////
// TEST 7 : CLEAR REQUESTS
//////////////////////////////////////////////////////////

request = 5'b00000;

// Wait for the next clocked arbitration cycle
@(posedge clk);
#2;

check_grants(
    5'b00000,
    5'b00000,
    5'b00000,
    5'b00000,
    5'b00000
);

    //////////////////////////////////////////////////////////
    // RESULT
    //////////////////////////////////////////////////////////

    $display("");
    $display("================================================");
    $display("TESTS RUN    : %0d", tests_run);
    $display("TESTS PASSED : %0d", tests_passed);
    $display("TESTS FAILED : %0d", tests_failed);
    $display("================================================");

    if (tests_failed == 0)
        $display("RESULT : ALL ROUTER CONTROLLER TESTS PASSED");
    else
        $display("RESULT : %0d ROUTER CONTROLLER TESTS FAILED",
                 tests_failed);

    $display("================================================");
    $display("");

    $finish;

end

endmodule