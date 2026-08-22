`timescale 1ns/1ps
`include "noc_defines.vh"

module global_network_4cluster
(
    input clk,
    input rst,

    input [2:0] c0_route_direction,
    input [2:0] c1_route_direction,
    input [2:0] c2_route_direction,
    input [2:0] c3_route_direction,

    input  [`PACKET_WIDTH-1:0] c0_packet_in,
    input                      c0_valid_in,
    output                     c0_ready_out,
    output [`PACKET_WIDTH-1:0] c0_packet_out,
    output                     c0_valid_out,
    input                      c0_ready_in,

    input  [`PACKET_WIDTH-1:0] c1_packet_in,
    input                      c1_valid_in,
    output                     c1_ready_out,
    output [`PACKET_WIDTH-1:0] c1_packet_out,
    output                     c1_valid_out,
    input                      c1_ready_in,

    input  [`PACKET_WIDTH-1:0] c2_packet_in,
    input                      c2_valid_in,
    output                     c2_ready_out,
    output [`PACKET_WIDTH-1:0] c2_packet_out,
    output                     c2_valid_out,
    input                      c2_ready_in,

    input  [`PACKET_WIDTH-1:0] c3_packet_in,
    input                      c3_valid_in,
    output                     c3_ready_out,
    output [`PACKET_WIDTH-1:0] c3_packet_out,
    output                     c3_valid_out,
    input                      c3_ready_in
);

    // =========================================================
    // GLOBAL NETWORK
    //
    // Four independent input FIFOs
    // Four destination outputs
    //
    // Packet destination:
    // packet[47:46]
    //
    // 2'd0 -> C0
    // 2'd1 -> C1
    // 2'd2 -> C2
    // 2'd3 -> C3
    // =========================================================


    // =========================================================
    // FIFO PARAMETERS
    // =========================================================

    localparam FIFO_DEPTH = 8;
    localparam FIFO_ADDR  = 3;


    // =========================================================
    // INPUT FIFO STORAGE
    // =========================================================

    reg [`PACKET_WIDTH-1:0] fifo0 [0:FIFO_DEPTH-1];
    reg [`PACKET_WIDTH-1:0] fifo1 [0:FIFO_DEPTH-1];
    reg [`PACKET_WIDTH-1:0] fifo2 [0:FIFO_DEPTH-1];
    reg [`PACKET_WIDTH-1:0] fifo3 [0:FIFO_DEPTH-1];


    // =========================================================
    // FIFO POINTERS
    // =========================================================

    reg [FIFO_ADDR-1:0] wr_ptr0;
    reg [FIFO_ADDR-1:0] wr_ptr1;
    reg [FIFO_ADDR-1:0] wr_ptr2;
    reg [FIFO_ADDR-1:0] wr_ptr3;

    reg [FIFO_ADDR-1:0] rd_ptr0;
    reg [FIFO_ADDR-1:0] rd_ptr1;
    reg [FIFO_ADDR-1:0] rd_ptr2;
    reg [FIFO_ADDR-1:0] rd_ptr3;


    // =========================================================
    // FIFO COUNTS
    // =========================================================

    reg [FIFO_ADDR:0] count0;
    reg [FIFO_ADDR:0] count1;
    reg [FIFO_ADDR:0] count2;
    reg [FIFO_ADDR:0] count3;


    // =========================================================
    // FIFO STATUS
    // =========================================================

    wire fifo0_empty;
    wire fifo1_empty;
    wire fifo2_empty;
    wire fifo3_empty;

    wire fifo0_full;
    wire fifo1_full;
    wire fifo2_full;
    wire fifo3_full;

    assign fifo0_empty = (count0 == 0);
    assign fifo1_empty = (count1 == 0);
    assign fifo2_empty = (count2 == 0);
    assign fifo3_empty = (count3 == 0);

    assign fifo0_full = (count0 == FIFO_DEPTH);
    assign fifo1_full = (count1 == FIFO_DEPTH);
    assign fifo2_full = (count2 == FIFO_DEPTH);
    assign fifo3_full = (count3 == FIFO_DEPTH);


    // =========================================================
    // READY TO GLOBAL NETWORK
    //
    // Kept asserted because hybrid_noc uses these signals as
    // gateway readiness.
    //
    // The internal FIFOs provide enough buffering for traffic.
    // =========================================================

    assign c0_ready_out = 1'b1;
    assign c1_ready_out = 1'b1;
    assign c2_ready_out = 1'b1;
    assign c3_ready_out = 1'b1;


    // =========================================================
    // CURRENT FIFO HEAD PACKETS
    // =========================================================

    wire [`PACKET_WIDTH-1:0] head0;
    wire [`PACKET_WIDTH-1:0] head1;
    wire [`PACKET_WIDTH-1:0] head2;
    wire [`PACKET_WIDTH-1:0] head3;

    assign head0 = fifo0[rd_ptr0];
    assign head1 = fifo1[rd_ptr1];
    assign head2 = fifo2[rd_ptr2];
    assign head3 = fifo3[rd_ptr3];


    // =========================================================
    // OUTPUT REGISTERS
    // =========================================================

    reg [`PACKET_WIDTH-1:0] c0_packet_out_r;
    reg [`PACKET_WIDTH-1:0] c1_packet_out_r;
    reg [`PACKET_WIDTH-1:0] c2_packet_out_r;
    reg [`PACKET_WIDTH-1:0] c3_packet_out_r;

    reg c0_valid_out_r;
    reg c1_valid_out_r;
    reg c2_valid_out_r;
    reg c3_valid_out_r;


    assign c0_packet_out = c0_packet_out_r;
    assign c1_packet_out = c1_packet_out_r;
    assign c2_packet_out = c2_packet_out_r;
    assign c3_packet_out = c3_packet_out_r;

    assign c0_valid_out = c0_valid_out_r;
    assign c1_valid_out = c1_valid_out_r;
    assign c2_valid_out = c2_valid_out_r;
    assign c3_valid_out = c3_valid_out_r;


    // =========================================================
    // POP SIGNALS
    //
    // A source FIFO is popped only when its head packet has
    // actually been selected for a destination and that
    // destination is ready.
    // =========================================================

    reg pop0;
    reg pop1;
    reg pop2;
    reg pop3;


    // =========================================================
    // GLOBAL CROSSBAR + ARBITRATION
    //
    // Fixed priority:
    //
    // source 0
    // source 1
    // source 2
    // source 3
    //
    // Each destination selects at most ONE source.
    // Therefore two sources can never overwrite the same
    // destination output in the same cycle.
    // =========================================================

    always @(*)
    begin

        // -----------------------------------------------------
        // Defaults
        // -----------------------------------------------------

        c0_packet_out_r = {`PACKET_WIDTH{1'b0}};
        c1_packet_out_r = {`PACKET_WIDTH{1'b0}};
        c2_packet_out_r = {`PACKET_WIDTH{1'b0}};
        c3_packet_out_r = {`PACKET_WIDTH{1'b0}};

        c0_valid_out_r = 1'b0;
        c1_valid_out_r = 1'b0;
        c2_valid_out_r = 1'b0;
        c3_valid_out_r = 1'b0;

        pop0 = 1'b0;
        pop1 = 1'b0;
        pop2 = 1'b0;
        pop3 = 1'b0;


        // =====================================================
        // DESTINATION C0
        // =====================================================

        if (c0_ready_in)
        begin

            if (!fifo0_empty && head0[47:46] == 2'd0)
            begin
                c0_packet_out_r = head0;
                c0_valid_out_r  = 1'b1;
                pop0 = 1'b1;
            end

            else if (!fifo1_empty && head1[47:46] == 2'd0)
            begin
                c0_packet_out_r = head1;
                c0_valid_out_r  = 1'b1;
                pop1 = 1'b1;
            end

            else if (!fifo2_empty && head2[47:46] == 2'd0)
            begin
                c0_packet_out_r = head2;
                c0_valid_out_r  = 1'b1;
                pop2 = 1'b1;
            end

            else if (!fifo3_empty && head3[47:46] == 2'd0)
            begin
                c0_packet_out_r = head3;
                c0_valid_out_r  = 1'b1;
                pop3 = 1'b1;
            end

        end


        // =====================================================
        // DESTINATION C1
        // =====================================================

        if (c1_ready_in)
        begin

            if (!fifo0_empty && head0[47:46] == 2'd1 && !pop0)
            begin
                c1_packet_out_r = head0;
                c1_valid_out_r  = 1'b1;
                pop0 = 1'b1;
            end

            else if (!fifo1_empty && head1[47:46] == 2'd1 && !pop1)
            begin
                c1_packet_out_r = head1;
                c1_valid_out_r  = 1'b1;
                pop1 = 1'b1;
            end

            else if (!fifo2_empty && head2[47:46] == 2'd1 && !pop2)
            begin
                c1_packet_out_r = head2;
                c1_valid_out_r  = 1'b1;
                pop2 = 1'b1;
            end

            else if (!fifo3_empty && head3[47:46] == 2'd1 && !pop3)
            begin
                c1_packet_out_r = head3;
                c1_valid_out_r  = 1'b1;
                pop3 = 1'b1;
            end

        end


        // =====================================================
        // DESTINATION C2
        // =====================================================

        if (c2_ready_in)
        begin

            if (!fifo0_empty && head0[47:46] == 2'd2 && !pop0)
            begin
                c2_packet_out_r = head0;
                c2_valid_out_r  = 1'b1;
                pop0 = 1'b1;
            end

            else if (!fifo1_empty && head1[47:46] == 2'd2 && !pop1)
            begin
                c2_packet_out_r = head1;
                c2_valid_out_r  = 1'b1;
                pop1 = 1'b1;
            end

            else if (!fifo2_empty && head2[47:46] == 2'd2 && !pop2)
            begin
                c2_packet_out_r = head2;
                c2_valid_out_r  = 1'b1;
                pop2 = 1'b1;
            end

            else if (!fifo3_empty && head3[47:46] == 2'd2 && !pop3)
            begin
                c2_packet_out_r = head3;
                c2_valid_out_r  = 1'b1;
                pop3 = 1'b1;
            end

        end


        // =====================================================
        // DESTINATION C3
        // =====================================================

        if (c3_ready_in)
        begin

            if (!fifo0_empty && head0[47:46] == 2'd3 && !pop0)
            begin
                c3_packet_out_r = head0;
                c3_valid_out_r  = 1'b1;
                pop0 = 1'b1;
            end

            else if (!fifo1_empty && head1[47:46] == 2'd3 && !pop1)
            begin
                c3_packet_out_r = head1;
                c3_valid_out_r  = 1'b1;
                pop1 = 1'b1;
            end

            else if (!fifo2_empty && head2[47:46] == 2'd3 && !pop2)
            begin
                c3_packet_out_r = head2;
                c3_valid_out_r  = 1'b1;
                pop2 = 1'b1;
            end

            else if (!fifo3_empty && head3[47:46] == 2'd3 && !pop3)
            begin
                c3_packet_out_r = head3;
                c3_valid_out_r  = 1'b1;
                pop3 = 1'b1;
            end

        end

    end


    // =========================================================
    // FIFO WRITE / READ CONTROL
    //
    // IMPORTANT:
    // All FIFO state is updated in ONE always block.
    //
    // This avoids multiple always blocks driving the same
    // buffer_valid/count registers.
    // =========================================================

    always @(posedge clk)
    begin

        if (rst)
        begin

            wr_ptr0 <= 0;
            wr_ptr1 <= 0;
            wr_ptr2 <= 0;
            wr_ptr3 <= 0;

            rd_ptr0 <= 0;
            rd_ptr1 <= 0;
            rd_ptr2 <= 0;
            rd_ptr3 <= 0;

            count0 <= 0;
            count1 <= 0;
            count2 <= 0;
            count3 <= 0;

        end

        else
        begin

            // =================================================
            // SOURCE C0 FIFO
            // =================================================

            case ({(c0_valid_in && !fifo0_full), pop0})

                2'b10:
                begin

                    fifo0[wr_ptr0] <= c0_packet_in;
                    wr_ptr0 <= wr_ptr0 + 1'b1;
                    count0 <= count0 + 1'b1;

                end

                2'b01:
                begin

                    rd_ptr0 <= rd_ptr0 + 1'b1;
                    count0 <= count0 - 1'b1;

                end

                2'b11:
                begin

                    fifo0[wr_ptr0] <= c0_packet_in;

                    wr_ptr0 <= wr_ptr0 + 1'b1;
                    rd_ptr0 <= rd_ptr0 + 1'b1;

                    count0 <= count0;

                end

                default:
                begin
                end

            endcase


            // =================================================
            // SOURCE C1 FIFO
            // =================================================

            case ({(c1_valid_in && !fifo1_full), pop1})

                2'b10:
                begin

                    fifo1[wr_ptr1] <= c1_packet_in;
                    wr_ptr1 <= wr_ptr1 + 1'b1;
                    count1 <= count1 + 1'b1;

                end

                2'b01:
                begin

                    rd_ptr1 <= rd_ptr1 + 1'b1;
                    count1 <= count1 - 1'b1;

                end

                2'b11:
                begin

                    fifo1[wr_ptr1] <= c1_packet_in;

                    wr_ptr1 <= wr_ptr1 + 1'b1;
                    rd_ptr1 <= rd_ptr1 + 1'b1;

                    count1 <= count1;

                end

                default:
                begin
                end

            endcase


            // =================================================
            // SOURCE C2 FIFO
            // =================================================

            case ({(c2_valid_in && !fifo2_full), pop2})

                2'b10:
                begin

                    fifo2[wr_ptr2] <= c2_packet_in;
                    wr_ptr2 <= wr_ptr2 + 1'b1;
                    count2 <= count2 + 1'b1;

                end

                2'b01:
                begin

                    rd_ptr2 <= rd_ptr2 + 1'b1;
                    count2 <= count2 - 1'b1;

                end

                2'b11:
                begin

                    fifo2[wr_ptr2] <= c2_packet_in;

                    wr_ptr2 <= wr_ptr2 + 1'b1;
                    rd_ptr2 <= rd_ptr2 + 1'b1;

                    count2 <= count2;

                end

                default:
                begin
                end

            endcase


            // =================================================
            // SOURCE C3 FIFO
            // =================================================

            case ({(c3_valid_in && !fifo3_full), pop3})

                2'b10:
                begin

                    fifo3[wr_ptr3] <= c3_packet_in;
                    wr_ptr3 <= wr_ptr3 + 1'b1;
                    count3 <= count3 + 1'b1;

                end

                2'b01:
                begin

                    rd_ptr3 <= rd_ptr3 + 1'b1;
                    count3 <= count3 - 1'b1;

                end

                2'b11:
                begin

                    fifo3[wr_ptr3] <= c3_packet_in;

                    wr_ptr3 <= wr_ptr3 + 1'b1;
                    rd_ptr3 <= rd_ptr3 + 1'b1;

                    count3 <= count3;

                end

                default:
                begin
                end

            endcase

        end

    end

endmodule