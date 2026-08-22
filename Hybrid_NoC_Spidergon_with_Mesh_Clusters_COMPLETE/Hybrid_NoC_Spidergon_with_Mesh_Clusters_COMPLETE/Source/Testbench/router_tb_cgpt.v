`timescale 1ns/1ps
`include "noc_defines.vh"

module router_tb;

//////////////////////////////////////////////////////////////
// Clock & Reset
//////////////////////////////////////////////////////////////

reg clk;
reg rst;

always #5 clk = ~clk;

//////////////////////////////////////////////////////////////
// Router Inputs
//////////////////////////////////////////////////////////////

reg [`PACKET_WIDTH-1:0] local_packet_in;
reg [`PACKET_WIDTH-1:0] north_packet_in;
reg [`PACKET_WIDTH-1:0] south_packet_in;
reg [`PACKET_WIDTH-1:0] east_packet_in;
reg [`PACKET_WIDTH-1:0] west_packet_in;

reg local_write;
reg north_write;
reg south_write;
reg east_write;
reg west_write;

reg [`CLUSTER_BITS-1:0] my_cluster;
reg [`ROW_BITS-1:0] my_row;
reg [`COL_BITS-1:0] my_col;

reg local_busy;
reg north_busy;
reg south_busy;
reg east_busy;
reg west_busy;

//////////////////////////////////////////////////////////////
// Router Outputs
//////////////////////////////////////////////////////////////

wire [`PACKET_WIDTH-1:0] local_packet_out;
wire [`PACKET_WIDTH-1:0] north_packet_out;
wire [`PACKET_WIDTH-1:0] south_packet_out;
wire [`PACKET_WIDTH-1:0] east_packet_out;
wire [`PACKET_WIDTH-1:0] west_packet_out;

wire local_valid;
wire north_valid;
wire south_valid;
wire east_valid;
wire west_valid;

wire local_full;
wire north_full;
wire south_full;
wire east_full;
wire west_full;

//////////////////////////////////////////////////////////////
// Statistics
//////////////////////////////////////////////////////////////

integer tests_run    = 0;
integer tests_passed = 0;
integer tests_failed = 0;

//////////////////////////////////////////////////////////////
// DUT
//////////////////////////////////////////////////////////////

router DUT
(
.local_ready(1'b1),
.north_ready(1'b1),
.south_ready(1'b1),
.east_ready(1'b1),
.west_ready(1'b1),
    .clk(clk),
    .rst(rst),

    .local_packet_in(local_packet_in),
    .north_packet_in(north_packet_in),
    .south_packet_in(south_packet_in),
    .east_packet_in(east_packet_in),
    .west_packet_in(west_packet_in),

    .local_write(local_write),
    .north_write(north_write),
    .south_write(south_write),
    .east_write(east_write),
    .west_write(west_write),

    .my_cluster(my_cluster),
    .my_row(my_row),
    .my_col(my_col),

    .local_busy(local_busy),
    .north_busy(north_busy),
    .south_busy(south_busy),
    .east_busy(east_busy),
    .west_busy(west_busy),

    .local_packet_out(local_packet_out),
    .north_packet_out(north_packet_out),
    .south_packet_out(south_packet_out),
    .east_packet_out(east_packet_out),
    .west_packet_out(west_packet_out),

    .local_valid(local_valid),
    .north_valid(north_valid),
    .south_valid(south_valid),
    .east_valid(east_valid),
    .west_valid(west_valid),

    .local_full(local_full),
    .north_full(north_full),
    .south_full(south_full),
    .east_full(east_full),
    .west_full(west_full)
);

//////////////////////////////////////////////////////////////
// Packet Builder
//////////////////////////////////////////////////////////////

function [`PACKET_WIDTH-1:0] make_packet;

input [`CLUSTER_BITS-1:0] dst_cluster;
input [`ROW_BITS-1:0]     dst_row;
input [`COL_BITS-1:0]     dst_col;

input [`CLUSTER_BITS-1:0] src_cluster;
input [`ROW_BITS-1:0]     src_row;
input [`COL_BITS-1:0]     src_col;

input [`TYPE_BITS-1:0] type;
input [`PRIORITY_BITS-1:0] priority;

