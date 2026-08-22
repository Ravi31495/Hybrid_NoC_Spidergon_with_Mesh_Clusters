`timescale 1ns/1ps
`include "noc_defines.vh"

module router_tb;

//////////////////////////////////////////////////////////////
// CLOCK / RESET
//////////////////////////////////////////////////////////////

reg clk;
reg rst;

always #5 clk = ~clk;


//////////////////////////////////////////////////////////////
// INPUTS
//////////////////////////////////////////////////////////////

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


//////////////////////////////////////////////////////////////
// ROUTER POSITION
//////////////////////////////////////////////////////////////

reg [`CLUSTER_BITS-1:0] my_cluster;
reg [`ROW_BITS-1:0]     my_row;
reg [`COL_BITS-1:0]     my_col;


//////////////////////////////////////////////////////////////
// OUTPUT BUSY SIGNALS
//////////////////////////////////////////////////////////////

reg local_busy;
reg north_busy;
reg south_busy;
reg east_busy;
reg west_busy;


//////////////////////////////////////////////////////////////
// OUTPUTS
//////////////////////////////////////////////////////////////

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


//////////////////////////////////////////////////////////////
// TEST STATISTICS
//////////////////////////////////////////////////////////////

integer tests_run;
integer tests_passed;
integer tests_failed;


//////////////////////////////////////////////////////////////
// DUT
//////////////////////////////////////////////////////////////

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
    .west_full(west_full),

    .local_ready(1'b1),
    .north_ready(1'b1),
    .south_ready(1'b1),
    .east_ready(1'b1),
    .west_ready(1'b1)
);


//////////////////////////////////////////////////////////////
// PACKET BUILDER
//////////////////////////////////////////////////////////////

function [`PACKET_WIDTH-1:0] make_packet;

input [`CLUSTER_BITS-1:0] dst_cluster;
input [`ROW_BITS-1:0]     dst_row;
input [`COL_BITS-1:0]     dst_col;

input [`CLUSTER_BITS-1:0] src_cluster;
input [`ROW_BITS-1:0]     src_row;
input [`COL_BITS-1:0]     src_col;

input [`TYPE_BITS-1:0]     pkt_type;
input [`PRIORITY_BITS-1:0] pkt_priority;

input [`PAYLOAD_BITS-1:0] payload;

begin

    make_packet =
    {
        dst_cluster,
        dst_row,
        dst_col,

        src_cluster,
        src_row,
        src_col,

        pkt_type,
        pkt_priority,

        payload
    };

end

endfunction


//////////////////////////////////////////////////////////////
// WAIT CLOCKS
//////////////////////////////////////////////////////////////

task wait_cycles;

input integer n;
integer i;

begin

    for(i = 0; i < n; i = i + 1)
        @(posedge clk);

end

endtask


//////////////////////////////////////////////////////////////
// CLEAR INPUT WRITE SIGNALS
//////////////////////////////////////////////////////////////

task clear_writes;

begin

    local_write = 0;
    north_write = 0;
    south_write = 0;
    east_write  = 0;
    west_write  = 0;

end

endtask


//////////////////////////////////////////////////////////////
// SEND LOCAL
//////////////////////////////////////////////////////////////

task send_local;

input [`PACKET_WIDTH-1:0] pkt;

begin

    @(negedge clk);

    local_packet_in = pkt;
    local_write     = 1;

    @(negedge clk);

    local_write     = 0;

end

endtask


//////////////////////////////////////////////////////////////
// SEND NORTH
//////////////////////////////////////////////////////////////

task send_north;

input [`PACKET_WIDTH-1:0] pkt;

begin

    @(negedge clk);

    north_packet_in = pkt;
    north_write     = 1;

    @(negedge clk);

    north_write     = 0;

end

endtask


//////////////////////////////////////////////////////////////
// SEND SOUTH
//////////////////////////////////////////////////////////////

task send_south;

input [`PACKET_WIDTH-1:0] pkt;

begin

    @(negedge clk);

    south_packet_in = pkt;
    south_write     = 1;

    @(negedge clk);

    south_write     = 0;

end

endtask


//////////////////////////////////////////////////////////////
// SEND EAST
//////////////////////////////////////////////////////////////

task send_east;

input [`PACKET_WIDTH-1:0] pkt;

begin

    @(negedge clk);

    east_packet_in = pkt;
    east_write     = 1;

    @(negedge clk);

    east_write     = 0;

end

endtask


//////////////////////////////////////////////////////////////
// SEND WEST
//////////////////////////////////////////////////////////////

task send_west;

input [`PACKET_WIDTH-1:0] pkt;

begin

    @(negedge clk);

    west_packet_in = pkt;
    west_write     = 1;

    @(negedge clk);

    west_write     = 0;

