`timescale 1ns / 1ps

module round_robin_arbiter
#(
    parameter NUM_PORTS = 6
)
(
    input clk,
    input rst,
    input  [NUM_PORTS-1:0] request,
    output reg [NUM_PORTS-1:0] grant
);

    reg [2:0] last_grant;

    integer i;
    integer index;
    reg found;

    // Current request -> current grant.
    // Only last_grant is state.
    always @(*)
    begin
        grant = {NUM_PORTS{1'b0}};
        found = 1'b0;

        for (i = 1; i <= NUM_PORTS; i = i + 1)
        begin
            index = last_grant;
            index = index + i;

            if (index >= NUM_PORTS)
                index = index - NUM_PORTS;

            if ((!found) && request[index])
            begin
                grant[index] = 1'b1;
                found = 1'b1;
            end
        end
    end

    // Remember the winner for round-robin ordering.
    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            // First search checks port 0.
            last_grant <= 3'd5;
        end
        else if (|grant)
        begin
            for (i = 0; i < NUM_PORTS; i = i + 1)
            begin
                if (grant[i])
                    last_grant <= i;
            end
        end
    end

endmodule