input [`PAYLOAD_BITS-1:0] payload;

begin

    make_packet =
    {
        dst_cluster,
        dst_row,
        dst_col,

        src_cluster,
        src_row,
        src_col,

        type,
        priority,

        payload
    };

end

endfunction

//////////////////////////////////////////////////////////////
// Wait N clocks
//////////////////////////////////////////////////////////////

task wait_cycles;

input integer N;
integer i;

begin

    for(i=0;i<N;i=i+1)
        @(posedge clk);

end

endtask;

//////////////////////////////////////////////////////////////
// Send Packet : LOCAL
//////////////////////////////////////////////////////////////

task send_local;

input [`PACKET_WIDTH-1:0] pkt;

begin

    @(negedge clk);

    local_packet_in = pkt;
    local_write     = 1;

    @(negedge clk);

    local_write     = 0;

end

endtask

//////////////////////////////////////////////////////////////
// Send Packet : NORTH
//////////////////////////////////////////////////////////////

task send_north;

input [`PACKET_WIDTH-1:0] pkt;

begin

    @(negedge clk);

    north_packet_in = pkt;
    north_write     = 1;

    @(negedge clk);

    north_write     = 0;

end

endtask

//////////////////////////////////////////////////////////////
// Send Packet : SOUTH
//////////////////////////////////////////////////////////////

task send_south;

input [`PACKET_WIDTH-1:0] pkt;

begin

    @(negedge clk);

    south_packet_in = pkt;
    south_write     = 1;

    @(negedge clk);

    south_write     = 0;

end

endtask

//////////////////////////////////////////////////////////////
// Send Packet : EAST
//////////////////////////////////////////////////////////////

task send_east;

input [`PACKET_WIDTH-1:0] pkt;

begin

    @(negedge clk);

    east_packet_in = pkt;
    east_write     = 1;

    @(negedge clk);

    east_write     = 0;

end

endtask

//////////////////////////////////////////////////////////////
// Send Packet : WEST
//////////////////////////////////////////////////////////////

task send_west;

input [`PACKET_WIDTH-1:0] pkt;

begin

    @(negedge clk);

    west_packet_in = pkt;
    west_write     = 1;

    @(negedge clk);

    west_write     = 0;

end

endtask

//////////////////////////////////////////////////////////////
// Monitor Every Output Packet
//////////////////////////////////////////////////////////////

always @(posedge clk)
begin

    if(local_valid)
        $display("[%0t] LOCAL OUT  : %h",$time,local_packet_out);

    if(north_valid)
        $display("[%0t] NORTH OUT  : %h",$time,north_packet_out);

    if(south_valid)
        $display("[%0t] SOUTH OUT  : %h",$time,south_packet_out);

    if(east_valid)
        $display("[%0t] EAST OUT   : %h",$time,east_packet_out);

    if(west_valid)
        $display("[%0t] WEST OUT   : %h",$time,west_packet_out);

end;

//////////////////////////////////////////////////////////////
// Internal Router Monitor
//////////////////////////////////////////////////////////////

always @(posedge clk)
begin

$display("------------------------------------------------");

$display("TIME = %0t",$time);

$display("Requests");

$display("LOCAL  : %b",DUT.request0);
$display("NORTH  : %b",DUT.request1);
$display("SOUTH  : %b",DUT.request2);
$display("EAST   : %b",DUT.request3);
$display("WEST   : %b",DUT.request4);

$display("");

$display("Directions");
/*
$display("DIR0 = %0d",DUT.dir0);
$display("DIR1 = %0d",DUT.dir1);
$display("DIR2 = %0d",DUT.dir2);
$display("DIR3 = %0d",DUT.dir3);
$display("DIR4 = %0d",DUT.dir4);
*/
$display("");

$display("Read Enables");

$display("%b %b %b %b %b",
DUT.read_enable0,
DUT.read_enable1,
DUT.read_enable2,
DUT.read_enable3,
DUT.read_enable4);

$display("");

$display("Write Enables");

$display("%b %b %b %b %b",
DUT.write_enable0,
DUT.write_enable1,
DUT.write_enable2,
DUT.write_enable3,
DUT.write_enable4);

$display("");

$display("Input Packets");

$display("%h",DUT.in_packet0);
$display("%h",DUT.in_packet1);
$display("%h",DUT.in_packet2);
$display("%h",DUT.in_packet3);
$display("%h",DUT.in_packet4);

$display("");

$display("Crossbar Outputs");
$display("Crossbar internal outputs not directly monitored");
/*
$display("%h",DUT.out_packet0);
$display("%h",DUT.out_packet1);
$display("%h",DUT.out_packet2);
$display("%h",DUT.out_packet3);
$display("%h",DUT.out_packet4);
*/
$display("");

