`timescale 1ns / 1ps

module grant_to_select
(
    input  [5:0] grant,
    output reg [2:0] sel
);

always @(*)
begin

    case (grant)

        6'b000001:
            sel = 3'd0;       // LOCAL

        6'b000010:
            sel = 3'd1;       // NORTH

        6'b000100:
            sel = 3'd2;       // SOUTH

        6'b001000:
            sel = 3'd3;       // EAST

        6'b010000:
            sel = 3'd4;       // WEST

        6'b100000:
            sel = 3'd5;       // GATEWAY

        default:
            sel = 3'd0;

    endcase

end

endmodule