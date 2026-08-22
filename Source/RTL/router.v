`timescale 1ns / 1ps
`include "noc_defines.vh"

module router
(
    input clk,
    input rst,

    //-------------------------------------------------
    // Incoming packets
    //-------------------------------------------------
    input [`PACKET_WIDTH-1:0] local_packet_in,
    input [`PACKET_WIDTH-1:0] north_packet_in,
    input [`PACKET_WIDTH-1:0] south_packet_in,
    input [`PACKET_WIDTH-1:0] east_packet_in,
    input [`PACKET_WIDTH-1:0] west_packet_in,
    input [`PACKET_WIDTH-1:0] gateway_packet_in,

    //-------------------------------------------------
    // Write enables
    //-------------------------------------------------
    input local_write,
    input north_write,
    input south_write,
    input east_write,
    input west_write,
    input gateway_write,

    //-------------------------------------------------
    // Router Coordinates
    //-------------------------------------------------
    input [`CLUSTER_BITS-1:0] my_cluster,
    input [`ROW_BITS-1:0] my_row,
    input [`COL_BITS-1:0] my_col,

    //-------------------------------------------------
    // Congestion Inputs
    //-------------------------------------------------
    input local_busy,
    input north_busy,
    input south_busy,
    input east_busy,
    input west_busy,
    input gateway_busy,

    //-------------------------------------------------
    // Downstream Ready Signals
    //-------------------------------------------------
    input local_ready,
    input north_ready,
    input south_ready,
    input east_ready,
    input west_ready,
    input gateway_ready,

    //-------------------------------------------------
    // Outgoing packets
    //-------------------------------------------------
    output [`PACKET_WIDTH-1:0] local_packet_out,
    output [`PACKET_WIDTH-1:0] north_packet_out,
    output [`PACKET_WIDTH-1:0] south_packet_out,
    output [`PACKET_WIDTH-1:0] east_packet_out,
    output [`PACKET_WIDTH-1:0] west_packet_out,
    output [`PACKET_WIDTH-1:0] gateway_packet_out,

    //-------------------------------------------------
    // Packet Valid
    //-------------------------------------------------
    output local_valid,
    output north_valid,
    output south_valid,
    output east_valid,
    output west_valid,
    output gateway_valid,

    //-------------------------------------------------
    // Output FIFO Full
    //-------------------------------------------------
    output local_full,
    output north_full,
    output south_full,
    output east_full,
    output west_full,
    output gateway_full
);

//////////////////////////////////////////////////////
// Internal Wires
//////////////////////////////////////////////////////

//----------------------------------------------------
// Input Port Outputs
//----------------------------------------------------

wire [`PACKET_WIDTH-1:0] in_packet0;
wire [`PACKET_WIDTH-1:0] in_packet1;
wire [`PACKET_WIDTH-1:0] in_packet2;
wire [`PACKET_WIDTH-1:0] in_packet3;
wire [`PACKET_WIDTH-1:0] in_packet4;
wire [`PACKET_WIDTH-1:0] in_packet5;

wire [2:0] direction0;
wire [2:0] direction1;
wire [2:0] direction2;
wire [2:0] direction3;
wire [2:0] direction4;
wire [2:0] direction5;

wire request0;
wire request1;
wire request2;
wire request3;
wire request4;
wire request5;

wire valid0;
wire valid1;
wire valid2;
wire valid3;
wire valid4;
wire valid5;

wire input_empty0;
wire input_empty1;
wire input_empty2;
wire input_empty3;
wire input_empty4;
wire input_empty5;

wire input_full0;
wire input_full1;
wire input_full2;
wire input_full3;
wire input_full4;
wire input_full5;

//////////////////////////////////////////////////////
// Input Port Read Enables
//////////////////////////////////////////////////////

wire read_enable0;
wire read_enable1;
wire read_enable2;
wire read_enable3;
wire read_enable4;
wire read_enable5;

//////////////////////////////////////////////////////
// Input Port Instantiations
//////////////////////////////////////////////////////

//----------------------------------------------------
// LOCAL INPUT = PORT 0
//----------------------------------------------------

input_port INPUT_PORT_LOCAL
(
    .clk(clk),
    .rst(rst),

    .packet_in(local_packet_in),
    .packet_valid(local_write),
    .read_enable(read_enable0),

    .my_cluster(my_cluster),
    .my_row(my_row),
    .my_col(my_col),

    .local_busy(local_busy),
    .north_busy(north_busy),
    .south_busy(south_busy),
    .east_busy(east_busy),
    .west_busy(west_busy),

    .packet_out(in_packet0),
    .direction(direction0),

    .request(request0),
    .packet_valid_out(valid0),

    .empty(input_empty0),
    .full(input_full0)
);


//----------------------------------------------------
// NORTH INPUT = PORT 1
//----------------------------------------------------

input_port INPUT_PORT_NORTH
(
    .clk(clk),
    .rst(rst),

    .packet_in(north_packet_in),
    .packet_valid(north_write),
    .read_enable(read_enable1),

    .my_cluster(my_cluster),
    .my_row(my_row),
    .my_col(my_col),

    .local_busy(local_busy),
    .north_busy(north_busy),
    .south_busy(south_busy),
    .east_busy(east_busy),
    .west_busy(west_busy),

    .packet_out(in_packet1),
    .direction(direction1),

    .request(request1),
    .packet_valid_out(valid1),

    .empty(input_empty1),
    .full(input_full1)
);


//----------------------------------------------------
// SOUTH INPUT = PORT 2
//----------------------------------------------------

input_port INPUT_PORT_SOUTH
(
    .clk(clk),
    .rst(rst),

    .packet_in(south_packet_in),
    .packet_valid(south_write),
    .read_enable(read_enable2),

    .my_cluster(my_cluster),
    .my_row(my_row),
    .my_col(my_col),

    .local_busy(local_busy),
    .north_busy(north_busy),
    .south_busy(south_busy),
    .east_busy(east_busy),
    .west_busy(west_busy),

    .packet_out(in_packet2),
    .direction(direction2),

    .request(request2),
    .packet_valid_out(valid2),

    .empty(input_empty2),
    .full(input_full2)
);


//----------------------------------------------------
// EAST INPUT = PORT 3
//----------------------------------------------------

input_port INPUT_PORT_EAST
(
    .clk(clk),
    .rst(rst),

    .packet_in(east_packet_in),
    .packet_valid(east_write),
    .read_enable(read_enable3),

    .my_cluster(my_cluster),
    .my_row(my_row),
    .my_col(my_col),

    .local_busy(local_busy),
    .north_busy(north_busy),
    .south_busy(south_busy),
    .east_busy(east_busy),
    .west_busy(west_busy),

    .packet_out(in_packet3),
    .direction(direction3),

    .request(request3),
    .packet_valid_out(valid3),

    .empty(input_empty3),
    .full(input_full3)
);


//----------------------------------------------------
// WEST INPUT = PORT 4
//----------------------------------------------------

input_port INPUT_PORT_WEST
(
    .clk(clk),
    .rst(rst),

    .packet_in(west_packet_in),
    .packet_valid(west_write),
    .read_enable(read_enable4),

    .my_cluster(my_cluster),
    .my_row(my_row),
    .my_col(my_col),

    .local_busy(local_busy),
    .north_busy(north_busy),
    .south_busy(south_busy),
    .east_busy(east_busy),
    .west_busy(west_busy),

    .packet_out(in_packet4),
    .direction(direction4),

    .request(request4),
    .packet_valid_out(valid4),

    .empty(input_empty4),
    .full(input_full4)
);


//----------------------------------------------------
// GATEWAY INPUT = PORT 5
//
// The existing input_port does not have a separate
// gateway_busy input, so the normal five-direction
// congestion information is used here.
//----------------------------------------------------

input_port INPUT_PORT_GATEWAY
(
    .clk(clk),
    .rst(rst),

    .packet_in(gateway_packet_in),
    .packet_valid(gateway_write),
    .read_enable(read_enable5),

    .my_cluster(my_cluster),
    .my_row(my_row),
    .my_col(my_col),

    .local_busy(local_busy),
    .north_busy(north_busy),
    .south_busy(south_busy),
    .east_busy(east_busy),
    .west_busy(west_busy),

    .packet_out(in_packet5),
    .direction(direction5),

    .request(request5),
    .packet_valid_out(valid5),

    .empty(input_empty5),
    .full(input_full5)
);


//////////////////////////////////////////////////////
// Router Controller Wires
//////////////////////////////////////////////////////

//----------------------------------------------------
// Six-Port Arbiter Grants
//----------------------------------------------------

wire [5:0] local_grant;
wire [5:0] north_grant;
wire [5:0] south_grant;
wire [5:0] east_grant;
wire [5:0] west_grant;
wire [5:0] gateway_grant;


//----------------------------------------------------
// Router Control Logic Selects
//----------------------------------------------------

wire [2:0] sel0;
wire [2:0] sel1;
wire [2:0] sel2;
wire [2:0] sel3;
wire [2:0] sel4;
wire [2:0] sel5;


//----------------------------------------------------
// Output FIFO Write Enables
//----------------------------------------------------

wire write_enable0;
wire write_enable1;
wire write_enable2;
wire write_enable3;
wire write_enable4;
wire write_enable5;


//----------------------------------------------------
// Output FIFO Read Enables
//----------------------------------------------------

wire read_out0;
wire read_out1;
wire read_out2;
wire read_out3;
wire read_out4;
wire read_out5;


//////////////////////////////////////////////////////
// Request Bus
//////////////////////////////////////////////////////

wire [5:0] request_bus;

assign request_bus =
{
    request5,
    request4,
    request3,
    request2,
    request1,
    request0
};


//////////////////////////////////////////////////////
// Router Controller
//////////////////////////////////////////////////////

router_controller ROUTER_CONTROLLER
(
    .clk(clk),
    .rst(rst),

    .request(request_bus),

    .dir0(direction0),
    .dir1(direction1),
    .dir2(direction2),
    .dir3(direction3),
    .dir4(direction4),
    .dir5(direction5),
    

    .local_grant(local_grant),
    .north_grant(north_grant),
    .south_grant(south_grant),
    .east_grant(east_grant),
    .west_grant(west_grant),
    .gateway_grant(gateway_grant)
);


//////////////////////////////////////////////////////
// Router Control Logic
//////////////////////////////////////////////////////

router_control_logic ROUTER_CONTROL_LOGIC
(
    .clk(clk),
    .rst(rst),

    .local_ready(local_ready),
    .north_ready(north_ready),
    .south_ready(south_ready),
    .east_ready(east_ready),
    .west_ready(west_ready),
    .gateway_ready(gateway_ready),

    .local_grant(local_grant),
    .north_grant(north_grant),
    .south_grant(south_grant),
    .east_grant(east_grant),
    .west_grant(west_grant),
    .gateway_grant(gateway_grant),

    .sel0(sel0),
    .sel1(sel1),
    .sel2(sel2),
    .sel3(sel3),
    .sel4(sel4),
    .sel5(sel5),

    .read_enable0(read_enable0),
    .read_enable1(read_enable1),
    .read_enable2(read_enable2),
    .read_enable3(read_enable3),
    .read_enable4(read_enable4),
    .read_enable5(read_enable5),

    .write_enable0(write_enable0),
    .write_enable1(write_enable1),
    .write_enable2(write_enable2),
    .write_enable3(write_enable3),
    .write_enable4(write_enable4),
    .write_enable5(write_enable5),

    .read_out0(read_out0),
    .read_out1(read_out1),
    .read_out2(read_out2),
    .read_out3(read_out3),
    .read_out4(read_out4),
    .read_out5(read_out5)
);


//////////////////////////////////////////////////////
// Crossbar Output Wires
//////////////////////////////////////////////////////

wire [`PACKET_WIDTH-1:0] crossbar_out0;
wire [`PACKET_WIDTH-1:0] crossbar_out1;
wire [`PACKET_WIDTH-1:0] crossbar_out2;
wire [`PACKET_WIDTH-1:0] crossbar_out3;
wire [`PACKET_WIDTH-1:0] crossbar_out4;
wire [`PACKET_WIDTH-1:0] crossbar_out5;


//////////////////////////////////////////////////////
// Six-Port Crossbar
//////////////////////////////////////////////////////

crossbar_switch CROSSBAR_SWITCH
(
    .in0(in_packet0),
    .in1(in_packet1),
    .in2(in_packet2),
    .in3(in_packet3),
    .in4(in_packet4),
    .in5(in_packet5),

    .sel0(sel0),
    .sel1(sel1),
    .sel2(sel2),
    .sel3(sel3),
    .sel4(sel4),
    .sel5(sel5),

    .out0(crossbar_out0),
    .out1(crossbar_out1),
    .out2(crossbar_out2),
    .out3(crossbar_out3),
    .out4(crossbar_out4),
    .out5(crossbar_out5)
);


//////////////////////////////////////////////////////
// OUTPUT PORT 0 - LOCAL
//////////////////////////////////////////////////////

output_port OUTPUT_PORT_LOCAL
(
    .clk(clk),
    .rst(rst),

    .packet_in(crossbar_out0),

    .write_en(write_enable0),
    .read_en(read_out0),

    .packet_out(local_packet_out),
    .packet_valid(local_valid),

    .full(local_full),
    .empty()
);


//////////////////////////////////////////////////////
// OUTPUT PORT 1 - NORTH
//////////////////////////////////////////////////////

output_port OUTPUT_PORT_NORTH
(
    .clk(clk),
    .rst(rst),

    .packet_in(crossbar_out1),

    .write_en(write_enable1),
    .read_en(read_out1),

    .packet_out(north_packet_out),
    .packet_valid(north_valid),

    .full(north_full),
    .empty()
);


//////////////////////////////////////////////////////
// OUTPUT PORT 2 - SOUTH
//////////////////////////////////////////////////////

output_port OUTPUT_PORT_SOUTH
(
    .clk(clk),
    .rst(rst),

    .packet_in(crossbar_out2),

    .write_en(write_enable2),
    .read_en(read_out2),

    .packet_out(south_packet_out),
    .packet_valid(south_valid),

    .full(south_full),
    .empty()
);


//////////////////////////////////////////////////////
// OUTPUT PORT 3 - EAST
//////////////////////////////////////////////////////

output_port OUTPUT_PORT_EAST
(
    .clk(clk),
    .rst(rst),

    .packet_in(crossbar_out3),

    .write_en(write_enable3),
    .read_en(read_out3),

    .packet_out(east_packet_out),
    .packet_valid(east_valid),

    .full(east_full),
    .empty()
);


//////////////////////////////////////////////////////
// OUTPUT PORT 4 - WEST
//////////////////////////////////////////////////////

output_port OUTPUT_PORT_WEST
(
    .clk(clk),
    .rst(rst),

    .packet_in(crossbar_out4),

    .write_en(write_enable4),
    .read_en(read_out4),

    .packet_out(west_packet_out),
    .packet_valid(west_valid),

    .full(west_full),
    .empty()
);


//////////////////////////////////////////////////////
// OUTPUT PORT 5 - GATEWAY
//////////////////////////////////////////////////////

output_port OUTPUT_PORT_GATEWAY
(
    .clk(clk),
    .rst(rst),

    .packet_in(crossbar_out5),

    .write_en(write_enable5),
    .read_en(read_out5),

    .packet_out(gateway_packet_out),
    .packet_valid(gateway_valid),

    .full(gateway_full),
    .empty()
);

endmodule