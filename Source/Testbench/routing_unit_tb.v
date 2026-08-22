`timescale 1ns / 1ps

module routing_unit_tb;

reg [1:0] current_cluster;
reg [1:0] current_row;
reg [1:0] current_col;

reg [1:0] dest_cluster;
reg [1:0] dest_row;
reg [1:0] dest_col;

reg local_busy;
reg north_busy;
reg south_busy;
reg east_busy;
reg west_busy;

wire [2:0] final_direction;

integer errors;


/*
===========================================================
Direction Encoding
===========================================================
*/

localparam LOCAL = 3'b000;
localparam NORTH = 3'b001;
localparam SOUTH = 3'b010;
localparam EAST  = 3'b011;
localparam WEST  = 3'b100;


/*
===========================================================
DUT
===========================================================
*/

routing_unit DUT
(
    .current_cluster(current_cluster),
    .current_row(current_row),
    .current_col(current_col),

    .dest_cluster(dest_cluster),
    .dest_row(dest_row),
    .dest_col(dest_col),

    .local_busy(local_busy),
    .north_busy(north_busy),
    .south_busy(south_busy),
    .east_busy(east_busy),
    .west_busy(west_busy),

    .final_direction(final_direction)
);


/*
===========================================================
Initialize
===========================================================
*/

task initialize;
begin

    current_cluster = 2'd0;
    current_row     = 2'd0;
    current_col     = 2'd0;

    dest_cluster = 2'd0;
    dest_row     = 2'd0;
    dest_col     = 2'd0;

    local_busy = 1'b0;
    north_busy = 1'b0;
    south_busy = 1'b0;
    east_busy  = 1'b0;
    west_busy  = 1'b0;

end
endtask


/*
===========================================================
Check Direction
===========================================================
*/

task check_direction;

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


/*
===========================================================
TEST 1
Same cluster, same router
Expected LOCAL
===========================================================
*/

task test_local;
begin

    initialize;

    current_cluster = 2'd0;
    current_row     = 2'd0;
    current_col     = 2'd0;

    dest_cluster = 2'd0;
    dest_row     = 2'd0;
    dest_col     = 2'd0;

    check_direction(
        LOCAL,
        "LOCAL destination"
    );

end
endtask


/*
===========================================================
TEST 2
Same cluster, EAST
===========================================================
*/

task test_xy_east;
begin

    initialize;

    current_cluster = 2'd0;
    current_row     = 2'd0;
    current_col     = 2'd0;

    dest_cluster = 2'd0;
    dest_row     = 2'd0;
    dest_col     = 2'd1;

    check_direction(
        EAST,
        "XY EAST"
    );

end
endtask


/*
===========================================================
TEST 3
Same cluster, WEST
===========================================================
*/

task test_xy_west;
begin

    initialize;

    current_cluster = 2'd0;
    current_row     = 2'd0;
    current_col     = 2'd1;

    dest_cluster = 2'd0;
    dest_row     = 2'd0;
    dest_col     = 2'd0;

    check_direction(
        WEST,
        "XY WEST"
    );

end
endtask


/*
===========================================================
TEST 4
Same cluster, SOUTH
===========================================================
*/

task test_xy_south;
begin

    initialize;

    current_cluster = 2'd0;
    current_row     = 2'd0;
    current_col     = 2'd0;

    dest_cluster = 2'd0;
    dest_row     = 2'd1;
    dest_col     = 2'd0;

    check_direction(
        SOUTH,
        "XY SOUTH"
    );

end
endtask


/*
===========================================================
TEST 5
Same cluster, NORTH
===========================================================
*/

task test_xy_north;
begin

    initialize;

    current_cluster = 2'd0;
    current_row     = 2'd1;
    current_col     = 2'd0;

    dest_cluster = 2'd0;
    dest_row     = 2'd0;
    dest_col     = 2'd0;

    check_direction(
        NORTH,
        "XY NORTH"
    );

end
endtask


/*
===========================================================
TEST 6
Global: Cluster 0 -> Cluster 1
Expected EAST
===========================================================
*/

task test_global_0_to_1;
begin

    initialize;

    current_cluster = 2'd0;
    dest_cluster    = 2'd1;

    check_direction(
        EAST,
        "GLOBAL 0 -> 1"
    );

end
endtask


/*
===========================================================
TEST 7
Global: Cluster 1 -> Cluster 2
Expected SOUTH
===========================================================
*/

task test_global_1_to_2;
begin

    initialize;

    current_cluster = 2'd1;
    dest_cluster    = 2'd2;

    check_direction(
        SOUTH,
        "GLOBAL 1 -> 2"
    );

end
endtask


/*
===========================================================
TEST 8
Global: Cluster 2 -> Cluster 3
Expected WEST
===========================================================
*/

task test_global_2_to_3;
begin

    initialize;

    current_cluster = 2'd2;
    dest_cluster    = 2'd3;

    check_direction(
        WEST,
        "GLOBAL 2 -> 3"
    );

end
endtask


/*
===========================================================
TEST 9
Global: Cluster 3 -> Cluster 0
Expected NORTH
===========================================================
*/

task test_global_3_to_0;
begin

    initialize;

    current_cluster = 2'd3;
    dest_cluster    = 2'd0;

    check_direction(
        NORTH,
        "GLOBAL 3 -> 0"
    );

end
endtask


/*
===========================================================
TEST 10
Global route with unrelated congestion
===========================================================
*/

task test_global_unrelated_congestion;
begin

    initialize;

    current_cluster = 2'd0;
    dest_cluster    = 2'd1;

    north_busy = 1'b1;
    south_busy = 1'b1;
    west_busy  = 1'b1;

    check_direction(
        EAST,
        "GLOBAL EAST with other directions congested"
    );

end
endtask


/*
===========================================================
TEST 11
Preferred EAST congested
===========================================================
*/

task test_east_congestion;
begin

    initialize;

    current_cluster = 2'd0;
    dest_cluster    = 2'd0;

    current_row = 2'd0;
    current_col = 2'd0;

    dest_row = 2'd0;
    dest_col = 2'd1;

    east_busy = 1'b1;

    #1;

    $display("");
    $display("TEST 11 : EAST CONGESTION");
    $display("Preferred route = EAST");
    $display("Final direction = %03b", final_direction);

end
endtask


/*
===========================================================
TEST 12
All directions congested
===========================================================
*/

task test_all_congested;
begin

    initialize;

    current_cluster = 2'd0;
    dest_cluster    = 2'd0;

    current_row = 2'd0;
    current_col = 2'd0;

    dest_row = 2'd0;
    dest_col = 2'd1;

    local_busy = 1'b1;
    north_busy = 1'b1;
    south_busy = 1'b1;
    east_busy  = 1'b1;
    west_busy  = 1'b1;

    #1;

    $display("");
    $display("TEST 12 : ALL DIRECTIONS CONGESTED");
    $display("Final direction = %03b", final_direction);

end
endtask


/*
===========================================================
MAIN TEST
===========================================================
*/

initial
begin

    errors = 0;

    $display("");
    $display("================================================");
    $display("        ROUTING UNIT INTEGRATION TEST");
    $display("================================================");
    $display("");

    test_local;

    test_xy_east;
    test_xy_west;
    test_xy_south;
    test_xy_north;

    test_global_0_to_1;
    test_global_1_to_2;
    test_global_2_to_3;
    test_global_3_to_0;

    test_global_unrelated_congestion;

    test_east_congestion;

    test_all_congested;

    $display("");
    $display("================================================");

    if (errors == 0)
    begin
        $display("RESULT : ALL BASIC ROUTING TESTS PASSED");
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