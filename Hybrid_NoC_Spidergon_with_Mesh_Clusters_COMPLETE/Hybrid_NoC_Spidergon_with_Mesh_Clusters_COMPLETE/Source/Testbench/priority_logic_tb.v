`timescale 1ns / 1ps

module priority_logic_tb;

parameter PRIORITY_BITS = 2;

reg request_in;
reg [PRIORITY_BITS-1:0] priority_in;

wire request_out;
wire [PRIORITY_BITS-1:0] priority_out;

priority_logic
#(
    .PRIORITY_BITS(PRIORITY_BITS)
)
DUT
(
    .request_in(request_in),
    .priority_in(priority_in),

    .request_out(request_out),
    .priority_out(priority_out)
);

initial
begin

    $display("---------------------------------------------");
    $display(" Priority Logic Test");
    $display("---------------------------------------------");
    $display("Time\tReq_In\tPriority_In\tReq_Out\tPriority_Out");

    // Test 1
    request_in  = 0;
    priority_in = 2'b00;
    #10;
    $display("%0t\t%b\t%b\t\t%b\t%b",
             $time, request_in, priority_in,
             request_out, priority_out);

    // Test 2
    request_in  = 1;
    priority_in = 2'b00;
    #10;
    $display("%0t\t%b\t%b\t\t%b\t%b",
             $time, request_in, priority_in,
             request_out, priority_out);

    // Test 3
    request_in  = 1;
    priority_in = 2'b01;
    #10;
    $display("%0t\t%b\t%b\t\t%b\t%b",
             $time, request_in, priority_in,
             request_out, priority_out);

    // Test 4
    request_in  = 1;
    priority_in = 2'b10;
    #10;
    $display("%0t\t%b\t%b\t\t%b\t%b",
             $time, request_in, priority_in,
             request_out, priority_out);

    // Test 5
    request_in  = 1;
    priority_in = 2'b11;
    #10;
    $display("%0t\t%b\t%b\t\t%b\t%b",
             $time, request_in, priority_in,
             request_out, priority_out);

    // Test 6
    request_in  = 0;
    priority_in = 2'b11;
    #10;
    $display("%0t\t%b\t%b\t\t%b\t%b",
             $time, request_in, priority_in,
             request_out, priority_out);

    $display("---------------------------------------------");
    $display("Simulation Completed");
    $display("---------------------------------------------");

    $finish;

end

endmodule