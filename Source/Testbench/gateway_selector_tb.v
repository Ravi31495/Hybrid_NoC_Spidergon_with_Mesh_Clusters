`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name : gateway_selector_tb
// Description : Testbench for gateway_selector
//
// Tests all possible combinations of:
//     current_cluster = 0,1,2,3
//     dest_cluster    = 0,1,2,3
//
// Expected:
//     Same cluster      -> gateway_required = 0
//     Different cluster -> gateway_required = 1
//////////////////////////////////////////////////////////////////////////////////

module gateway_selector_tb;

    //--------------------------------------------------
    // Testbench Signals
    //--------------------------------------------------

    reg [1:0] current_cluster;
    reg [1:0] dest_cluster;

    wire gateway_required;


    //--------------------------------------------------
    // DUT
    //--------------------------------------------------

    gateway_selector DUT
    (
        .current_cluster(current_cluster),
        .dest_cluster(dest_cluster),
        .gateway_required(gateway_required)
    );


    //--------------------------------------------------
    // Display Task
    //--------------------------------------------------

    task display_result;
    begin

        $display("-----------------------------------------------");
        $display("Current Cluster : %0d", current_cluster);
        $display("Destination     : %0d", dest_cluster);
        $display("Gateway Required : %0d", gateway_required);

    end
    endtask


    //--------------------------------------------------
    // Test
    //--------------------------------------------------

    initial
    begin

        //------------------------------------------------
        // VCD
        //------------------------------------------------

        $dumpfile("gateway_selector_tb.vcd");
        $dumpvars(0, gateway_selector_tb);


        //------------------------------------------------
        // TEST 1 : CLUSTER 0
        //------------------------------------------------

        $display("");
        $display("===============================================");
        $display("TEST 1 : CURRENT CLUSTER 0");
        $display("===============================================");

        current_cluster = 2'd0;

        dest_cluster = 2'd0;
        #10;
        display_result();

        dest_cluster = 2'd1;
        #10;
        display_result();

        dest_cluster = 2'd2;
        #10;
        display_result();

        dest_cluster = 2'd3;
        #10;
        display_result();


        //------------------------------------------------
        // TEST 2 : CLUSTER 1
        //------------------------------------------------

        $display("");
        $display("===============================================");
        $display("TEST 2 : CURRENT CLUSTER 1");
        $display("===============================================");

        current_cluster = 2'd1;

        dest_cluster = 2'd0;
        #10;
        display_result();

        dest_cluster = 2'd1;
        #10;
        display_result();

        dest_cluster = 2'd2;
        #10;
        display_result();

        dest_cluster = 2'd3;
        #10;
        display_result();


        //------------------------------------------------
        // TEST 3 : CLUSTER 2
        //------------------------------------------------

        $display("");
        $display("===============================================");
        $display("TEST 3 : CURRENT CLUSTER 2");
        $display("===============================================");

        current_cluster = 2'd2;

        dest_cluster = 2'd0;
        #10;
        display_result();

        dest_cluster = 2'd1;
        #10;
        display_result();

        dest_cluster = 2'd2;
        #10;
        display_result();

        dest_cluster = 2'd3;
        #10;
        display_result();


        //------------------------------------------------
        // TEST 4 : CLUSTER 3
        //------------------------------------------------

        $display("");
        $display("===============================================");
        $display("TEST 4 : CURRENT CLUSTER 3");
        $display("===============================================");

        current_cluster = 2'd3;

        dest_cluster = 2'd0;
        #10;
        display_result();

        dest_cluster = 2'd1;
        #10;
        display_result();

        dest_cluster = 2'd2;
        #10;
        display_result();

        dest_cluster = 2'd3;
        #10;
        display_result();


        //------------------------------------------------
        // COMPLETE
        //------------------------------------------------

        $display("");
        $display("===============================================");
        $display("SIMULATION COMPLETE");
        $display("===============================================");

        $finish;

    end

endmodule