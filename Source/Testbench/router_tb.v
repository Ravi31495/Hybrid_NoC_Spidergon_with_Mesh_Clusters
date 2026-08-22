`timescale 1ns / 1ps
`include "noc_defines.vh"

module router_tb;

reg clk;
reg rst;

//--------------------------------------------------
// Inputs
//--------------------------------------------------

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

//--------------------------------------------------
// Outputs
//--------------------------------------------------

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

//--------------------------------------------------
// DUT
//--------------------------------------------------

router DUT
(
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

//--------------------------------------------------
// Clock
//--------------------------------------------------

always #5 clk = ~clk;

//--------------------------------------------------
// Test
//--------------------------------------------------

initial
begin

    clk = 0;
    rst = 1;

    local_packet_in = 0;
    north_packet_in = 0;
    south_packet_in = 0;
    east_packet_in = 0;
    west_packet_in = 0;

    local_write = 0;
    north_write = 0;
    south_write = 0;
    east_write = 0;
    west_write = 0;

    my_cluster = 0;
    my_row = 0;
    my_col = 0;

    local_busy = 0;
    north_busy = 0;
    south_busy = 0;
    east_busy = 0;
    west_busy = 0;

    #20;
    rst = 0;

    //--------------------------------------------------
    // Test 1
    //--------------------------------------------------

    $display("TEST 1 : Local Packet");

    local_packet_in = 48'h110000000001;
    local_write = 1;

    #10;
    local_write = 0;

    #100;

    //--------------------------------------------------
    // Test 2
    //--------------------------------------------------

    $display("TEST 2 : North Packet");

    north_packet_in = 48'h220000000002;
    north_write = 1;

    #10;
    north_write = 0;

    #100;

    //--------------------------------------------------
    // Test 3
    //--------------------------------------------------

    $display("TEST 3 : East Packet");

    east_packet_in = 48'h330000000003;
    east_write = 1;

    #10;
    east_write = 0;

    #100;

    //--------------------------------------------------
    // Test 4
    //--------------------------------------------------

    $display("TEST 4 : Simultaneous Inputs");

    local_packet_in = 48'hAAAAAAAAAAAA;
    north_packet_in = 48'hBBBBBBBBBBBB;
    south_packet_in = 48'hCCCCCCCCCCCC;
    east_packet_in  = 48'hDDDDDDDDDDDD;
    west_packet_in  = 48'hEEEEEEEEEEEE;

    local_write = 1;
    north_write = 1;
    south_write = 1;
    east_write = 1;
    west_write = 1;

    #10;

    local_write = 0;
    north_write = 0;
    south_write = 0;
    east_write = 0;
    west_write = 0;

    #200;

    //--------------------------------------------------
    // Test 5
    //--------------------------------------------------

    $display("TEST 5 : Congestion");

    east_busy = 1;
    north_busy = 1;

    local_packet_in = 48'h123456789ABC;
    local_write = 1;

    #10;
    local_write = 0;

    #100;

    east_busy = 0;
    north_busy = 0;

    #200;

    $display("Simulation Finished");
    $finish;

end

endmodule