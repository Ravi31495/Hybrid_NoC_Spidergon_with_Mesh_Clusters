`timescale 1ns / 1ps

module router_control_logic_tb;

reg clk;
reg rst;

reg [4:0] local_grant;
reg [4:0] north_grant;
reg [4:0] south_grant;
reg [4:0] east_grant;
reg [4:0] west_grant;

reg local_ready;
reg north_ready;
reg south_ready;
reg east_ready;
reg west_ready;

wire [2:0] sel0;
wire [2:0] sel1;
wire [2:0] sel2;
wire [2:0] sel3;
wire [2:0] sel4;

wire read_enable0;
wire read_enable1;
wire read_enable2;
wire read_enable3;
wire read_enable4;

wire write_enable0;
wire write_enable1;
wire write_enable2;
wire write_enable3;
wire write_enable4;

wire read_out0;
wire read_out1;
wire read_out2;
wire read_out3;
wire read_out4;

integer tests_run;
integer tests_passed;
integer tests_failed;


//////////////////////////////////////////////////////////////
// CLOCK
//////////////////////////////////////////////////////////////

initial
begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end


//////////////////////////////////////////////////////////////
// DUT
//////////////////////////////////////////////////////////////

router_control_logic DUT
(
    .clk(clk),
    .rst(rst),

    .local_grant(local_grant),
    .north_grant(north_grant),
    .south_grant(south_grant),
    .east_grant(east_grant),
    .west_grant(west_grant),

    .local_ready(local_ready),
    .north_ready(north_ready),
    .south_ready(south_ready),
    .east_ready(east_ready),
    .west_ready(west_ready),

    .sel0(sel0),
    .sel1(sel1),
    .sel2(sel2),
    .sel3(sel3),
    .sel4(sel4),

    .read_enable0(read_enable0),
    .read_enable1(read_enable1),
    .read_enable2(read_enable2),
    .read_enable3(read_enable3),
    .read_enable4(read_enable4),

    .write_enable0(write_enable0),
    .write_enable1(write_enable1),
    .write_enable2(write_enable2),
    .write_enable3(write_enable3),
    .write_enable4(write_enable4),

    .read_out0(read_out0),
    .read_out1(read_out1),
    .read_out2(read_out2),
    .read_out3(read_out3),
    .read_out4(read_out4)
);


//////////////////////////////////////////////////////////////
// CHECK TASK
//////////////////////////////////////////////////////////////

task check_outputs;

input [2:0] expected_sel0;
input [2:0] expected_sel1;
input [2:0] expected_sel2;
input [2:0] expected_sel3;
input [2:0] expected_sel4;

input expected_read0;
input expected_read1;
input expected_read2;
input expected_read3;
input expected_read4;

input expected_write0;
input expected_write1;
input expected_write2;
input expected_write3;
input expected_write4;

input expected_out0;
input expected_out1;
input expected_out2;
input expected_out3;
input expected_out4;

input [200*8:1] test_name;

begin

    #1;

    tests_run = tests_run + 1;

    if ((sel0 === expected_sel0) &&
        (sel1 === expected_sel1) &&
        (sel2 === expected_sel2) &&
        (sel3 === expected_sel3) &&
        (sel4 === expected_sel4) &&

        (read_enable0 === expected_read0) &&
        (read_enable1 === expected_read1) &&
        (read_enable2 === expected_read2) &&
        (read_enable3 === expected_read3) &&
        (read_enable4 === expected_read4) &&

        (write_enable0 === expected_write0) &&
        (write_enable1 === expected_write1) &&
        (write_enable2 === expected_write2) &&
        (write_enable3 === expected_write3) &&
        (write_enable4 === expected_write4) &&

        (read_out0 === expected_out0) &&
        (read_out1 === expected_out1) &&
        (read_out2 === expected_out2) &&
        (read_out3 === expected_out3) &&
        (read_out4 === expected_out4))
    begin
        tests_passed = tests_passed + 1;
        $display("PASS : %0s", test_name);
    end

    else
    begin
        tests_failed = tests_failed + 1;

        $display("FAIL : %0s", test_name);

        $display("  SEL      = %b %b %b %b %b",
                 sel0, sel1, sel2, sel3, sel4);

        $display("  READ     = %b %b %b %b %b",
                 read_enable0,
                 read_enable1,
                 read_enable2,
                 read_enable3,
                 read_enable4);

        $display("  WRITE    = %b %b %b %b %b",
                 write_enable0,
                 write_enable1,
                 write_enable2,
                 write_enable3,
                 write_enable4);

        $display("  READ_OUT = %b %b %b %b %b",
                 read_out0,
                 read_out1,
                 read_out2,
                 read_out3,
                 read_out4);
    end

end

endtask


//////////////////////////////////////////////////////////////
// TESTBENCH
//////////////////////////////////////////////////////////////

initial
begin

    tests_run    = 0;
    tests_passed = 0;
    tests_failed = 0;


    local_grant = 5'b00000;
    north_grant = 5'b00000;
    south_grant = 5'b00000;
    east_grant  = 5'b00000;
    west_grant  = 5'b00000;


    local_ready = 1'b0;
    north_ready = 1'b0;
    south_ready = 1'b0;
    east_ready  = 1'b0;
    west_ready  = 1'b0;


    rst = 1'b1;

    #20;

    rst = 1'b0;


    $display("");
    $display("================================================");
    $display("       ROUTER CONTROL LOGIC UNIT TEST");
    $display("================================================");


    //////////////////////////////////////////////////////////
    // TEST 1 : NO GRANTS
    //////////////////////////////////////////////////////////

    check_outputs(
        3'd0, 3'd0, 3'd0, 3'd0, 3'd0,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b0,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b0,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b0,

        "NO GRANTS"
    );


    //////////////////////////////////////////////////////////
    // TEST 2 : ONE GRANT ON LOCAL
    // local_grant[2] -> input 2
    //////////////////////////////////////////////////////////

    local_grant = 5'b00100;

    check_outputs(
        3'd2, 3'd0, 3'd0, 3'd0, 3'd0,

        // IMPORTANT:
        // local_grant[2] means INPUT 2 is being read.
        1'b0, 1'b0, 1'b1, 1'b0, 1'b0,

        1'b1, 1'b0, 1'b0, 1'b0, 1'b0,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b0,

        "LOCAL GRANT INPUT 2"
    );


    //////////////////////////////////////////////////////////
    // TEST 3 : ONE GRANT ON NORTH
    // north_grant[4] -> input 4
    //////////////////////////////////////////////////////////

    local_grant = 5'b00000;
    north_grant = 5'b10000;

    check_outputs(
        3'd0, 3'd4, 3'd0, 3'd0, 3'd0,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b1,

        1'b0, 1'b1, 1'b0, 1'b0, 1'b0,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b0,

        "NORTH GRANT INPUT 4"
    );


    //////////////////////////////////////////////////////////
    // TEST 4 : ONE GRANT ON SOUTH
    // south_grant[3] -> input 3
    //////////////////////////////////////////////////////////

    north_grant = 5'b00000;
    south_grant = 5'b01000;

    check_outputs(
        3'd0, 3'd0, 3'd3, 3'd0, 3'd0,

        1'b0, 1'b0, 1'b0, 1'b1, 1'b0,

        1'b0, 1'b0, 1'b1, 1'b0, 1'b0,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b0,

        "SOUTH GRANT INPUT 3"
    );


    //////////////////////////////////////////////////////////
    // TEST 5 : ONE GRANT ON EAST
    // east_grant[1] -> input 1
    //////////////////////////////////////////////////////////

    south_grant = 5'b00000;
    east_grant  = 5'b00010;

    check_outputs(
        3'd0, 3'd0, 3'd0, 3'd1, 3'd0,

        1'b0, 1'b1, 1'b0, 1'b0, 1'b0,

        1'b0, 1'b0, 1'b0, 1'b1, 1'b0,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b0,

        "EAST GRANT INPUT 1"
    );


    //////////////////////////////////////////////////////////
    // TEST 6 : ONE GRANT ON WEST
    // west_grant[0] -> input 0
    //////////////////////////////////////////////////////////

    east_grant = 5'b00000;
    west_grant = 5'b00001;

    check_outputs(
        3'd0, 3'd0, 3'd0, 3'd0, 3'd0,

        1'b1, 1'b0, 1'b0, 1'b0, 1'b0,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b1,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b0,

        "WEST GRANT INPUT 0"
    );


    //////////////////////////////////////////////////////////
    // TEST 7 : ALL FIVE OUTPUTS ACTIVE
    //////////////////////////////////////////////////////////

    local_grant = 5'b00001;
    north_grant = 5'b00010;
    south_grant = 5'b00100;
    east_grant  = 5'b01000;
    west_grant  = 5'b10000;

    check_outputs(
        3'd0, 3'd1, 3'd2, 3'd3, 3'd4,

        1'b1, 1'b1, 1'b1, 1'b1, 1'b1,

        1'b1, 1'b1, 1'b1, 1'b1, 1'b1,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b0,

        "ALL FIVE ONE-HOT GRANTS"
    );


    //////////////////////////////////////////////////////////
    // TEST 8 : SAME INPUT REQUESTS MULTIPLE OUTPUTS
    //////////////////////////////////////////////////////////

    local_grant = 5'b00100;
    north_grant = 5'b00000;
    south_grant = 5'b00000;
    east_grant  = 5'b00100;
    west_grant  = 5'b00000;

    check_outputs(
        3'd2, 3'd0, 3'd0, 3'd2, 3'd0,

        1'b0, 1'b0, 1'b1, 1'b0, 1'b0,

        1'b1, 1'b0, 1'b0, 1'b1, 1'b0,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b0,

        "INPUT 2 TO LOCAL AND EAST"
    );


    //////////////////////////////////////////////////////////
    // TEST 9 : READY SIGNALS
    //////////////////////////////////////////////////////////

    local_grant = 5'b00000;
    north_grant = 5'b00000;
    south_grant = 5'b00000;
    east_grant  = 5'b00000;
    west_grant  = 5'b00000;

    local_ready = 1'b1;
    north_ready = 1'b0;
    south_ready = 1'b1;
    east_ready  = 1'b0;
    west_ready  = 1'b1;

    check_outputs(
        3'd0, 3'd0, 3'd0, 3'd0, 3'd0,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b0,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b0,

        1'b1, 1'b0, 1'b1, 1'b0, 1'b1,

        "READY SIGNALS"
    );


    //////////////////////////////////////////////////////////
    // TEST 10 : CLEAR EVERYTHING
    //////////////////////////////////////////////////////////

    local_ready = 1'b0;
    north_ready = 1'b0;
    south_ready = 1'b0;
    east_ready  = 1'b0;
    west_ready  = 1'b0;

    check_outputs(
        3'd0, 3'd0, 3'd0, 3'd0, 3'd0,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b0,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b0,

        1'b0, 1'b0, 1'b0, 1'b0, 1'b0,

        "CLEAR ALL"
    );


    //////////////////////////////////////////////////////////
    // FINAL RESULT
    //////////////////////////////////////////////////////////

    $display("");
    $display("================================================");
    $display("TESTS RUN    : %0d", tests_run);
    $display("TESTS PASSED : %0d", tests_passed);
    $display("TESTS FAILED : %0d", tests_failed);
    $display("================================================");

    if (tests_failed == 0)
        $display("RESULT : ALL ROUTER CONTROL LOGIC TESTS PASSED");
    else
        $display("RESULT : ROUTER CONTROL LOGIC TESTS FAILED");

    $display("================================================");
    $display("");

    #20;

    $finish;

end

endmodule