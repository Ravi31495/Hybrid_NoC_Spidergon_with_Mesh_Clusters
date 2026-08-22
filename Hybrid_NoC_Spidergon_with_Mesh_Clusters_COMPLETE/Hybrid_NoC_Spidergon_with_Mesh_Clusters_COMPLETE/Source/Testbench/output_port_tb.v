`timescale 1ns / 1ps
`include "noc_defines.vh"

module output_port_tb;

reg clk;
reg rst;

reg write_en;
reg read_en;

reg [`PACKET_WIDTH-1:0] packet_in;

wire [`PACKET_WIDTH-1:0] packet_out;
wire packet_valid;

wire full;
wire empty;

integer errors;


//--------------------------------------------------
// DUT
//--------------------------------------------------

output_port DUT
(
    .clk(clk),
    .rst(rst),

    .write_en(write_en),
    .read_en(read_en),

    .packet_in(packet_in),

    .packet_out(packet_out),
    .packet_valid(packet_valid),

    .full(full),
    .empty(empty)
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

    errors = 0;

    clk = 1'b0;
    rst = 1'b1;

    write_en = 1'b0;
    read_en  = 1'b0;

    packet_in = {`PACKET_WIDTH{1'b0}};


    $display("");
    $display("================================================");
    $display("          OUTPUT PORT UNIT TEST");
    $display("================================================");
    $display("");


    //--------------------------------------------------
    // TEST 1 : RESET
    //--------------------------------------------------

    #20;

    rst = 1'b0;

    #2;

    if (empty !== 1'b1)
    begin
        $display("FAIL: RESET -> FIFO EMPTY");
        errors = errors + 1;
    end
    else
        $display("PASS: RESET -> FIFO EMPTY");


    if (packet_valid !== 1'b0)
    begin
        $display("FAIL: RESET -> PACKET VALID LOW");
        errors = errors + 1;
    end
    else
        $display("PASS: RESET -> PACKET VALID LOW");


    if (full !== 1'b0)
    begin
        $display("FAIL: RESET -> FIFO NOT FULL");
        errors = errors + 1;
    end
    else
        $display("PASS: RESET -> FIFO NOT FULL");


    //--------------------------------------------------
    // TEST 2 : WRITE PACKET
    //--------------------------------------------------

    @(negedge clk);

    packet_in = 48'h1234_5678_9ABC;
    write_en  = 1'b1;

    @(negedge clk);

    write_en = 1'b0;

    #2;

    if (empty !== 1'b0)
    begin
        $display("FAIL: WRITE -> FIFO NOT EMPTY");
        errors = errors + 1;
    end
    else
        $display("PASS: WRITE -> FIFO NOT EMPTY");


    if (packet_valid !== 1'b1)
    begin
        $display("FAIL: WRITE -> PACKET VALID");
        errors = errors + 1;
    end
    else
        $display("PASS: WRITE -> PACKET VALID");


    //--------------------------------------------------
    // TEST 3 : PACKET DATA
    //--------------------------------------------------

    if (packet_out !== 48'h1234_5678_9ABC)
    begin
        $display("FAIL: PACKET DATA");
        $display("      Expected = 123456789ABC");
        $display("      Actual   = %h", packet_out);
        errors = errors + 1;
    end
    else
        $display("PASS: PACKET DATA");


    //--------------------------------------------------
    // TEST 4 : READ PACKET
    //--------------------------------------------------

    @(negedge clk);

    read_en = 1'b1;

    @(negedge clk);

    read_en = 1'b0;

    #2;

    if (empty !== 1'b1)
    begin
        $display("FAIL: READ -> FIFO EMPTY");
        errors = errors + 1;
    end
    else
        $display("PASS: READ -> FIFO EMPTY");


    if (packet_valid !== 1'b0)
    begin
        $display("FAIL: READ -> PACKET VALID LOW");
        errors = errors + 1;
    end
    else
        $display("PASS: READ -> PACKET VALID LOW");


    //--------------------------------------------------
    // TEST 5 : READ EMPTY PROTECTION
    //--------------------------------------------------

    @(negedge clk);

    read_en = 1'b1;

    @(negedge clk);

    read_en = 1'b0;

    #2;

    if (empty !== 1'b1)
    begin
        $display("FAIL: READ EMPTY -> FIFO REMAINS EMPTY");
        errors = errors + 1;
    end
    else
        $display("PASS: READ EMPTY -> FIFO PROTECTED");


    //--------------------------------------------------
    // TEST 6 : SECOND PACKET
    //--------------------------------------------------

    @(negedge clk);

    packet_in = 48'hAAAA_BBBB_CCCC;
    write_en  = 1'b1;

    @(negedge clk);

    write_en = 1'b0;

    #2;

    if (packet_out !== 48'hAAAA_BBBB_CCCC)
    begin
        $display("FAIL: SECOND PACKET DATA");
        errors = errors + 1;
    end
    else
        $display("PASS: SECOND PACKET DATA");


    //--------------------------------------------------
    // TEST 7 : BACK-PRESSURE / NO READ
    //--------------------------------------------------

    @(negedge clk);

    read_en = 1'b0;

    @(negedge clk);

    #2;

    if (packet_valid !== 1'b1)
    begin
        $display("FAIL: NO READ -> PACKET REMAINS VALID");
        errors = errors + 1;
    end
    else
        $display("PASS: NO READ -> PACKET REMAINS VALID");


    if (packet_out !== 48'hAAAA_BBBB_CCCC)
    begin
        $display("FAIL: NO READ -> DATA RETAINED");
        errors = errors + 1;
    end
    else
        $display("PASS: NO READ -> DATA RETAINED");


    //--------------------------------------------------
    // TEST 8 : FINAL READ
    //--------------------------------------------------

    @(negedge clk);

    read_en = 1'b1;

    @(negedge clk);

    read_en = 1'b0;

    #2;

    if (empty !== 1'b1)
    begin
        $display("FAIL: FINAL READ -> EMPTY");
        errors = errors + 1;
    end
    else
        $display("PASS: FINAL READ -> EMPTY");


    if (packet_valid !== 1'b0)
    begin
        $display("FAIL: FINAL READ -> VALID LOW");
        errors = errors + 1;
    end
    else
        $display("PASS: FINAL READ -> VALID LOW");


    //--------------------------------------------------
    // RESULT
    //--------------------------------------------------

    $display("");
    $display("================================================");

    if (errors == 0)
        $display("RESULT : ALL OUTPUT PORT TESTS PASSED");
    else
        $display("RESULT : %0d OUTPUT PORT TESTS FAILED", errors);

    $display("================================================");
    $display("");

    $finish;

end

endmodule