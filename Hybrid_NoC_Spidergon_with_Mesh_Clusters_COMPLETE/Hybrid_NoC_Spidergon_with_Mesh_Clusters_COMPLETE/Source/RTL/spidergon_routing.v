`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name : spidergon_routing
//
// Description :
// Global routing for the experimental 4-cluster Hybrid NoC.
//
// Global topology:
//
//          C0 -------- C1
//           |\        /|
//           | \      / |
//           |  \    /  |
//           |   \  /   |
//           |    XX    |
//           |   /  \   |
//           |  /    \  |
//           | /      \ |
//          C3 -------- C2
//
// Ring links:
//     C0 <-> C1
//     C1 <-> C2
//     C2 <-> C3
//     C3 <-> C0
//
// Extra opposite links:
//     C0 <-> C2
//     C1 <-> C3
//
// Therefore every cluster has a direct connection to every
// other cluster.
//
// Direction mapping:
//
// Cluster 0:
//     C1 -> EAST
//     C2 -> SOUTH
//     C3 -> WEST
//
// Cluster 1:
//     C0 -> NORTH
//     C2 -> SOUTH
//     C3 -> WEST
//
// Cluster 2:
//     C0 -> NORTH
//     C1 -> EAST
//     C3 -> WEST
//
// Cluster 3:
//     C0 -> NORTH
//     C1 -> EAST
//     C2 -> SOUTH
//////////////////////////////////////////////////////////////////////////////////

module spidergon_routing
(
    input  [1:0] current_gateway,
    input  [1:0] dest_gateway,

    output reg [2:0] direction
);

    //--------------------------------------------------
    // Direction Encoding
    //--------------------------------------------------

    localparam LOCAL = 3'b000;
    localparam NORTH = 3'b001;
    localparam SOUTH = 3'b010;
    localparam EAST  = 3'b011;
    localparam WEST  = 3'b100;


    //--------------------------------------------------
    // Routing Logic
    //--------------------------------------------------

    always @(*)
    begin

        // Default
        direction = LOCAL;


        //------------------------------------------------
        // Cluster 0
        //------------------------------------------------

        if (current_gateway == 2'd0)
        begin

            case (dest_gateway)

                2'd0:
                    direction = LOCAL;

                2'd1:
                    direction = EAST;

                2'd2:
                    direction = SOUTH;

                2'd3:
                    direction = WEST;

                default:
                    direction = LOCAL;

            endcase

        end


        //------------------------------------------------
        // Cluster 1
        //------------------------------------------------

        else if (current_gateway == 2'd1)
        begin

            case (dest_gateway)

                2'd0:
                    direction = NORTH;

                2'd1:
                    direction = LOCAL;

                2'd2:
                    direction = SOUTH;

                2'd3:
                    direction = WEST;

                default:
                    direction = LOCAL;

            endcase

        end


        //------------------------------------------------
        // Cluster 2
        //------------------------------------------------

        else if (current_gateway == 2'd2)
        begin

            case (dest_gateway)

                2'd0:
                    direction = NORTH;

                2'd1:
                    direction = EAST;

                2'd2:
                    direction = LOCAL;

                2'd3:
                    direction = WEST;

                default:
                    direction = LOCAL;

            endcase

        end


        //------------------------------------------------
        // Cluster 3
        //------------------------------------------------

        else if (current_gateway == 2'd3)
        begin

            case (dest_gateway)

                2'd0:
                    direction = NORTH;

                2'd1:
                    direction = EAST;

                2'd2:
                    direction = SOUTH;

                2'd3:
                    direction = LOCAL;

                default:
                    direction = LOCAL;

            endcase

        end


        //------------------------------------------------
        // Invalid current gateway
        //------------------------------------------------

        else
        begin
            direction = LOCAL;
        end

    end

endmodule