end

endtask


//////////////////////////////////////////////////////////////
// CHECK EXPECTED OUTPUT
//
// port:
// 0 = LOCAL
// 1 = NORTH
// 2 = SOUTH
// 3 = EAST
// 4 = WEST
//////////////////////////////////////////////////////////////

task check_output;

input [2:0] expected_port;
input [`PACKET_WIDTH-1:0] expected_packet;
input integer timeout_cycles;

integer i;
reg found;

begin

    found = 0;

    for(i = 0; i < timeout_cycles; i = i + 1)
    begin

        @(posedge clk);

        case(expected_port)

            3'd0:
            begin
                if(local_valid &&
                   local_packet_out == expected_packet)
                    found = 1;
            end

            3'd1:
            begin
                if(north_valid &&
                   north_packet_out == expected_packet)
                    found = 1;
            end

            3'd2:
            begin
                if(south_valid &&
                   south_packet_out == expected_packet)
                    found = 1;
            end

            3'd3:
            begin
                if(east_valid &&
                   east_packet_out == expected_packet)
                    found = 1;
            end

            3'd4:
            begin
                if(west_valid &&
                   west_packet_out == expected_packet)
                    found = 1;
            end

        endcase

        if(found)
            i = timeout_cycles;

    end


    tests_run = tests_run + 1;

    if(found)
    begin

        tests_passed = tests_passed + 1;

        $display("");
        $display("------------------------------------------------");
        $display("PASS");
        $display("Expected Port   : %0d", expected_port);
        $display("Expected Packet : %h", expected_packet);
        $display("------------------------------------------------");

    end

    else
    begin

        tests_failed = tests_failed + 1;

        $display("");
        $display("------------------------------------------------");
        $display("FAIL");
        $display("Expected Port   : %0d", expected_port);
        $display("Expected Packet : %h", expected_packet);

        $display("");
        $display("Actual Outputs:");

        $display("LOCAL : %h V=%b",
                 local_packet_out,
                 local_valid);

        $display("NORTH : %h V=%b",
                 north_packet_out,
                 north_valid);

        $display("SOUTH : %h V=%b",
                 south_packet_out,
                 south_valid);

        $display("EAST  : %h V=%b",
                 east_packet_out,
                 east_valid);

        $display("WEST  : %h V=%b",
                 west_packet_out,
                 west_valid);

        $display("------------------------------------------------");

    end

end

endtask


//////////////////////////////////////////////////////////////
// TEST HEADER
//////////////////////////////////////////////////////////////

task test_header;

input [200*8:1] name;

begin

    $display("");
    $display("================================================");
    $display("TEST : %0s", name);
    $display("================================================");

end

endtask


//////////////////////////////////////////////////////////////
// OUTPUT MONITOR
//////////////////////////////////////////////////////////////

always @(posedge clk)
begin

    if(local_valid)
        $display("[%0t] LOCAL OUT : %h",
                 $time, local_packet_out);

    if(north_valid)
        $display("[%0t] NORTH OUT : %h",
                 $time, north_packet_out);

    if(south_valid)
        $display("[%0t] SOUTH OUT : %h",
                 $time, south_packet_out);

    if(east_valid)
        $display("[%0t] EAST OUT  : %h",
                 $time, east_packet_out);

    if(west_valid)
        $display("[%0t] WEST OUT  : %h",
                 $time, west_packet_out);

end


//////////////////////////////////////////////////////////////
// MAIN TEST
//////////////////////////////////////////////////////////////

initial
begin

    //////////////////////////////////////////////////////////
    // INITIALIZATION
    //////////////////////////////////////////////////////////

    clk = 0;
    rst = 1;

    tests_run    = 0;
    tests_passed = 0;
    tests_failed = 0;

    local_packet_in = 0;
    north_packet_in = 0;
    south_packet_in = 0;
    east_packet_in  = 0;
    west_packet_in  = 0;

    clear_writes();

    my_cluster = 0;
    my_row     = 0;
    my_col     = 0;

    local_busy = 0;
    north_busy = 0;
    south_busy = 0;
    east_busy  = 0;
    west_busy  = 0;


    //////////////////////////////////////////////////////////
    // RESET
    //////////////////////////////////////////////////////////

    $display("");
    $display("================================================");
    $display("        ROUTER VERIFICATION START");
    $display("================================================");

    repeat(5)
        @(posedge clk);

    rst = 0;

    repeat(3)
        @(posedge clk);


    //////////////////////////////////////////////////////////
    // TEST 1
    // LOCAL INPUT -> SOUTH
    //
    // This is the case we already verified manually.
    //////////////////////////////////////////////////////////

    test_header("LOCAL INPUT -> SOUTH");

    send_local(
        make_packet(
            2'd0,
            2'd1,
            2'd0,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h11111111
        )
    );

    check_output(
        3'd2,
        make_packet(
            2'd0,
            2'd1,
            2'd0,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h11111111
        ),
        20
    );


    //////////////////////////////////////////////////////////
    // TEST 2
    // NORTH INPUT -> EAST
    //
    // Already observed in your previous simulation.
    //////////////////////////////////////////////////////////

    test_header("NORTH INPUT -> EAST");

    send_north(
        make_packet(
            2'd0,
            2'd2,
            2'd1,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h22222222
        )
    );

    check_output(
        3'd3,
        make_packet(
            2'd0,
            2'd2,
            2'd1,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h22222222
        ),
        20
    );


    //////////////////////////////////////////////////////////
    // TEST 3
    // SOUTH INPUT -> EAST
    //////////////////////////////////////////////////////////

    test_header("SOUTH INPUT -> EAST");

    send_south(
        make_packet(
            2'd0,
            2'd3,
            2'd1,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h33333333
        )
    );

    check_output(
        3'd3,
        make_packet(
            2'd0,
            2'd3,
            2'd1,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h33333333
        ),
        20
    );


    //////////////////////////////////////////////////////////
    // TEST 4
    // EAST INPUT -> EAST
    //////////////////////////////////////////////////////////

    test_header("EAST INPUT -> EAST");

    send_east(
        make_packet(
            2'd0,
            2'd1,
            2'd2,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h44444444
        )
    );

    check_output(
        3'd3,
        make_packet(
            2'd0,
            2'd1,
            2'd2,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h44444444
        ),
        20
    );


    //////////////////////////////////////////////////////////
    // TEST 5
    // WEST INPUT -> EAST
    //////////////////////////////////////////////////////////

    test_header("WEST INPUT -> EAST");

    send_west(
        make_packet(
            2'd0,
            2'd2,
            2'd3,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h55555555
        )
    );

    check_output(
        3'd3,
        make_packet(
            2'd0,
            2'd2,
            2'd3,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h55555555
        ),
        20
    );


    //////////////////////////////////////////////////////////
    // TEST 6
    // SIMULTANEOUS TRAFFIC
    //////////////////////////////////////////////////////////

    test_header("SIMULTANEOUS TRAFFIC");

    fork

        send_local(
            make_packet(
                2'd0,2'd1,2'd1,
                2'd0,2'd0,2'd0,
                2'd0,2'd0,
                32'hAAAA0001
            )
        );

        send_north(
            make_packet(
                2'd0,2'd2,2'd2,
                2'd0,2'd0,2'd0,
                2'd0,2'd0,
                32'hBBBB0002
            )
        );

        send_south(
            make_packet(
                2'd0,2'd3,2'd3,
                2'd0,2'd0,2'd0,
                2'd0,2'd0,
                32'hCCCC0003
            )
        );

        send_east(
            make_packet(
                2'd0,2'd1,2'd3,
                2'd0,2'd0,2'd0,
                2'd0,2'd0,
                32'hDDDD0004
            )
        );

        send_west(
            make_packet(
                2'd0,2'd2,2'd1,
                2'd0,2'd0,2'd0,
                2'd0,2'd0,
                32'hEEEE0005
            )
        );

    join


    // Allow all packets to move through router.

    wait_cycles(30);


    //////////////////////////////////////////////////////////
    // TEST 7
    // CONGESTION
    //////////////////////////////////////////////////////////

    test_header("CONGESTION");

    east_busy  = 1;
    north_busy = 1;

    send_local(
        make_packet(
            2'd0,
            2'd2,
            2'd2,

            2'd0,
            2'd0,
            2'd0,

            2'd0,
            2'd0,

            32'h12345678
        )
    );

    // Give router time to observe congestion.

    wait_cycles(10);

    // Release congestion.

    east_busy  = 0;
    north_busy = 0;

    wait_cycles(20);


    //////////////////////////////////////////////////////////
    // SUMMARY
    //////////////////////////////////////////////////////////

    $display("");
    $display("");
    $display("================================================");
    $display("              SIMULATION SUMMARY");
    $display("================================================");

    $display("Tests Run    : %0d", tests_run);
    $display("Tests Passed : %0d", tests_passed);
    $display("Tests Failed : %0d", tests_failed);

    $display("================================================");


    if(tests_failed == 0)
    begin
        $display("");
        $display("*************** ALL TESTS PASSED ***************");
        $display("");
    end

    else
    begin
        $display("");
        $display("*************** TESTS FAILED *******************");
        $display("");
    end


    #100;

    $finish;

end

endmodule