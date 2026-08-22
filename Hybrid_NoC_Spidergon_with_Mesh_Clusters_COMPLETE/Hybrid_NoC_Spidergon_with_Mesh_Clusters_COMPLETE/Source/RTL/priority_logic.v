
`timescale 1ns / 1ps

module priority_logic
#(
    parameter PRIORITY_BITS = 2
)
(
    input request_in,
    input [PRIORITY_BITS-1:0] priority_in,

    output reg request_out,
    output reg [PRIORITY_BITS-1:0] priority_out
);

always @(*)
begin

    if(request_in)
    begin
        request_out  = 1'b1;
        priority_out = priority_in;
    end
    else
    begin
        request_out  = 1'b0;
        priority_out = {PRIORITY_BITS{1'b0}};
    end

end

endmodule

