`timescale 1ns / 1ps

module round_robin_arbiter_tb;

parameter NUM_PORTS = 5;

reg clk;
reg rst;

reg  [NUM_PORTS-1:0] request;
wire [NUM_PORTS-1:0] grant;

round_robin_arbiter
#(
    .NUM_PORTS(NUM_PORTS)
)
DUT
(
    .clk(clk),
    .rst(rst),
    .request(request),
    .grant(grant)
);

/////////////////////////////////////////////////////////////
// Clock Generation
/////////////////////////////////////////////////////////////

initial
begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

/////////////////////////////////////////////////////////////
// Test Sequence
/////////////////////////////////////////////////////////////

initial
begin

    rst = 1'b1;
    request = 5'b00000;

    #12;
    rst = 1'b0;

    //--------------------------------------------------------
    // Test 1 : Single Requests
    //--------------------------------------------------------

    @(posedge clk);
    request = 5'b00001;

    @(posedge clk);
    request = 5'b00010;

    @(posedge clk);
    request = 5'b00100;

    @(posedge clk);
    request = 5'b01000;

    @(posedge clk);
    request = 5'b10000;

    //--------------------------------------------------------
    // Test 2 : All Ports Request Together
    //--------------------------------------------------------

    @(posedge clk);
    request = 5'b11111;

    repeat(10)
        @(posedge clk);

    //--------------------------------------------------------
    // Test 3 : Three Ports Request
    //--------------------------------------------------------

    request = 5'b00111;

    repeat(8)
        @(posedge clk);

    //--------------------------------------------------------
    // Test 4 : Alternate Ports
    //--------------------------------------------------------

    request = 5'b10101;

    repeat(8)
        @(posedge clk);

    //--------------------------------------------------------
    // Test 5 : No Request
    //--------------------------------------------------------

    request = 5'b00000;

    repeat(2)
        @(posedge clk);

    $finish;

end

/////////////////////////////////////////////////////////////
// Monitor
/////////////////////////////////////////////////////////////

initial
begin

    $display("-------------------------------------------------------");
    $display("Time\tRequest\tGrant");
    $display("-------------------------------------------------------");

    $monitor("%0t\t%b\t%b",
             $time,
             request,
             grant);

end

endmodule