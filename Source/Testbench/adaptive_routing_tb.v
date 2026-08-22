`timescale 1ns / 1ps

module adaptive_routing_tb;

reg [2:0] preferred_direction;
reg       congested;

reg north_busy;
reg south_busy;
reg east_busy;
reg west_busy;

wire [2:0] final_direction;

integer errors;

localparam LOCAL = 3'b000;
localparam NORTH = 3'b001;
localparam SOUTH = 3'b010;
localparam EAST  = 3'b011;
localparam WEST  = 3'b100;


/*===========================================================
  DUT
===========================================================*/

adaptive_routing DUT
(
    .preferred_direction(preferred_direction),
    .congested(congested),

    .north_busy(north_busy),
    .south_busy(south_busy),
    .east_busy(east_busy),
    .west_busy(west_busy),

    .final_direction(final_direction)
);


/*===========================================================
  Initialize
===========================================================*/

task initialize;
begin

    preferred_direction = LOCAL;
    congested = 1'b0;

    north_busy = 1'b0;
    south_busy = 1'b0;
    east_busy  = 1'b0;
    west_busy  = 1'b0;

end
endtask


/*===========================================================
  Check result
===========================================================*/

task check_result;

input [2:0] expected;
input [127:0] test_name;

begin

    #1;

    if (final_direction !== expected)
    begin
        $display("FAIL: %s", test_name);
        $display("      Expected = %03b", expected);
        $display("      Actual   = %03b", final_direction);

        errors = errors + 1;
    end
    else
    begin
        $display("PASS: %s", test_name);
    end

end
endtask


/*===========================================================
  TEST 1
  Preferred direction available
===========================================================*/

task test_preferred_available;
begin

    initialize;

    preferred_direction = EAST;
    congested = 1'b0;

    check_result(
        EAST,
        "Preferred EAST available"
    );

end
endtask


/*===========================================================
  TEST 2
  NORTH congested
  SOUTH available
===========================================================*/

task test_north_congested;
begin

    initialize;

    preferred_direction = NORTH;
    congested = 1'b1;

    north_busy = 1'b1;
    south_busy = 1'b0;
    east_busy  = 1'b0;
    west_busy  = 1'b0;

    check_result(
        SOUTH,
        "NORTH congested -> SOUTH fallback"
    );

end
endtask


/*===========================================================
  TEST 3
  SOUTH congested
  NORTH available
===========================================================*/

task test_south_congested;
begin

    initialize;

    preferred_direction = SOUTH;
    congested = 1'b1;

    north_busy = 1'b0;
    south_busy = 1'b1;
    east_busy  = 1'b0;
    west_busy  = 1'b0;

    check_result(
        NORTH,
        "SOUTH congested -> NORTH fallback"
    );

end
endtask


/*===========================================================
  TEST 4
  EAST congested
  NORTH available
===========================================================*/

task test_east_congested;
begin

    initialize;

    preferred_direction = EAST;
    congested = 1'b1;

    north_busy = 1'b0;
    south_busy = 1'b0;
    east_busy  = 1'b1;
    west_busy  = 1'b0;

    check_result(
        NORTH,
        "EAST congested -> NORTH fallback"
    );

end
endtask


/*===========================================================
  TEST 5
  WEST congested
  NORTH available
===========================================================*/

task test_west_congested;
begin

    initialize;

    preferred_direction = WEST;
    congested = 1'b1;

    north_busy = 1'b0;
    south_busy = 1'b0;
    east_busy  = 1'b0;
    west_busy  = 1'b1;

    check_result(
        NORTH,
        "WEST congested -> NORTH fallback"
    );

end
endtask


/*===========================================================
  TEST 6
  NORTH and SOUTH busy
  EAST available
===========================================================*/

task test_north_south_busy;
begin

    initialize;

    preferred_direction = NORTH;
    congested = 1'b1;

    north_busy = 1'b1;
    south_busy = 1'b1;
    east_busy  = 1'b0;
    west_busy  = 1'b0;

    check_result(
        EAST,
        "NORTH/SOUTH busy -> EAST fallback"
    );

end
endtask


/*===========================================================
  TEST 7
  NORTH/SOUTH/EAST busy
  WEST available
===========================================================*/

task test_three_busy;
begin

    initialize;

    preferred_direction = EAST;
    congested = 1'b1;

    north_busy = 1'b1;
    south_busy = 1'b1;
    east_busy  = 1'b1;
    west_busy  = 1'b0;

    check_result(
        WEST,
        "Three directions busy -> WEST fallback"
    );

end
endtask


/*===========================================================
  TEST 8
  All directions busy
  Should preserve preferred direction
===========================================================*/

task test_all_busy;
begin

    initialize;

    preferred_direction = EAST;
    congested = 1'b1;

    north_busy = 1'b1;
    south_busy = 1'b1;
    east_busy  = 1'b1;
    west_busy  = 1'b1;

    check_result(
        EAST,
        "All directions busy -> preferred direction"
    );

end
endtask


/*===========================================================
  TEST 9
  congested = 1 but NORTH available
===========================================================*/

task test_north_priority;
begin

    initialize;

    preferred_direction = WEST;
    congested = 1'b1;

    north_busy = 1'b0;
    south_busy = 1'b0;
    east_busy  = 1'b0;
    west_busy  = 1'b0;

    check_result(
        NORTH,
        "Multiple alternatives -> NORTH priority"
    );

end
endtask


/*===========================================================
  TEST 10
  Preferred LOCAL and not congested
===========================================================*/

task test_local;
begin

    initialize;

    preferred_direction = LOCAL;
    congested = 1'b0;

    check_result(
        LOCAL,
        "LOCAL preferred and available"
    );

end
endtask


/*===========================================================
  MAIN
===========================================================*/

initial
begin

    errors = 0;

    $display("");
    $display("================================================");
    $display("       ADAPTIVE ROUTING UNIT TEST");
    $display("================================================");
    $display("");

    test_preferred_available;

    test_north_congested;
    test_south_congested;
    test_east_congested;
    test_west_congested;

    test_north_south_busy;
    test_three_busy;

    test_all_busy;

    test_north_priority;

    test_local;

    $display("");
    $display("================================================");

    if (errors == 0)
    begin
        $display("RESULT : ALL ADAPTIVE ROUTING TESTS PASSED");
    end
    else
    begin
        $display("RESULT : %0d TESTS FAILED", errors);
    end

    $display("================================================");
    $display("");

    $finish;

end

endmodule