end;

//////////////////////////////////////////////////////////////
// PASS
//////////////////////////////////////////////////////////////

task pass;

input [200*8:1] message;

begin

tests_run = tests_run + 1;
tests_passed = tests_passed + 1;

$display("");
$display("==============================================");
$display("PASS : %0s",message);
$display("==============================================");
$display("");

end

endtask

//////////////////////////////////////////////////////////////
// FAIL
//////////////////////////////////////////////////////////////

task fail;

input [200*8:1] message;

begin

tests_run = tests_run + 1;
tests_failed = tests_failed + 1;

$display("");
$display("==============================================");
$display("FAIL : %0s",message);
$display("==============================================");
$display("");

end

endtask

//////////////////////////////////////////////////////////////
// Check Output Packet
//////////////////////////////////////////////////////////////

task check_packet;

input [2:0] expected_port;
input [`PACKET_WIDTH-1:0] expected_packet;

begin

wait_cycles(10);

case(expected_port)

3'd0:
begin

if(local_valid && local_packet_out==expected_packet)
    pass("LOCAL OUTPUT");
else
begin
    fail("LOCAL OUTPUT");

    $display("Expected : %h",expected_packet);
    $display("Received : %h",local_packet_out);

end

end

3'd1:
begin

if(north_valid && north_packet_out==expected_packet)
    pass("NORTH OUTPUT");
else
begin
    fail("NORTH OUTPUT");

    $display("Expected : %h",expected_packet);
    $display("Received : %h",north_packet_out);

end

end

3'd2:
begin

if(south_valid && south_packet_out==expected_packet)
    pass("SOUTH OUTPUT");
else
begin
    fail("SOUTH OUTPUT");

    $display("Expected : %h",expected_packet);
    $display("Received : %h",south_packet_out);

end

end

3'd3:
begin

if(east_valid && east_packet_out==expected_packet)
    pass("EAST OUTPUT");
else
begin
    fail("EAST OUTPUT");

    $display("Expected : %h",expected_packet);
    $display("Received : %h",east_packet_out);

end

end

3'd4:
begin

if(west_valid && west_packet_out==expected_packet)
    pass("WEST OUTPUT");
else
begin
    fail("WEST OUTPUT");

    $display("Expected : %h",expected_packet);
    $display("Received : %h",west_packet_out);

end

end

default:
begin
fail("INVALID EXPECTED PORT");
end

endcase

end

endtask

always @(posedge clk)
begin

$display("\n==================================================");
$display("TIME = %0t", $time);

$display("Input Packets");
$display("L=%h", DUT.in_packet0);
$display("N=%h", DUT.in_packet1);
$display("S=%h", DUT.in_packet2);
$display("E=%h", DUT.in_packet3);
$display("W=%h", DUT.in_packet4);

$display("");

$display("Directions");
$display("%0d %0d %0d %0d %0d",
    DUT.direction0,
    DUT.direction1,
    DUT.direction2,
    DUT.direction3,
    DUT.direction4);

$display("");

$display("Requests");
$display("%b %b %b %b %b",
    DUT.request0,
    DUT.request1,
    DUT.request2,
    DUT.request3,
    DUT.request4);

$display("");

$display("Read Enables");
$display("%b %b %b %b %b",
    DUT.read_enable0,
    DUT.read_enable1,
    DUT.read_enable2,
    DUT.read_enable3,
    DUT.read_enable4);

$display("");

$display("Write Enables");
$display("%b %b %b %b %b",
    DUT.write_enable0,
    DUT.write_enable1,
    DUT.write_enable2,
    DUT.write_enable3,
    DUT.write_enable4);

$display("");

$display("Crossbar Outputs");
$display("L=%h", DUT.crossbar_out0);
$display("N=%h", DUT.crossbar_out1);
$display("S=%h", DUT.crossbar_out2);
$display("E=%h", DUT.crossbar_out3);
$display("W=%h", DUT.crossbar_out4);

$display("");

$display("Router Outputs");
$display("L=%h V=%b", local_packet_out, local_valid);
$display("N=%h V=%b", north_packet_out, north_valid);
$display("S=%h V=%b", south_packet_out, south_valid);
$display("E=%h V=%b", east_packet_out, east_valid);
$display("W=%h V=%b", west_packet_out, west_valid);

$display("==================================================");

end

//////////////////////////////////////////////////////////////
// MAIN TEST SEQUENCE
//////////////////////////////////////////////////////////////

initial
begin

    //----------------------------------------------------------
    // Initialize
    //----------------------------------------------------------

    clk = 0;
    rst = 1;

    local_packet_in = 0;
    north_packet_in = 0;
    south_packet_in = 0;
    east_packet_in  = 0;
    west_packet_in  = 0;

    local_write = 0;
    north_write = 0;
    south_write = 0;
    east_write  = 0;
    west_write  = 0;

    my_cluster = 0;
    my_row     = 0;
    my_col     = 0;

    local_busy = 0;
    north_busy = 0;
    south_busy = 0;
    east_busy  = 0;
    west_busy  = 0;

    //----------------------------------------------------------
    // Reset
    //----------------------------------------------------------

    repeat(5) @(posedge clk);

    rst = 0;

    repeat(5) @(posedge clk);

    $display("");
    $display("===========================================");
    $display("      ROUTER VERIFICATION STARTED");
    $display("===========================================");
    $display("");

    ////////////////////////////////////////////////////////////
    // TEST 1
    ////////////////////////////////////////////////////////////

    $display("\nTEST 1 : LOCAL INPUT");

    send_local(
        make_packet(
            2'd0,
            2'd1,
            2'd0,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h11111111
        )
    );

    wait_cycles(20);  
    $display("========== END OF TEST1 ==========");

    ////////////////////////////////////////////////////////////
    // TEST 2
    ////////////////////////////////////////////////////////////

    $display("\nTEST 2 : NORTH INPUT");

    send_north(
        make_packet(
            2'd0,
            2'd2,
            2'd1,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h22222222
        )
    );

    wait_cycles(20);

    ////////////////////////////////////////////////////////////
    // TEST 3
    ////////////////////////////////////////////////////////////

    $display("\nTEST 3 : SOUTH INPUT");

    send_south(
        make_packet(
            2'd0,
            2'd3,
            2'd1,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h33333333
        )
    );

    wait_cycles(20);

    ////////////////////////////////////////////////////////////
    // TEST 4
    ////////////////////////////////////////////////////////////

    $display("\nTEST 4 : EAST INPUT");

    send_east(
        make_packet(
            2'd0,
            2'd1,
            2'd2,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h44444444
        )
    );

    wait_cycles(20);

    ////////////////////////////////////////////////////////////
    // TEST 5
    ////////////////////////////////////////////////////////////

    $display("\nTEST 5 : WEST INPUT");

    send_west(
        make_packet(
            2'd0,
            2'd2,
            2'd3,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h55555555
        )
    );

    wait_cycles(20);

    ////////////////////////////////////////////////////////////
    // TEST 6 : Simultaneous Traffic
    ////////////////////////////////////////////////////////////

    $display("\nTEST 6 : SIMULTANEOUS INPUTS");

    fork
        send_local(make_packet(2'd0,2'd1,2'd1,2'd0,2'd0,2'd0,2'd0,2'd0,32'hAAAA0001));
        send_north(make_packet(2'd0,2'd2,2'd2,2'd0,2'd0,2'd0,2'd0,2'd0,32'hBBBB0002));
        send_south(make_packet(2'd0,2'd3,2'd3,2'd0,2'd0,2'd0,2'd0,2'd0,32'hCCCC0003));
        send_east (make_packet(2'd0,2'd1,2'd3,2'd0,2'd0,2'd0,2'd0,2'd0,32'hDDDD0004));
        send_west (make_packet(2'd0,2'd2,2'd1,2'd0,2'd0,2'd0,2'd0,2'd0,32'hEEEE0005));
    join

    wait_cycles(50);

    ////////////////////////////////////////////////////////////
    // TEST 7 : Congestion
    ////////////////////////////////////////////////////////////

    $display("\nTEST 7 : CONGESTION");

    east_busy  = 1;
    north_busy = 1;

    send_local(
        make_packet(
            2'd0,
            2'd2,
            2'd2,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h12345678
        )
    );

    wait_cycles(30);

    east_busy  = 0;
    north_busy = 0;

    wait_cycles(20);

    ////////////////////////////////////////////////////////////
    // SUMMARY
    ////////////////////////////////////////////////////////////

    $display("");
    $display("========================================");
    $display("SIMULATION COMPLETE");
    $display("========================================");

    $display("Tests Run    : %0d",tests_run);
    $display("Tests Passed : %0d",tests_passed);
    $display("Tests Failed : %0d",tests_failed);

    $display("========================================");

    #100;   

    $finish;

end

endmodule