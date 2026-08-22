`timescale 1ns / 1ps

module output_buffer_tb;

parameter DATA_WIDTH = 48;
parameter DEPTH      = 16;

reg clk;
reg rst;

reg write_en;
reg read_en;

reg [DATA_WIDTH-1:0] packet_in;

wire [DATA_WIDTH-1:0] packet_out;
wire full;
wire empty;

integer errors;


////////////////////////////////////////////////////////////
// DUT
////////////////////////////////////////////////////////////

output_buffer
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


////////////////////////////////////////////////////////////
// CLOCK
////////////////////////////////////////////////////////////

initial
begin
    clk = 1'b0;

    forever
        #5 clk = ~clk;
end


////////////////////////////////////////////////////////////
// CHECK STATUS
////////////////////////////////////////////////////////////

task check_status;

input expected_full;
input expected_empty;

begin

    #1;

    if ((full === expected_full) &&
        (empty === expected_empty))
    begin
        $display("PASS: STATUS");
    end
    else
    begin

        $display("FAIL: STATUS");

        $display("      Expected FULL  = %b",
                 expected_full);

        $display("      Actual   FULL  = %b",
                 full);

        $display("      Expected EMPTY = %b",
                 expected_empty);

        $display("      Actual   EMPTY = %b",
                 empty);

        errors = errors + 1;

    end

end

endtask


////////////////////////////////////////////////////////////
// CHECK DATA
////////////////////////////////////////////////////////////

task check_data;

input [DATA_WIDTH-1:0] expected_data;

begin

    #1;

    if (packet_out === expected_data)
    begin
        $display("PASS: DATA = %h",
                 expected_data);
    end
    else
    begin

        $display("FAIL: DATA");

        $display("      Expected = %h",
                 expected_data);

        $display("      Actual   = %h",
                 packet_out);

        errors = errors + 1;

    end

end

endtask


////////////////////////////////////////////////////////////
// MAIN TEST
////////////////////////////////////////////////////////////

initial
begin

    errors = 0;

    rst       = 1'b1;
    write_en  = 1'b0;
    read_en   = 1'b0;
    packet_in = {DATA_WIDTH{1'b0}};


    $display("");
    $display("================================================");
    $display("           OUTPUT BUFFER UNIT TEST");
    $display("================================================");
    $display("");


    ////////////////////////////////////////////////////////////
    // RESET
    ////////////////////////////////////////////////////////////

    #12;

    rst = 1'b0;

    #1;

    if (empty === 1'b1)
        $display("PASS: RESET -> EMPTY");
    else
    begin
        $display("FAIL: RESET -> EMPTY");
        errors = errors + 1;
    end


    if (packet_out === {DATA_WIDTH{1'b0}})
        $display("PASS: RESET -> DATA OUT ZERO");
    else
    begin
        $display("FAIL: RESET -> DATA OUT ZERO");
        errors = errors + 1;
    end


    ////////////////////////////////////////////////////////////
    // WRITE PACKET 1
    ////////////////////////////////////////////////////////////

    @(negedge clk);

    write_en  = 1'b1;
    read_en   = 1'b0;
    packet_in = 48'hAAAAAAAAAAAA;

    @(posedge clk);

    #1;

    if (!empty)
        $display("PASS: WRITE PACKET 1 STATUS");
    else
    begin
        $display("FAIL: WRITE PACKET 1 STATUS");
        errors = errors + 1;
    end

    check_data(48'hAAAAAAAAAAAA);


    ////////////////////////////////////////////////////////////
    // WRITE PACKET 2
    ////////////////////////////////////////////////////////////

    @(negedge clk);

    packet_in = 48'hBBBBBBBBBBBB;

    @(posedge clk);

    #1;

    check_data(48'hAAAAAAAAAAAA);


    ////////////////////////////////////////////////////////////
    // WRITE PACKET 3
    ////////////////////////////////////////////////////////////

    @(negedge clk);

    packet_in = 48'hCCCCCCCCCCCC;

    @(posedge clk);

    #1;

    write_en = 1'b0;

    check_data(48'hAAAAAAAAAAAA);


    ////////////////////////////////////////////////////////////
    // READ PACKET 1
    //
    // After this clock:
    // packet 2 becomes the output.
    ////////////////////////////////////////////////////////////

    @(negedge clk);

    read_en = 1'b1;

    @(posedge clk);

    #1;

    check_data(48'hBBBBBBBBBBBB);


    ////////////////////////////////////////////////////////////
    // READ PACKET 2
    //
    // After this clock:
    // packet 3 becomes the output.
    ////////////////////////////////////////////////////////////

    @(negedge clk);

    read_en = 1'b1;

    @(posedge clk);

    #1;

    read_en = 1'b0;

    check_data(48'hCCCCCCCCCCCC);


    ////////////////////////////////////////////////////////////
    // READ PACKET 3
    //
    // Now FIFO should become empty.
    ////////////////////////////////////////////////////////////

    @(negedge clk);

    read_en = 1'b1;

    @(posedge clk);

    #1;

    read_en = 1'b0;

    if (empty === 1'b1)
        $display("PASS: READ ALL -> EMPTY");
    else
    begin
        $display("FAIL: READ ALL -> EMPTY");
        errors = errors + 1;
    end


    if (packet_out === {DATA_WIDTH{1'b0}})
        $display("PASS: EMPTY -> DATA OUT ZERO");
    else
    begin
        $display("FAIL: EMPTY -> DATA OUT ZERO");
        errors = errors + 1;
    end


    ////////////////////////////////////////////////////////////
    // EMPTY READ PROTECTION
    ////////////////////////////////////////////////////////////

    @(negedge clk);

    read_en = 1'b1;

    @(posedge clk);

    #1;

    read_en = 1'b0;

    if (empty === 1'b1)
        $display("PASS: EMPTY READ PROTECTED");
    else
    begin
        $display("FAIL: EMPTY READ PROTECTED");
        errors = errors + 1;
    end


    ////////////////////////////////////////////////////////////
    // NEW PACKET
    ////////////////////////////////////////////////////////////

    @(negedge clk);

    write_en  = 1'b1;
    packet_in = 48'h123456789ABC;

    @(posedge clk);

    #1;

    write_en = 1'b0;

    check_data(48'h123456789ABC);


    ////////////////////////////////////////////////////////////
    // SIMULTANEOUS READ + WRITE
    ////////////////////////////////////////////////////////////

    @(negedge clk);

    write_en  = 1'b1;
    read_en   = 1'b1;
    packet_in = 48'hFEDCBA987654;

    @(posedge clk);

    #1;

    write_en = 1'b0;
    read_en  = 1'b0;

    if (!empty)
        $display("PASS: SIMULTANEOUS READ WRITE STATUS");
    else
    begin
        $display("FAIL: SIMULTANEOUS READ WRITE STATUS");
        errors = errors + 1;
    end

    check_data(48'hFEDCBA987654);


    ////////////////////////////////////////////////////////////
    // HOLD DATA WITHOUT READ
    ////////////////////////////////////////////////////////////

    @(posedge clk);

    #1;

    check_data(48'hFEDCBA987654);


    ////////////////////////////////////////////////////////////
    // FINAL READ
    ////////////////////////////////////////////////////////////

    @(negedge clk);

    read_en = 1'b1;

    @(posedge clk);

    #1;

    read_en = 1'b0;

    if (empty === 1'b1)
        $display("PASS: FINAL READ -> EMPTY");
    else
    begin
        $display("FAIL: FINAL READ -> EMPTY");
        errors = errors + 1;
    end


    if (packet_out === {DATA_WIDTH{1'b0}})
        $display("PASS: FINAL EMPTY DATA");
    else
    begin
        $display("FAIL: FINAL EMPTY DATA");
        errors = errors + 1;
    end


    ////////////////////////////////////////////////////////////
    // RESULT
    ////////////////////////////////////////////////////////////

    $display("");
    $display("================================================");

    if (errors == 0)
        $display("RESULT : ALL OUTPUT BUFFER TESTS PASSED");
    else
        $display("RESULT : %0d OUTPUT BUFFER TESTS FAILED",
                 errors);

    $display("================================================");
    $display("");

    $finish;

end

endmodule