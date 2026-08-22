`timescale 1ns / 1ps
`include "noc_defines.vh"

module input_port_tb;

reg clk;
reg rst;

reg [`PACKET_WIDTH-1:0] packet_in;
reg packet_valid;
reg read_enable;

reg [`CLUSTER_BITS-1:0] my_cluster;
reg [`ROW_BITS-1:0]     my_row;
reg [`COL_BITS-1:0]     my_col;

reg local_busy;
reg north_busy;
reg south_busy;
reg east_busy;
reg west_busy;

wire [`PACKET_WIDTH-1:0] packet_out;
wire [2:0] direction;

wire request;
wire packet_valid_out;

wire empty;
wire full;

integer errors;


//--------------------------------------------------
// DUT
//--------------------------------------------------

input_port DUT
(
    .clk(clk),
    .rst(rst),

    .packet_in(packet_in),
    .packet_valid(packet_valid),

    .read_enable(read_enable),

    .my_cluster(my_cluster),
    .my_row(my_row),
    .my_col(my_col),

    .local_busy(local_busy),
    .north_busy(north_busy),
    .south_busy(south_busy),
    .east_busy(east_busy),
    .west_busy(west_busy),

    .packet_out(packet_out),
    .direction(direction),

    .request(request),
    .packet_valid_out(packet_valid_out),

    .empty(empty),
    .full(full)
);


//--------------------------------------------------
// Clock
//--------------------------------------------------

always #5 clk = ~clk;


//--------------------------------------------------
// Direction encoding
//--------------------------------------------------

localparam LOCAL = 3'b000;
localparam NORTH = 3'b001;
localparam SOUTH = 3'b010;
localparam EAST  = 3'b011;
localparam WEST  = 3'b100;


//--------------------------------------------------
// Test packet
//
// Destination:
//     Cluster = 0
//     Row     = 1
//     Col     = 2
//
// Source:
//     Cluster = 0
//     Row     = 1
//     Col     = 1
//
// Type     = DATA
// Priority = MEDIUM
// Payload  = 12345678
//
// Since source = (1,1)
// and destination = (1,2),
// expected XY direction = EAST.
//--------------------------------------------------

reg [`PACKET_WIDTH-1:0] test_packet;

initial
begin

    test_packet =
    {
        2'b00,              // Destination cluster
        2'b01,              // Destination row
        2'b10,              // Destination column

        2'b00,              // Source cluster
        2'b01,              // Source row
        2'b01,              // Source column

        2'b00,              // Packet type
        2'b01,              // Priority

        32'h12345678        // Payload
    };

end


//--------------------------------------------------
// Main test
//--------------------------------------------------

