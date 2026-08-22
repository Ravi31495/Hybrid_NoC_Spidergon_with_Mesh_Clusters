`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : gateway_direction
// Description : Selects which global link should be used for inter-cluster
//               communication.
//////////////////////////////////////////////////////////////////////////////////

module gateway_direction
(
    input  [1:0] current_cluster,
    input  [1:0] dest_cluster,

    output reg [1:0] direction
);

//////////////////////////////////////////////////////
// Direction Encoding
//////////////////////////////////////////////////////

localparam EAST  = 2'd0;
localparam SOUTH = 2'd1;
localparam WEST  = 2'd2;
localparam LOCAL = 2'd3;

always @(*)
begin

    //--------------------------------------------------
    // Default
    //--------------------------------------------------

    direction = LOCAL;

    //--------------------------------------------------
    // Cluster 0
    //--------------------------------------------------

    case(current_cluster)

        2'd0:
        begin

            case(dest_cluster)

                2'd0 : direction = LOCAL;

                2'd1 : direction = EAST;

                2'd2 : direction = SOUTH;   // diagonal

                2'd3 : direction = WEST;

            endcase

        end

    //--------------------------------------------------
    // Cluster 1
    //--------------------------------------------------

        2'd1:
        begin

            case(dest_cluster)

                2'd1 : direction = LOCAL;

                2'd2 : direction = EAST;

                2'd3 : direction = SOUTH;   // diagonal

                2'd0 : direction = WEST;

            endcase

        end

    //--------------------------------------------------
    // Cluster 2
    //--------------------------------------------------

        2'd2:
        begin

            case(dest_cluster)

                2'd2 : direction = LOCAL;

                2'd3 : direction = EAST;

                2'd0 : direction = SOUTH;   // diagonal

                2'd1 : direction = WEST;

            endcase

        end

    //--------------------------------------------------
    // Cluster 3
    //--------------------------------------------------

        2'd3:
        begin

            case(dest_cluster)

                2'd3 : direction = LOCAL;

                2'd0 : direction = EAST;

                2'd1 : direction = SOUTH;   // diagonal

                2'd2 : direction = WEST;

            endcase

        end

    endcase

end

endmodule