`timescale 1ns / 1ps

module xy_routing_tb;

reg [1:0] current_row;
reg [1:0] current_col;

reg [1:0] dest_row;
reg [1:0] dest_col;

wire [2:0] direction;

xy_routing DUT
(
.current_row(current_row),
.current_col(current_col),
.dest_row(dest_row),
.dest_col(dest_col),
.direction(direction)
);

initial
begin

//----------------------
// EAST
//----------------------

current_row = 1;
current_col = 1;

dest_row = 1;
dest_col = 3;

#20;

//----------------------
// WEST
//----------------------

current_row = 2;
current_col = 3;

dest_row = 2;
dest_col = 1;

#20;

//----------------------
// SOUTH
//----------------------

current_row = 0;
current_col = 2;

dest_row = 3;
dest_col = 2;

#20;

//----------------------
// NORTH
//----------------------

current_row = 3;
current_col = 1;

dest_row = 0;
dest_col = 1;

#20;

//----------------------
// LOCAL
//----------------------

current_row = 2;
current_col = 2;

dest_row = 2;
dest_col = 2;

#20;

$finish;

end

endmodule