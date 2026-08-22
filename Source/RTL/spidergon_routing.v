`timescale 1ns / 1ps

module spidergon_routing
(
    input  [1:0] current_gateway,
    input  [1:0] dest_gateway,
    output reg [2:0] direction
);
    localparam LOCAL = 3'b000;
    localparam NORTH = 3'b001;
    localparam SOUTH = 3'b010;
    localparam EAST  = 3'b011;
    localparam WEST  = 3'b100;

    always @(*) begin
        direction = LOCAL;
        if (current_gateway == 2'd0) begin
            case (dest_gateway)
                2'd0: direction = LOCAL;
                2'd1: direction = EAST;
                2'd2: direction = SOUTH;
                2'd3: direction = WEST;
                default: direction = LOCAL;
            endcase
        end else if (current_gateway == 2'd1) begin
            case (dest_gateway)
                2'd0: direction = NORTH;
                2'd1: direction = LOCAL;
                2'd2: direction = SOUTH;
                2'd3: direction = WEST;
                default: direction = LOCAL;
            endcase
        end else if (current_gateway == 2'd2) begin
            case (dest_gateway)
                2'd0: direction = NORTH;
                2'd1: direction = EAST;
                2'd2: direction = LOCAL;
                2'd3: direction = WEST;
                default: direction = LOCAL;
            endcase
        end else if (current_gateway == 2'd3) begin
            case (dest_gateway)
                2'd0: direction = NORTH;
                2'd1: direction = EAST;
                2'd2: direction = SOUTH;
                2'd3: direction = LOCAL;
                default: direction = LOCAL;
            endcase
        end
    end
endmodule
