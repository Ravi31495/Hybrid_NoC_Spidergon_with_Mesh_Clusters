`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name : spidergon_routing_tb
//
// Description :
// Exhaustive testbench for the 4-cluster global routing logic.
//
// Tests all 16 combinations of:
//     current_gateway = 0,1,2,3
//     dest_gateway    = 0,1,2,3
//////////////////////////////////////////////////////////////////////////////////

module spidergon_routing_tb;

    //--------------------------------------------------
    // Testbench Signals
    //--------------------------------------------------

    reg [1:0] current_gateway;
    reg [1:0] dest_gateway;

    wire [2:0] direction;


    //--------------------------------------------------
    // Direction Names
    //--------------------------------------------------

    localparam LOCAL = 3'b000;
    localparam NORTH = 3'b001;
    localparam SOUTH = 3'b010;
    localparam EAST  = 3'b011;
    localparam WEST  = 3'b100;


    //--------------------------------------------------
    // DUT
    //--------------------------------------------------

    spidergon_routing DUT
    (
        .current_gateway(current_gateway),
        .dest_gateway(dest_gateway),
        .direction(direction)
    );


    //--------------------------------------------------
    // Display Task
    //--------------------------------------------------

    task display_result;

        begin

            $display("--------------------------------------");

            $write("Current Cluster : %0d\n", current_gateway);
            $write("Dest Cluster    : %0d\n", dest_gateway);

            case (direction)

                LOCAL:
                    $display("Direction       : LOCAL (000)");

                NORTH:
                    $display("Direction       : NORTH (001)");

                SOUTH:
                    $display("Direction       : SOUTH (010)");

                EAST:
                    $display("Direction       : EAST  (011)");

                WEST:
                    $display("Direction       : WEST  (100)");

                default:
                    $display("Direction       : INVALID");

            endcase

        end

    endtask


    //--------------------------------------------------
    // Simulation
    //--------------------------------------------------

    initial
    begin

        //------------------------------------------------
        // VCD
        //------------------------------------------------

        $dumpfile("spidergon_routing_tb.vcd");
        $dumpvars(0, spidergon_routing_tb);


        //------------------------------------------------
        // Header
        //------------------------------------------------

        $display("");
        $display("======================================");
        $display("   GLOBAL 4-CLUSTER ROUTING TEST");
        $display("======================================");


        //------------------------------------------------
        // Cluster 0
        //------------------------------------------------

        $display("");
        $display("======================================");
        $display("CLUSTER 0");
        $display("======================================");

        current_gateway = 2'd0;

        dest_gateway = 2'd0;
        #10;
        display_result();

        dest_gateway = 2'd1;
        #10;
        display_result();

        dest_gateway = 2'd2;
        #10;
        display_result();

        dest_gateway = 2'd3;
        #10;
        display_result();


        //------------------------------------------------
        // Cluster 1
        //------------------------------------------------

        $display("");
        $display("======================================");
        $display("CLUSTER 1");
        $display("======================================");

        current_gateway = 2'd1;

        dest_gateway = 2'd0;
        #10;
        display_result();

        dest_gateway = 2'd1;
        #10;
        display_result();

        dest_gateway = 2'd2;
        #10;
        display_result();

        dest_gateway = 2'd3;
        #10;
        display_result();


        //------------------------------------------------
        // Cluster 2
        //------------------------------------------------

        $display("");
        $display("======================================");
        $display("CLUSTER 2");
        $display("======================================");

        current_gateway = 2'd2;

        dest_gateway = 2'd0;
        #10;
        display_result();

        dest_gateway = 2'd1;
        #10;
        display_result();

        dest_gateway = 2'd2;
        #10;
        display_result();

        dest_gateway = 2'd3;
        #10;
        display_result();


        //------------------------------------------------
        // Cluster 3
        //------------------------------------------------

        $display("");
        $display("======================================");
        $display("CLUSTER 3");
        $display("======================================");

        current_gateway = 2'd3;

        dest_gateway = 2'd0;
        #10;
        display_result();

        dest_gateway = 2'd1;
        #10;
        display_result();

        dest_gateway = 2'd2;
        #10;
        display_result();

        dest_gateway = 2'd3;
        #10;
        display_result();


        //------------------------------------------------
        // Complete
        //------------------------------------------------

        $display("");
        $display("======================================");
        $display("SIMULATION COMPLETE");
        $display("======================================");

        $finish;

    end

endmodule