`timescale 1ns / 1ps

module hop_calculator_tb;

reg [1:0] current_row;
reg [1:0] current_col;

reg [1:0] dest_row;
reg [1:0] dest_col;

wire [2:0] total_hops;

hop_calculator DUT
(
    .current_row(current_row),
    .current_col(current_col),
    .dest_row(dest_row),
    .dest_col(dest_col),
    .total_hops(total_hops)
);

initial
begin

    // Test Case 1
    current_row = 2'd1;
    current_col = 2'd2;
    dest_row    = 2'd3;
    dest_col    = 2'd0;

    #20;

    // Expected: |3-1| + |0-2| = 2 + 2 = 4

    // Test Case 2
    current_row = 2'd0;
    current_col = 2'd0;
    dest_row    = 2'd3;
    dest_col    = 2'd3;

    #20;

    // Expected: 6

    // Test Case 3
    current_row = 2'd2;
    current_col = 2'd1;
    dest_row    = 2'd2;
    dest_col    = 2'd1;

    #20;

    // Expected: 0

    $finish;

end

endmodule