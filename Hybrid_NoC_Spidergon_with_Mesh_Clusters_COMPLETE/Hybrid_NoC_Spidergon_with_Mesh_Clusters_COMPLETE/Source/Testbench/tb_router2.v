`timescale 1ns/1ps
`include "noc_defines.vh"

module tb_router2;

reg clk = 0;
reg rst;

reg [`PACKET_WIDTH-1:0] local_packet_in, north_packet_in, west_packet_in;
reg local_write, north_write, west_write;
reg [`PACKET_WIDTH-1:0] south_packet_in, east_packet_in;
reg south_write, east_write;

reg [`CLUSTER_BITS-1:0] my_cluster;
reg [`ROW_BITS-1:0] my_row;
reg [`COL_BITS-1:0] my_col;

reg local_busy, north_busy, south_busy, east_busy, west_busy;

wire [`PACKET_WIDTH-1:0] local_packet_out, north_packet_out, south_packet_out, east_packet_out, west_packet_out;
wire local_valid, north_valid, south_valid, east_valid, west_valid;
wire local_full, north_full, south_full, east_full, west_full;

integer east_count = 0;
integer local_count = 0;

router DUT (
    .clk(clk), .rst(rst),
    .local_packet_in(local_packet_in), .north_packet_in(north_packet_in),
    .south_packet_in(south_packet_in), .east_packet_in(east_packet_in), .west_packet_in(west_packet_in),
    .local_write(local_write), .north_write(north_write), .south_write(south_write),
    .east_write(east_write), .west_write(west_write),
    .my_cluster(my_cluster), .my_row(my_row), .my_col(my_col),
    .local_busy(local_busy), .north_busy(north_busy), .south_busy(south_busy),
    .east_busy(east_busy), .west_busy(west_busy),
    .local_packet_out(local_packet_out), .north_packet_out(north_packet_out),
    .south_packet_out(south_packet_out), .east_packet_out(east_packet_out), .west_packet_out(west_packet_out),
    .local_valid(local_valid), .north_valid(north_valid), .south_valid(south_valid),
    .east_valid(east_valid), .west_valid(west_valid),
    .local_full(local_full), .north_full(north_full), .south_full(south_full),
    .east_full(east_full), .west_full(west_full)
);

always #5 clk = ~clk;

always @(posedge clk) begin
    if (east_valid) begin
        east_count = east_count + 1;
        $display("[t=%0t] EAST_OUT  event #%0d -> payload = 0x%h", $time, east_count, east_packet_out[31:0]);
    end
    if (local_valid) begin
        local_count = local_count + 1;
        $display("[t=%0t] LOCAL_OUT event #%0d -> payload = 0x%h", $time, local_count, local_packet_out[31:0]);
    end
end

// dest fixed at (cluster0,row0,col1) -> requires EAST hop from (0,0,0)
task send_packet(input integer port, input [31:0] marker);
begin
    @(negedge clk);
    case(port)
        0: begin local_packet_in = {2'd0,2'd0,2'd1, 2'd0,2'd0,2'd0, 2'd0,2'd0, marker}; local_write = 1; end
        1: begin north_packet_in = {2'd0,2'd0,2'd1, 2'd0,2'd0,2'd0, 2'd0,2'd0, marker}; north_write = 1; end
        4: begin west_packet_in  = {2'd0,2'd0,2'd0, 2'd0,2'd0,2'd0, 2'd0,2'd0, marker}; west_write  = 1; end // dest=self -> LOCAL out
    endcase
    @(negedge clk);
    local_write = 0; north_write = 0; west_write = 0;
end
endtask

initial begin
    rst = 1;
    local_write=0; north_write=0; south_write=0; east_write=0; west_write=0;
    local_packet_in=0; north_packet_in=0; south_packet_in=0; east_packet_in=0; west_packet_in=0;
    my_cluster=0; my_row=0; my_col=0;
    local_busy=0; north_busy=0; south_busy=0; east_busy=0; west_busy=0;

    repeat(3) @(negedge clk);
    rst = 0;
    @(negedge clk);

    $display("=== Scenario 1: back-to-back packets, same port (LOCAL), both need EAST ===");
    send_packet(0, 32'h11111111);
    send_packet(0, 32'h22222222);   // injected on the very next cycle, no gap

    repeat(8) @(negedge clk);

    $display("");
    $display("=== Scenario 2: CONTENTION - LOCAL and NORTH both request EAST in the same cycle ===");
    @(negedge clk);
    local_packet_in = {2'd0,2'd0,2'd1, 2'd0,2'd0,2'd0, 2'd0,2'd0, 32'h33333333};
    north_packet_in = {2'd0,2'd0,2'd1, 2'd0,2'd0,2'd0, 2'd0,2'd0, 32'h44444444};
    local_write = 1; north_write = 1;
    @(negedge clk);
    local_write = 0; north_write = 0;

    repeat(10) @(negedge clk);

    $display("");
    $display("=== Scenario 3: WEST input, destined for self -> should exit LOCAL ===");
    send_packet(4, 32'h55555555);

    repeat(10) @(negedge clk);

    $display("");
    $display("=== FINAL SUMMARY ===");
    $display("Total EAST_OUT  events : %0d  (expect 4: 0x11111111, 0x22222222, 0x33333333, 0x44444444, any order for the last two)", east_count);
    $display("Total LOCAL_OUT events : %0d  (expect 1: 0x55555555)", local_count);
    $display("LOCAL input FIFO count : %0d", DUT.INPUT_PORT_LOCAL.INPUT_BUFFER.FIFO_INST.count);
    $display("NORTH input FIFO count : %0d", DUT.INPUT_PORT_NORTH.INPUT_BUFFER.FIFO_INST.count);
    $display("WEST  input FIFO count : %0d", DUT.INPUT_PORT_WEST.INPUT_BUFFER.FIFO_INST.count);

    $finish;
end

endmodule
