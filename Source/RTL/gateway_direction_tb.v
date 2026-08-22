`timescale 1ns / 1ps

module gateway_direction_tb;

reg  [1:0] current_cluster;
reg  [1:0] dest_cluster;

wire [1:0] direction;

gateway_direction DUT
(
    .current_cluster(current_cluster),
    .dest_cluster(dest_cluster),
    .direction(direction)
);

initial
begin

    $dumpfile("gateway_direction_tb.vcd");
    $dumpvars(0,gateway_direction_tb);

    /////////////////////////////////////////////////////
    // Cluster 0
    /////////////////////////////////////////////////////

    $display("\n======================================");
    $display("CLUSTER 0");
    $display("======================================");

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

    /////////////////////////////////////////////////////
    // Cluster 1
    /////////////////////////////////////////////////////

    $display("\n======================================");
    $display("CLUSTER 1");
    $display("======================================");

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

    /////////////////////////////////////////////////////
    // Cluster 2
    /////////////////////////////////////////////////////

    $display("\n======================================");
    $display("CLUSTER 2");
    $display("======================================");

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

    /////////////////////////////////////////////////////
    // Cluster 3
    /////////////////////////////////////////////////////

    $display("\n======================================");
    $display("CLUSTER 3");
    $display("======================================");

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

    $display("\n======================================");
    $display("SIMULATION COMPLETE");
    $display("======================================");

    $finish;

end

task display_result;
begin

    $display("--------------------------------------");
    $display("Current Cluster : %0d", current_cluster);
    $display("Dest Cluster    : %0d", dest_cluster);
    $display("Direction       : %0d (%02b)", direction, direction);

end
endtask

endmodule