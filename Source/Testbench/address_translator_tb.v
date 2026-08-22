`timescale 1ns / 1ps

`include "noc_defines.vh"

//////////////////////////////////////////////////////////////////////////////////
// Module Name : address_translator_tb
// Description : Functional verification of address_translator
//////////////////////////////////////////////////////////////////////////////////

module address_translator_tb;

    reg [`PACKET_WIDTH-1:0] packet;

    wire [`CLUSTER_BITS-1:0] dest_cluster;
    wire [`ROW_BITS-1:0]     dest_row;
    wire [`COL_BITS-1:0]     dest_col;

    wire [`CLUSTER_BITS-1:0] src_cluster;
    wire [`ROW_BITS-1:0]     src_row;
    wire [`COL_BITS-1:0]     src_col;

    wire [`TYPE_BITS-1:0]     packet_type;
    wire [`PRIORITY_BITS-1:0] packet_priority;

    wire [`PAYLOAD_BITS-1:0] payload;

    integer errors;


    ////////////////////////////////////////////////////////////////////////////
    // DUT
    ////////////////////////////////////////////////////////////////////////////

    address_translator DUT
    (
        .packet          (packet),

        .dest_cluster    (dest_cluster),
        .dest_row        (dest_row),
        .dest_col        (dest_col),

        .src_cluster     (src_cluster),
        .src_row         (src_row),
        .src_col         (src_col),

        .packet_type     (packet_type),
        .packet_priority (packet_priority),

        .payload         (payload)
    );


    ////////////////////////////////////////////////////////////////////////////
    // Test task
    ////////////////////////////////////////////////////////////////////////////

    task check_packet;

        input [1:0] expected_dest_cluster;
        input [1:0] expected_dest_row;
        input [1:0] expected_dest_col;

        input [1:0] expected_src_cluster;
        input [1:0] expected_src_row;
        input [1:0] expected_src_col;

        input [1:0] expected_packet_type;
        input [1:0] expected_packet_priority;

        input [31:0] expected_payload;

        begin

            #1;

            if (dest_cluster !== expected_dest_cluster) begin
                $display("ERROR: dest_cluster");
                errors = errors + 1;
            end

            if (dest_row !== expected_dest_row) begin
                $display("ERROR: dest_row");
                errors = errors + 1;
            end

            if (dest_col !== expected_dest_col) begin
                $display("ERROR: dest_col");
                errors = errors + 1;
            end

            if (src_cluster !== expected_src_cluster) begin
                $display("ERROR: src_cluster");
                errors = errors + 1;
            end

            if (src_row !== expected_src_row) begin
                $display("ERROR: src_row");
                errors = errors + 1;
            end

            if (src_col !== expected_src_col) begin
                $display("ERROR: src_col");
                errors = errors + 1;
            end

            if (packet_type !== expected_packet_type) begin
                $display("ERROR: packet_type");
                errors = errors + 1;
            end

            if (packet_priority !== expected_packet_priority) begin
                $display("ERROR: packet_priority");
                errors = errors + 1;
            end

            if (payload !== expected_payload) begin
                $display("ERROR: payload");
                errors = errors + 1;
            end

        end

    endtask


    ////////////////////////////////////////////////////////////////////////////
    // Test sequence
    ////////////////////////////////////////////////////////////////////////////

    initial begin

        errors = 0;
        packet = 48'b0;

        $display("");
        $display("===============================================");
        $display(" ADDRESS TRANSLATOR TEST");
        $display("===============================================");


        ////////////////////////////////////////////////////////////////////////
        // TEST 1
        //
        // Destination:
        //   Cluster = 0
        //   Row     = 1
        //   Col     = 2
        //
        // Source:
        //   Cluster = 3
        //   Row     = 2
        //   Col     = 1
        //
        // Type     = 1
        // Priority = 2
        // Payload  = DEADBEEF
        ////////////////////////////////////////////////////////////////////////

        packet = {
            2'd0,       // destination cluster
            2'd1,       // destination row
            2'd2,       // destination column

            2'd3,       // source cluster
            2'd2,       // source row
            2'd1,       // source column

            2'd1,       // packet type
            2'd2,       // packet priority

            32'hDEADBEEF
        };

        check_packet(
            2'd0,
            2'd1,
            2'd2,

            2'd3,
            2'd2,
            2'd1,

            2'd1,
            2'd2,

            32'hDEADBEEF
        );

        $display("TEST 1 PASSED");


        ////////////////////////////////////////////////////////////////////////
        // TEST 2
        ////////////////////////////////////////////////////////////////////////

        packet = {
            2'd3,
            2'd3,
            2'd3,

            2'd0,
            2'd0,
            2'd0,

            2'd2,
            2'd3,

            32'h12345678
        };

        check_packet(
            2'd3,
            2'd3,
            2'd3,

            2'd0,
            2'd0,
            2'd0,

            2'd2,
            2'd3,

            32'h12345678
        );

        $display("TEST 2 PASSED");


        ////////////////////////////////////////////////////////////////////////
        // TEST 3
        ////////////////////////////////////////////////////////////////////////

        packet = {
            2'd2,
            2'd0,
            2'd1,

            2'd1,
            2'd3,
            2'd2,

            2'd0,
            2'd0,

            32'hA5A5A5A5
        };

        check_packet(
            2'd2,
            2'd0,
            2'd1,

            2'd1,
            2'd3,
            2'd2,

            2'd0,
            2'd0,

            32'hA5A5A5A5
        );

        $display("TEST 3 PASSED");


        ////////////////////////////////////////////////////////////////////////
        // RESULT
        ////////////////////////////////////////////////////////////////////////

        $display("");
        $display("===============================================");

        if (errors == 0) begin
            $display("RESULT : ALL TESTS PASSED");
        end
        else begin
            $display("RESULT : %0d ERRORS", errors);
        end

        $display("===============================================");
        $display("");

        $finish;

    end

endmodule