initial
begin

    errors = 0;

    clk = 0;
    rst = 1;

    packet_in   = 0;
    packet_valid = 0;
    read_enable  = 0;

    my_cluster = 2'd0;
    my_row     = 2'd1;
    my_col     = 2'd1;

    local_busy = 0;
    north_busy = 0;
    south_busy = 0;
    east_busy  = 0;
    west_busy  = 0;


    $display("");
    $display("================================================");
    $display("        INPUT PORT INTEGRATION TEST");
    $display("================================================");
    $display("");


    //--------------------------------------------------
    // TEST 1 : RESET
    //--------------------------------------------------

    #20;

    rst = 0;

    #2;

    if (empty !== 1'b1)
    begin
        $display("FAIL: RESET -> FIFO EMPTY");
        errors = errors + 1;
    end
    else
        $display("PASS: RESET -> FIFO EMPTY");


    if (full !== 1'b0)
    begin
        $display("FAIL: RESET -> FIFO NOT FULL");
        errors = errors + 1;
    end
    else
        $display("PASS: RESET -> FIFO NOT FULL");


    if (packet_valid_out !== 1'b0)
    begin
        $display("FAIL: RESET -> PACKET VALID OUT LOW");
        errors = errors + 1;
    end
    else
        $display("PASS: RESET -> PACKET VALID OUT LOW");


    //--------------------------------------------------
    // TEST 2 : WRITE PACKET
    //--------------------------------------------------

    @(negedge clk);

    packet_in    = test_packet;
    packet_valid = 1'b1;

    @(negedge clk);

    packet_valid = 1'b0;

    #2;

    if (empty !== 1'b0)
    begin
        $display("FAIL: PACKET WRITE -> FIFO NOT EMPTY");
        errors = errors + 1;
    end
    else
        $display("PASS: PACKET WRITE -> FIFO NOT EMPTY");


    //--------------------------------------------------
    // TEST 3 : PACKET OUTPUT / FWFT
    //--------------------------------------------------

    if (packet_out !== test_packet)
    begin
        $display("FAIL: FWFT PACKET OUTPUT");
        $display("      Expected = %h", test_packet);
        $display("      Actual   = %h", packet_out);
        errors = errors + 1;
    end
    else
        $display("PASS: FWFT PACKET OUTPUT");


    //--------------------------------------------------
    // TEST 4 : PACKET VALID
    //--------------------------------------------------

    if (packet_valid_out !== 1'b1)
    begin
        $display("FAIL: PACKET VALID OUT");
        errors = errors + 1;
    end
    else
        $display("PASS: PACKET VALID OUT");


    //--------------------------------------------------
    // TEST 5 : XY ROUTING
    //
    // Source  = (1,1)
    // Dest    = (1,2)
    // Expected = EAST
    //--------------------------------------------------

    #2;

    if (direction !== EAST)
    begin
        $display("FAIL: XY EAST ROUTING");
        $display("      Expected = %03b", EAST);
        $display("      Actual   = %03b", direction);
        errors = errors + 1;
    end
    else
        $display("PASS: XY EAST ROUTING");


    //--------------------------------------------------
    // TEST 6 : REQUEST
    //--------------------------------------------------

    if (request !== 1'b1)
    begin
        $display("FAIL: REQUEST GENERATION");
        $display("      Expected = 1");
        $display("      Actual   = %b", request);
        errors = errors + 1;
    end
    else
        $display("PASS: REQUEST GENERATION");


    //--------------------------------------------------
    // TEST 7 : READ PACKET
    //--------------------------------------------------

    @(negedge clk);

    read_enable = 1'b1;

    @(negedge clk);

    read_enable = 1'b0;

    #2;


    //--------------------------------------------------
    // TEST 8 : FIFO EMPTY AFTER READ
    //--------------------------------------------------

    if (empty !== 1'b1)
    begin
        $display("FAIL: FIFO EMPTY AFTER READ");
        errors = errors + 1;
    end
    else
        $display("PASS: FIFO EMPTY AFTER READ");


    //--------------------------------------------------
    // TEST 9 : PACKET VALID LOW AFTER READ
    //--------------------------------------------------

    if (packet_valid_out !== 1'b0)
    begin
        $display("FAIL: PACKET VALID LOW AFTER READ");
        errors = errors + 1;
    end
    else
        $display("PASS: PACKET VALID LOW AFTER READ");


    //--------------------------------------------------
    // TEST 10 : REQUEST LOW AFTER READ
    //--------------------------------------------------

    #2;

    if (request !== 1'b0)
    begin
        $display("FAIL: REQUEST LOW AFTER READ");
        errors = errors + 1;
    end
    else
        $display("PASS: REQUEST LOW AFTER READ");


    //--------------------------------------------------
    // RESULT
    //--------------------------------------------------

    $display("");
    $display("================================================");

    if (errors == 0)
    begin
        $display("RESULT : ALL INPUT PORT TESTS PASSED");
    end
    else
    begin
        $display("RESULT : %0d INPUT PORT TESTS FAILED", errors);
    end

    $display("================================================");
    $display("");

    $finish;

end

endmodule