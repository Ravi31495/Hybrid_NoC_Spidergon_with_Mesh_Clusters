`timescale 1ns / 1ps

module input_buffer_tb;

parameter DATA_WIDTH = 48;
parameter DEPTH = 16;

reg clk;
reg rst;

reg write_en;
reg read_en;

reg  [DATA_WIDTH-1:0] packet_in;
wire [DATA_WIDTH-1:0] packet_out;

wire full;
wire empty;

input_buffer
#(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH)
)
DUT
(
    .clk(clk),
    .rst(rst),

    .write_en(write_en),
    .read_en(read_en),

    .packet_in(packet_in),
    .packet_out(packet_out),

    .full(full),
    .empty(empty)
);

////////////////////////////////////////////////////
// Clock
////////////////////////////////////////////////////

initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

////////////////////////////////////////////////////
// Test
////////////////////////////////////////////////////

initial
begin

    rst = 1;

    write_en = 0;
    read_en  = 0;

    packet_in = 0;

    #12;
    rst = 0;

    //--------------------------------------------------
    // Write three packets
    //--------------------------------------------------

    @(posedge clk);
    write_en = 1;
    packet_in = 48'h111111111111;

    @(posedge clk);
    packet_in = 48'h222222222222;

    @(posedge clk);
    packet_in = 48'h333333333333;

    @(posedge clk);
    write_en = 0;

    //--------------------------------------------------
    // Read three packets
    //--------------------------------------------------

    @(posedge clk);
    read_en = 1;

    repeat(3)
        @(posedge clk);

    read_en = 0;

    //--------------------------------------------------
    // Simultaneous Read/Write
    //--------------------------------------------------

    @(posedge clk);

    write_en = 1;
    read_en  = 1;

    packet_in = 48'hAAAAAAAAAAAA;

    @(posedge clk);

    packet_in = 48'hBBBBBBBBBBBB;

    @(posedge clk);

    write_en = 0;
    read_en  = 0;

    #20;

    $finish;

end

////////////////////////////////////////////////////
// Monitor
////////////////////////////////////////////////////

initial
begin

$display("----------------------------------------------");
$display("Time\tWr\tRd\tIn\t\tOut");
$display("----------------------------------------------");

$monitor("%0t\t%b\t%b\t%h\t%h",
         $time,
         write_en,
         read_en,
         packet_in,
         packet_out);

end

endmodule