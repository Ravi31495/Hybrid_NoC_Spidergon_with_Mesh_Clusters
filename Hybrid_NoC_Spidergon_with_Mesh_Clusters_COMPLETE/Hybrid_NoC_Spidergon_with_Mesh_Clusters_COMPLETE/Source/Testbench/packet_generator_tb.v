`timescale 1ns / 1ps

module packet_generator_tb;

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

//--------------------------------------------------
// Clock
//--------------------------------------------------

reg clk;

initial
    clk = 0;

always #5 clk = ~clk;

//--------------------------------------------------
// Inputs
//--------------------------------------------------

reg [CLUSTER_BITS-1:0] dst_cluster;
reg [ROW_BITS-1:0]     dst_row;
reg [COL_BITS-1:0]     dst_col;

reg [CLUSTER_BITS-1:0] src_cluster;
reg [ROW_BITS-1:0]     src_row;
reg [COL_BITS-1:0]     src_col;

reg [TYPE_BITS-1:0] packet_type;
reg [PRIORITY_BITS-1:0] priority;

reg [PAYLOAD_BITS-1:0] payload;

//--------------------------------------------------
// Outputs
//--------------------------------------------------

wire [PACKET_WIDTH-1:0] packet;
wire packet_valid;

//--------------------------------------------------
// DUT
//--------------------------------------------------

packet_generator uut
(
    .dst_cluster(dst_cluster),
    .dst_row(dst_row),
    .dst_col(dst_col),

    .src_cluster(src_cluster),
    .src_row(src_row),
    .src_col(src_col),

    .packet_type(packet_type),
    .priority(priority),

    .payload(payload),

    .packet(packet),
    .packet_valid(packet_valid)
);

//--------------------------------------------------
// Loop Variables
//--------------------------------------------------

integer c,r,col;

//--------------------------------------------------
// Task
//--------------------------------------------------

task send_packet;

input [1:0] dc;
input [1:0] dr;
input [1:0] dcol;
input [31:0] pay;

begin

@(posedge clk);

dst_cluster = dc;
dst_row     = dr;
dst_col     = dcol;

src_cluster = 0;
src_row     = 0;
src_col     = 0;

packet_type = 2'b00;
priority    = 2'b01;

payload = pay;

#1;

$display("--------------------------------------");
$display("Time = %0t",$time);

$display("Packet Valid = %b",packet_valid);

$display("Destination : C=%0d R=%0d Col=%0d",
dc,dr,dcol);

$display("Payload : %h",pay);

$display("Packet  : %h",packet);

end

endtask

//--------------------------------------------------
// Test
//--------------------------------------------------

initial
begin

dst_cluster = 0;
dst_row     = 0;
dst_col     = 0;

src_cluster = 0;
src_row     = 0;
src_col     = 0;

packet_type = 0;
priority    = 0;
payload     = 0;

$display("\nHybrid NoC Packet Generator Test\n");

for(c=0;c<4;c=c+1)
begin
    for(r=0;r<4;r=r+1)
    begin
        for(col=0;col<4;col=col+1)
        begin

            send_packet(
                c,
                r,
                col,
                $random
            );

        end
    end
end

$display("\nSimulation Finished Successfully");

#20;

$finish;

end

endmodule