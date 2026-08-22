`timescale 1ns / 1ps

module packet_receiver_tb;

parameter CLUSTER_BITS  = 2;
parameter ROW_BITS      = 2;
parameter COL_BITS      = 2;
parameter TYPE_BITS     = 2;
parameter PRIORITY_BITS = 2;
parameter PAYLOAD_BITS  = 32;

parameter PACKET_WIDTH =
        (2*CLUSTER_BITS) +
        (2*ROW_BITS) +
        (2*COL_BITS) +
        TYPE_BITS +
        PRIORITY_BITS +
        PAYLOAD_BITS;

reg clk;
reg rst;

reg [PACKET_WIDTH-1:0] packet_in;
reg packet_valid_in;

reg [CLUSTER_BITS-1:0] my_cluster;
reg [ROW_BITS-1:0]     my_row;
reg [COL_BITS-1:0]     my_col;

wire packet_received;

wire [CLUSTER_BITS-1:0] src_cluster;
wire [ROW_BITS-1:0]     src_row;
wire [COL_BITS-1:0]     src_col;

wire [TYPE_BITS-1:0] packet_type;
wire [PRIORITY_BITS-1:0] priority;

wire [PAYLOAD_BITS-1:0] payload;

packet_receiver DUT
(
    .clk(clk),
    .rst(rst),

    .packet_in(packet_in),
    .packet_valid_in(packet_valid_in),

    .my_cluster(my_cluster),
    .my_row(my_row),
    .my_col(my_col),

    .packet_received(packet_received),

    .src_cluster(src_cluster),
    .src_row(src_row),
    .src_col(src_col),

    .packet_type(packet_type),
    .priority(priority),

    .payload(payload)
);

initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

task send_packet;

input [1:0] dc;
input [1:0] dr;
input [1:0] dcol;

input [1:0] sc;
input [1:0] sr;
input [1:0] scol;

input [1:0] ptype;
input [1:0] pri;

input [31:0] pay;

begin

packet_in = {

dc,
dr,
dcol,

sc,
sr,
scol,

ptype,
pri,

pay

};

packet_valid_in = 1;

@(posedge clk);

packet_valid_in = 0;

@(posedge clk);

$display("---------------------------------------------");
$display("Destination : %0d %0d %0d",dc,dr,dcol);
$display("Receiver    : %0d %0d %0d",my_cluster,my_row,my_col);

if(packet_received)
begin
    $display("Packet Accepted");
    $display("Payload = %h",payload);
    $display("Source  = %0d %0d %0d",
             src_cluster,
             src_row,
             src_col);
end
else
begin
    $display("Packet Rejected");
end

end

endtask

initial
begin

rst = 1;
packet_valid_in = 0;
packet_in = 0;

my_cluster = 2;
my_row = 1;
my_col = 3;

#20;

rst = 0;

$display("Packet Receiver Test");

send_packet(
2,1,3,
0,0,0,
0,1,
32'h12345678
);

send_packet(
0,0,1,
3,2,1,
1,2,
32'hAAAAAAAA
);

send_packet(
2,1,3,
1,1,1,
2,3,
32'hDEADBEEF
);

#30;

$finish;

end

endmodule