`timescale 1ns/1ps
`include "noc_defines.vh"

module hybrid_noc_comprehensive_tb_final;

    // =========================================================
    // CLOCK / RESET
    // =========================================================

    reg clk;
    reg rst;

    always #5 clk = ~clk;


    // =========================================================
    // INPUTS
    // =========================================================

    reg [`PACKET_WIDTH-1:0] c0_in0, c0_in1, c0_in2, c0_in3;
    reg [`PACKET_WIDTH-1:0] c1_in0, c1_in1, c1_in2, c1_in3;
    reg [`PACKET_WIDTH-1:0] c2_in0, c2_in1, c2_in2, c2_in3;
    reg [`PACKET_WIDTH-1:0] c3_in0, c3_in1, c3_in2, c3_in3;

    reg c0_w0, c0_w1, c0_w2, c0_w3;
    reg c1_w0, c1_w1, c1_w2, c1_w3;
    reg c2_w0, c2_w1, c2_w2, c2_w3;
    reg c3_w0, c3_w1, c3_w2, c3_w3;


    // =========================================================
    // OUTPUTS
    // =========================================================

    wire [`PACKET_WIDTH-1:0] c0_out0, c0_out1, c0_out2, c0_out3;
    wire [`PACKET_WIDTH-1:0] c1_out0, c1_out1, c1_out2, c1_out3;
    wire [`PACKET_WIDTH-1:0] c2_out0, c2_out1, c2_out2, c2_out3;
    wire [`PACKET_WIDTH-1:0] c3_out0, c3_out1, c3_out2, c3_out3;

    wire c0_v0, c0_v1, c0_v2, c0_v3;
    wire c1_v0, c1_v1, c1_v2, c1_v3;
    wire c2_v0, c2_v1, c2_v2, c2_v3;
    wire c3_v0, c3_v1, c3_v2, c3_v3;


    // =========================================================
    // COUNTERS
    // =========================================================

    integer total_tests;
    integer total_passed;
    integer total_failed;

    integer basic_tests;
    integer basic_passed;
    integer basic_failed;

    integer stress_tests;
    integer stress_passed;
    integer stress_failed;

    integer i;


    // =========================================================
    // DUT
    // =========================================================

    hybrid_noc DUT
    (
        .clk(clk),
        .rst(rst),

        .c0_local_packet_in0(c0_in0),
        .c0_local_packet_in1(c0_in1),
        .c0_local_packet_in2(c0_in2),
        .c0_local_packet_in3(c0_in3),

        .c0_local_write0(c0_w0),
        .c0_local_write1(c0_w1),
        .c0_local_write2(c0_w2),
        .c0_local_write3(c0_w3),

        .c1_local_packet_in0(c1_in0),
        .c1_local_packet_in1(c1_in1),
        .c1_local_packet_in2(c1_in2),
        .c1_local_packet_in3(c1_in3),

        .c1_local_write0(c1_w0),
        .c1_local_write1(c1_w1),
        .c1_local_write2(c1_w2),
        .c1_local_write3(c1_w3),

        .c2_local_packet_in0(c2_in0),
        .c2_local_packet_in1(c2_in1),
        .c2_local_packet_in2(c2_in2),
        .c2_local_packet_in3(c2_in3),

        .c2_local_write0(c2_w0),
        .c2_local_write1(c2_w1),
        .c2_local_write2(c2_w2),
        .c2_local_write3(c2_w3),

        .c3_local_packet_in0(c3_in0),
        .c3_local_packet_in1(c3_in1),
        .c3_local_packet_in2(c3_in2),
        .c3_local_packet_in3(c3_in3),

        .c3_local_write0(c3_w0),
        .c3_local_write1(c3_w1),
        .c3_local_write2(c3_w2),
        .c3_local_write3(c3_w3),

        .c0_local_packet_out0(c0_out0),
        .c0_local_packet_out1(c0_out1),
        .c0_local_packet_out2(c0_out2),
        .c0_local_packet_out3(c0_out3),

        .c0_local_valid0(c0_v0),
        .c0_local_valid1(c0_v1),
        .c0_local_valid2(c0_v2),
        .c0_local_valid3(c0_v3),

        .c1_local_packet_out0(c1_out0),
        .c1_local_packet_out1(c1_out1),
        .c1_local_packet_out2(c1_out2),
        .c1_local_packet_out3(c1_out3),

        .c1_local_valid0(c1_v0),
        .c1_local_valid1(c1_v1),
        .c1_local_valid2(c1_v2),
        .c1_local_valid3(c1_v3),

        .c2_local_packet_out0(c2_out0),
        .c2_local_packet_out1(c2_out1),
        .c2_local_packet_out2(c2_out2),
        .c2_local_packet_out3(c2_out3),

        .c2_local_valid0(c2_v0),
        .c2_local_valid1(c2_v1),
        .c2_local_valid2(c2_v2),
        .c2_local_valid3(c2_v3),

        .c3_local_packet_out0(c3_out0),
        .c3_local_packet_out1(c3_out1),
        .c3_local_packet_out2(c3_out2),
        .c3_local_packet_out3(c3_out3),

        .c3_local_valid0(c3_v0),
        .c3_local_valid1(c3_v1),
        .c3_local_valid2(c3_v2),
        .c3_local_valid3(c3_v3)
    );


    // =========================================================
    // CLEAR INPUTS
    // =========================================================

    task clear_inputs;
    begin

        c0_in0 = 0;
        c0_in1 = 0;
        c0_in2 = 0;
        c0_in3 = 0;

        c1_in0 = 0;
        c1_in1 = 0;
        c1_in2 = 0;
        c1_in3 = 0;

        c2_in0 = 0;
        c2_in1 = 0;
        c2_in2 = 0;
        c2_in3 = 0;

        c3_in0 = 0;
        c3_in1 = 0;
        c3_in2 = 0;
        c3_in3 = 0;

        c0_w0 = 0;
        c0_w1 = 0;
        c0_w2 = 0;
        c0_w3 = 0;

        c1_w0 = 0;
        c1_w1 = 0;
        c1_w2 = 0;
        c1_w3 = 0;

        c2_w0 = 0;
        c2_w1 = 0;
        c2_w2 = 0;
        c2_w3 = 0;

        c3_w0 = 0;
        c3_w1 = 0;
        c3_w2 = 0;
        c3_w3 = 0;

    end
    endtask


    // =========================================================
    // RESET
    // =========================================================

    task reset_dut;
    begin

        clear_inputs;

        rst = 1;

        repeat(3)
            @(posedge clk);

        rst = 0;

        repeat(2)
            @(posedge clk);

    end
    endtask


    // =========================================================
    // CREATE PACKET
    // =========================================================

    function [`PACKET_WIDTH-1:0] make_packet;

        input integer sc;
        input integer sp;
        input integer dc;
        input integer dp;
        input [31:0] payload;

        integer sr;
        integer scol;
        integer dr;
        integer dcol;

        begin

            case(sp)
                0: begin sr = 0; scol = 0; end
                1: begin sr = 0; scol = 1; end
                2: begin sr = 1; scol = 0; end
                3: begin sr = 1; scol = 1; end
            endcase

            case(dp)
                0: begin dr = 0; dcol = 0; end
                1: begin dr = 0; dcol = 1; end
                2: begin dr = 1; dcol = 0; end
                3: begin dr = 1; dcol = 1; end
            endcase

            make_packet =
            {
                dc[1:0],
                dr[1:0],
                dcol[1:0],

                sc[1:0],
                sr[1:0],
                scol[1:0],

                2'd0,
                2'd0,

                payload
            };

        end

    endfunction


    // =========================================================
    // INJECT ONE PACKET
    // =========================================================

    task inject_one;

        input integer cluster;
        input integer port;
        input [`PACKET_WIDTH-1:0] packet;

        begin

            case(cluster)

                0:
                begin
                    case(port)
                        0: begin c0_in0 = packet; c0_w0 = 1; end
                        1: begin c0_in1 = packet; c0_w1 = 1; end
                        2: begin c0_in2 = packet; c0_w2 = 1; end
                        3: begin c0_in3 = packet; c0_w3 = 1; end
                    endcase
                end

                1:
                begin
                    case(port)
                        0: begin c1_in0 = packet; c1_w0 = 1; end
                        1: begin c1_in1 = packet; c1_w1 = 1; end
                        2: begin c1_in2 = packet; c1_w2 = 1; end
                        3: begin c1_in3 = packet; c1_w3 = 1; end
                    endcase
                end

                2:
                begin
                    case(port)
                        0: begin c2_in0 = packet; c2_w0 = 1; end
                        1: begin c2_in1 = packet; c2_w1 = 1; end
                        2: begin c2_in2 = packet; c2_w2 = 1; end
                        3: begin c2_in3 = packet; c2_w3 = 1; end
                    endcase
                end

                3:
                begin
                    case(port)
                        0: begin c3_in0 = packet; c3_w0 = 1; end
                        1: begin c3_in1 = packet; c3_w1 = 1; end
                        2: begin c3_in2 = packet; c3_w2 = 1; end
                        3: begin c3_in3 = packet; c3_w3 = 1; end
                    endcase
                end

            endcase

            @(negedge clk);

            clear_inputs;

        end

    endtask


    // =========================================================
    // READ OUTPUT
    // =========================================================

    task get_output;

        input integer cluster;
        input integer port;

        output reg valid;
        output reg [`PACKET_WIDTH-1:0] packet;

        begin

            valid = 0;
            packet = 0;

            case(cluster)

                0:
                begin
                    case(port)
                        0: begin valid = c0_v0; packet = c0_out0; end
                        1: begin valid = c0_v1; packet = c0_out1; end
                        2: begin valid = c0_v2; packet = c0_out2; end
                        3: begin valid = c0_v3; packet = c0_out3; end
                    endcase
                end

                1:
                begin
                    case(port)
                        0: begin valid = c1_v0; packet = c1_out0; end
                        1: begin valid = c1_v1; packet = c1_out1; end
                        2: begin valid = c1_v2; packet = c1_out2; end
                        3: begin valid = c1_v3; packet = c1_out3; end
                    endcase
                end

                2:
                begin
                    case(port)
                        0: begin valid = c2_v0; packet = c2_out0; end
                        1: begin valid = c2_v1; packet = c2_out1; end
                        2: begin valid = c2_v2; packet = c2_out2; end
                        3: begin valid = c2_v3; packet = c2_out3; end
                    endcase
                end

                3:
                begin
                    case(port)
                        0: begin valid = c3_v0; packet = c3_out0; end
                        1: begin valid = c3_v1; packet = c3_out1; end
                        2: begin valid = c3_v2; packet = c3_out2; end
                        3: begin valid = c3_v3; packet = c3_out3; end
                    endcase
                end

            endcase

        end

    endtask


    // =========================================================
    // WAIT FOR ONE PACKET
    // =========================================================

    task wait_for_packet;

        input integer cluster;
        input integer port;

        input [`PACKET_WIDTH-1:0] expected;

        output reg passed;

        reg valid;
        reg [`PACKET_WIDTH-1:0] received;

        integer count;

        begin

            passed = 0;

            for(count = 0; count < 300; count = count + 1)
            begin

                @(posedge clk);

                get_output(
                    cluster,
                    port,
                    valid,
                    received
                );

                if(valid)
                begin

                    if(received == expected)
                        passed = 1;

                    count = 300;
                end

            end

        end

    endtask


    // =========================================================
    // MONITOR FOUR PACKETS SIMULTANEOUSLY
    // =========================================================

    task monitor_four;

        input integer c0;
        input integer r0;
        input [`PACKET_WIDTH-1:0] e0;

        input integer c1;
        input integer r1;
        input [`PACKET_WIDTH-1:0] e1;

        input integer c2;
        input integer r2;
        input [`PACKET_WIDTH-1:0] e2;

        input integer c3;
        input integer r3;
        input [`PACKET_WIDTH-1:0] e3;

        output reg p0;
        output reg p1;
        output reg p2;
        output reg p3;

        reg v0;
        reg v1;
        reg v2;
        reg v3;

        reg [`PACKET_WIDTH-1:0] q0;
        reg [`PACKET_WIDTH-1:0] q1;
        reg [`PACKET_WIDTH-1:0] q2;
        reg [`PACKET_WIDTH-1:0] q3;

        integer count;

        begin

            p0 = 0;
            p1 = 0;
            p2 = 0;
            p3 = 0;

            for(count = 0; count < 300; count = count + 1)
            begin

                @(posedge clk);

                // Read ALL four destinations every cycle.

                get_output(c0,r0,v0,q0);
                get_output(c1,r1,v1,q1);
                get_output(c2,r2,v2,q2);
                get_output(c3,r3,v3,q3);

                if(v0 && (q0 == e0))
                    p0 = 1;

                if(v1 && (q1 == e1))
                    p1 = 1;

                if(v2 && (q2 == e2))
                    p2 = 1;

                if(v3 && (q3 == e3))
                    p3 = 1;

                if(p0 && p1 && p2 && p3)
                    count = 300;

            end

        end

    endtask


    // =========================================================
    // TEST 1
    // EXHAUSTIVE 256 ROUTES
    // =========================================================

    task exhaustive_test;

        integer sc;
        integer sp;
        integer dc;
        integer dp;

        reg [`PACKET_WIDTH-1:0] packet;
        reg passed;
        reg [31:0] payload;

        begin

            $display("");
            $display("======================================================");
            $display("TEST GROUP 1 : EXHAUSTIVE 256 ROUTING PATHS");
            $display("======================================================");

            for(sc = 0; sc < 4; sc = sc + 1)
            begin

                for(sp = 0; sp < 4; sp = sp + 1)
                begin

                    for(dc = 0; dc < 4; dc = dc + 1)
                    begin

                        for(dp = 0; dp < 4; dp = dp + 1)
                        begin

                            reset_dut;

                            payload =
                                32'h10000000 |
                                (sc << 20) |
                                (sp << 16) |
                                (dc << 12) |
                                (dp << 8);

                            packet =
                                make_packet(
                                    sc,
                                    sp,
                                    dc,
                                    dp,
                                    payload
                                );

                            inject_one(
                                sc,
                                sp,
                                packet
                            );

                            wait_for_packet(
                                dc,
                                dp,
                                packet,
                                passed
                            );

                            total_tests = total_tests + 1;
                            basic_tests = basic_tests + 1;

                            if(passed)
                            begin
                                total_passed = total_passed + 1;
                                basic_passed = basic_passed + 1;
                            end
                            else
                            begin
                                total_failed = total_failed + 1;
                                basic_failed = basic_failed + 1;

                                $display(
                                    "FAIL: C%0d/R%0d -> C%0d/R%0d",
                                    sc,sp,dc,dp
                                );
                            end

                        end

                    end

                end

                $display(
                    "Completed source cluster C%0d",
                    sc
                );

            end

            $display(
                "Exhaustive result: %0d / %0d passed",
                basic_passed,
                basic_tests
            );

        end

    endtask


    // =========================================================
    // TEST 2
    // FOUR SIMULTANEOUS PACKETS
    // =========================================================

    task simultaneous_test;

        reg [`PACKET_WIDTH-1:0] p0;
        reg [`PACKET_WIDTH-1:0] p1;
        reg [`PACKET_WIDTH-1:0] p2;
        reg [`PACKET_WIDTH-1:0] p3;

        reg pass0;
        reg pass1;
        reg pass2;
        reg pass3;

        begin

            $display("");
            $display("======================================================");
            $display("TEST GROUP 2 : FOUR SIMULTANEOUS PACKETS");
            $display("======================================================");

            reset_dut;

            p0 = make_packet(0,0,1,0,32'hA0000001);
            p1 = make_packet(1,0,2,0,32'hA0000002);
            p2 = make_packet(2,0,3,0,32'hA0000003);
            p3 = make_packet(3,0,0,0,32'hA0000004);

            // Monitor starts BEFORE injection.
            fork

                monitor_four(
                    1,0,p0,
                    2,0,p1,
                    3,0,p2,
                    0,0,p3,
                    pass0,
                    pass1,
                    pass2,
                    pass3
                );

                begin

                    @(negedge clk);

                    c0_in0 = p0;
                    c0_w0  = 1;

                    c1_in0 = p1;
                    c1_w0  = 1;

                    c2_in0 = p2;
                    c2_w0  = 1;

                    c3_in0 = p3;
                    c3_w0  = 1;

                    @(negedge clk);

                    clear_inputs;

                end

            join

            total_tests = total_tests + 4;
            stress_tests = stress_tests + 4;

            if(pass0)
            begin
                total_passed = total_passed + 1;
                stress_passed = stress_passed + 1;
            end
            else
            begin
                total_failed = total_failed + 1;
                stress_failed = stress_failed + 1;
                $display("FAIL: C0 -> C1");
            end

            if(pass1)
            begin
                total_passed = total_passed + 1;
                stress_passed = stress_passed + 1;
            end
            else
            begin
                total_failed = total_failed + 1;
                stress_failed = stress_failed + 1;
                $display("FAIL: C1 -> C2");
            end

            if(pass2)
            begin
                total_passed = total_passed + 1;
                stress_passed = stress_passed + 1;
            end
            else
            begin
                total_failed = total_failed + 1;
                stress_failed = stress_failed + 1;
                $display("FAIL: C2 -> C3");
            end

            if(pass3)
            begin
                total_passed = total_passed + 1;
                stress_passed = stress_passed + 1;
            end
            else
            begin
                total_failed = total_failed + 1;
                stress_failed = stress_failed + 1;
                $display("FAIL: C3 -> C0");
            end

            if(pass0 && pass1 && pass2 && pass3)
                $display("PASS: FOUR SIMULTANEOUS PACKETS");
            else
                $display("FAIL: FOUR SIMULTANEOUS PACKETS");

        end

    endtask


    // =========================================================
    // TEST 3
    // CONTENTION
    //
    // Three packets from different clusters converge
    // on C0/R0.
    // =========================================================

    task contention_test;

    reg [`PACKET_WIDTH-1:0] p0;
    reg [`PACKET_WIDTH-1:0] p1;
    reg [`PACKET_WIDTH-1:0] p2;

    reg pass0;
    reg pass1;
    reg pass2;

    integer count;
    reg valid;
    reg [`PACKET_WIDTH-1:0] packet;
        begin

            $display("");
            $display("======================================================");
            $display("TEST GROUP 3 : INTER-CLUSTER CONTENTION");
            $display("======================================================");

            reset_dut;

            p0 = make_packet(1,0,0,0,32'hB0000001);
            p1 = make_packet(2,0,0,0,32'hB0000002);
            p2 = make_packet(3,0,0,0,32'hB0000003);

            // Inject three packets simultaneously.
            //
            // They all target C0/R0.
            //
            // The monitor checks C0/R0 every clock.

            fork

                begin

                    
                    pass0 = 0;
                    pass1 = 0;
                    pass2 = 0;

                    for(count = 0; count < 400; count = count + 1)
                    begin

                        @(posedge clk);

                        get_output(0,0,valid,packet);

                        if(valid)
                        begin

                            if(packet == p0)
                                pass0 = 1;

                            if(packet == p1)
                                pass1 = 1;

                            if(packet == p2)
                                pass2 = 1;
                        end

                        if(pass0 && pass1 && pass2)
                            count = 400;

                    end

                end

                begin

                    @(negedge clk);

                    c1_in0 = p0;
                    c1_w0  = 1;

                    c2_in0 = p1;
                    c2_w0  = 1;

                    c3_in0 = p2;
                    c3_w0  = 1;

                    @(negedge clk);

                    clear_inputs;

                end

            join

            total_tests = total_tests + 3;
            stress_tests = stress_tests + 3;

            if(pass0)
            begin
                total_passed = total_passed + 1;
                stress_passed = stress_passed + 1;
            end
            else
            begin
                total_failed = total_failed + 1;
                stress_failed = stress_failed + 1;
                $display("FAIL: contention packet B1");
            end

            if(pass1)
            begin
                total_passed = total_passed + 1;
                stress_passed = stress_passed + 1;
            end
            else
            begin
                total_failed = total_failed + 1;
                stress_failed = stress_failed + 1;
                $display("FAIL: contention packet B2");
            end

            if(pass2)
            begin
                total_passed = total_passed + 1;
                stress_passed = stress_passed + 1;
            end
            else
            begin
                total_failed = total_failed + 1;
                stress_failed = stress_failed + 1;
                $display("FAIL: contention packet B3");
            end

            if(pass0 && pass1 && pass2)
                $display("PASS: CONTENTION");
            else
                $display("FAIL: CONTENTION");

        end

    endtask


 // =========================================================
// TEST 4
// BACK-TO-BACK GLOBAL NETWORK DEBUG
// =========================================================

task back_to_back_test;

    reg [`PACKET_WIDTH-1:0] p0;
    reg [`PACKET_WIDTH-1:0] p1;
    reg [`PACKET_WIDTH-1:0] p2;

    reg pass0;
    reg pass1;
    reg pass2;

    integer count;

    begin

        $display("");
        $display("======================================================");
        $display("TEST GROUP 4 : BACK-TO-BACK GLOBAL DEBUG");
        $display("======================================================");

        reset_dut;

        p0 = make_packet(0,0,1,0,32'hC0000001);
        p1 = make_packet(0,1,1,1,32'hC0000002);
        p2 = make_packet(0,2,1,2,32'hC0000003);

        pass0 = 0;
        pass1 = 0;
        pass2 = 0;

        fork

            // =================================================
            // MONITOR
            // =================================================

            begin

                for(count = 0; count < 400; count = count + 1)
                begin

                    @(posedge clk);
                    #1;
                    // NOTE:
                    // Do not probe ROUTING_UNIT.valid_in here.
                    // routing_unit has no valid_in port.
                    // Destination outputs below are the valid
                    // observable interface for this test.
                    // =============================================
                    // C0 GLOBAL INPUT
                    // =============================================

                    if(DUT.GLOBAL_NETWORK.c0_valid_in)
                    begin
                        $display(
                            "DEBUG @ %0t : GLOBAL C0 IN  = %h",
                            $time,
                            DUT.GLOBAL_NETWORK.c0_packet_in
                        );
                    end


                    // =============================================
                    // C1 GLOBAL OUTPUT
                    // =============================================

                    if(DUT.GLOBAL_NETWORK.c1_valid_out)
                    begin
                        $display(
                            "DEBUG @ %0t : GLOBAL C1 OUT = %h",
                            $time,
                            DUT.GLOBAL_NETWORK.c1_packet_out
                        );
                    end


                    // =============================================
                    // C1 GATEWAY INPUT
                    // =============================================

                    if(DUT.c1_gateway_valid_in)
                    begin
                        $display(
                            "DEBUG @ %0t : C1 GATEWAY IN = %h",
                            $time,
                            DUT.c1_gateway_in
                        );
                    end


                    // =============================================
                    // C1/R0
                    // =============================================

                    if(c1_v0)
                    begin
                        $display(
                            "DEBUG @ %0t : C1/R0 OUT = %h",
                            $time,
                            c1_out0
                        );

                        if(c1_out0 == p0)
                            pass0 = 1;
                    end


                    // =============================================
                    // C1/R1
                    // =============================================

                    if(c1_v1)
                    begin
                        $display(
                            "DEBUG @ %0t : C1/R1 OUT = %h",
                            $time,
                            c1_out1
                        );

                        if(c1_out1 == p1)
                            pass1 = 1;

                        if(c1_out1 == p2)
                        begin
                            $display(
                                "ERROR @ %0t : P2 ARRIVED AT C1/R1 INSTEAD OF C1/R2",
                                $time
                            );
                        end
                    end


                    // =============================================
                    // C1/R2
                    // =============================================

                    if(c1_v2)
                    begin
                        $display(
                            "DEBUG @ %0t : C1/R2 OUT = %h",
                            $time,
                            c1_out2
                        );

                        if(c1_out2 == p2)
                        begin
                            pass2 = 1;

                            $display(
                                "DEBUG @ %0t : P2 RECEIVED CORRECTLY AT C1/R2",
                                $time
                            );
                        end
                    end


                    if(pass0 && pass1 && pass2)
                        count = 400;

                end

            end


            // =================================================
            // INJECTION
            // =================================================

            begin

                @(negedge clk);

                c0_in0 = p0;
                c0_w0  = 1;

                $display(
                    "DEBUG @ %0t : INJECT P0 = %h",
                    $time,
                    p0
                );


                @(negedge clk);

                c0_w0 = 0;

                c0_in1 = p1;
                c0_w1  = 1;

                $display(
                    "DEBUG @ %0t : INJECT P1 = %h",
                    $time,
                    p1
                );


                @(negedge clk);

                c0_w1 = 0;

                c0_in2 = p2;
                c0_w2  = 1;

                $display(
                    "DEBUG @ %0t : INJECT P2 = %h",
                    $time,
                    p2
                );


                @(negedge clk);

                clear_inputs;

            end

        join


        // =================================================
        // RESULTS
        // =================================================

        total_tests  = total_tests + 3;
        stress_tests = stress_tests + 3;


        if(pass0)
        begin
            total_passed  = total_passed + 1;
            stress_passed = stress_passed + 1;
            $display("PASS: back-to-back packet C1");
        end
        else
        begin
            total_failed  = total_failed + 1;
            stress_failed = stress_failed + 1;
            $display("FAIL: back-to-back packet C1");
        end


        if(pass1)
        begin
            total_passed  = total_passed + 1;
            stress_passed = stress_passed + 1;
            $display("PASS: back-to-back packet C2");
        end
        else
        begin
            total_failed  = total_failed + 1;
            stress_failed = stress_failed + 1;
            $display("FAIL: back-to-back packet C2");
        end


        if(pass2)
        begin
            total_passed  = total_passed + 1;
            stress_passed = stress_passed + 1;
            $display("PASS: back-to-back packet C3");
        end
        else
        begin
            total_failed  = total_failed + 1;
            stress_failed = stress_failed + 1;
            $display("FAIL: back-to-back packet C3");
        end


        $display("");
        $display(
            "B2B RESULT : P0=%b P1=%b P2=%b",
            pass0,
            pass1,
            pass2
        );

        if(pass0 && pass1 && pass2)
            $display("PASS: BACK-TO-BACK");
        else
            $display("FAIL: BACK-TO-BACK");

    end

endtask
    // =========================================================
    // TEST 5
    // FOUR PACKET BURST
    // =========================================================

    task burst_test;

        reg [`PACKET_WIDTH-1:0] p0;
        reg [`PACKET_WIDTH-1:0] p1;
        reg [`PACKET_WIDTH-1:0] p2;
        reg [`PACKET_WIDTH-1:0] p3;

        reg pass0;
        reg pass1;
        reg pass2;
        reg pass3;

        begin

            $display("");
            $display("======================================================");
            $display("TEST GROUP 5 : MULTI-CLUSTER BURST");
            $display("======================================================");

            reset_dut;

            p0 = make_packet(0,3,3,0,32'hD0000001);
            p1 = make_packet(1,2,0,3,32'hD0000002);
            p2 = make_packet(2,1,1,2,32'hD0000003);
            p3 = make_packet(3,0,2,1,32'hD0000004);

            fork

                monitor_four(
                    3,0,p0,
                    0,3,p1,
                    1,2,p2,
                    2,1,p3,
                    pass0,
                    pass1,
                    pass2,
                    pass3
                );

                begin

                    @(negedge clk);

                    c0_in3 = p0;
                    c0_w3  = 1;

                    c1_in2 = p1;
                    c1_w2  = 1;

                    c2_in1 = p2;
                    c2_w1  = 1;

                    c3_in0 = p3;
                    c3_w0  = 1;

                    @(negedge clk);

                    clear_inputs;

                end

            join

            total_tests = total_tests + 4;
            stress_tests = stress_tests + 4;

            if(pass0)
            begin
                total_passed = total_passed + 1;
                stress_passed = stress_passed + 1;
            end
            else
            begin
                total_failed = total_failed + 1;
                stress_failed = stress_failed + 1;
                $display("FAIL: burst packet D1");
            end

            if(pass1)
            begin
                total_passed = total_passed + 1;
                stress_passed = stress_passed + 1;
            end
            else
            begin
                total_failed = total_failed + 1;
                stress_failed = stress_failed + 1;
                $display("FAIL: burst packet D2");
            end

            if(pass2)
            begin
                total_passed = total_passed + 1;
                stress_passed = stress_passed + 1;
            end
            else
            begin
                total_failed = total_failed + 1;
                stress_failed = stress_failed + 1;
                $display("FAIL: burst packet D3");
            end

            if(pass3)
            begin
                total_passed = total_passed + 1;
                stress_passed = stress_passed + 1;
            end
            else
            begin
                total_failed = total_failed + 1;
                stress_failed = stress_failed + 1;
                $display("FAIL: burst packet D4");
            end

            if(pass0 && pass1 && pass2 && pass3)
                $display("PASS: BURST");
            else
                $display("FAIL: BURST");

        end

    endtask


    // =========================================================
    // TEST 6
    // RESET / RECOVERY
    // =========================================================

    task reset_recovery_test;

        reg [`PACKET_WIDTH-1:0] packet;
        reg passed;

        begin

            $display("");
            $display("======================================================");
            $display("TEST GROUP 6 : RESET / RECOVERY");
            $display("======================================================");

            reset_dut;

            // ---------------- PRE RESET ----------------

            packet =
                make_packet(
                    3,
                    2,
                    0,
                    1,
                    32'hE0000001
                );

            inject_one(
                3,
                2,
                packet
            );

            wait_for_packet(
                0,
                1,
                packet,
                passed
            );

            total_tests = total_tests + 1;
            stress_tests = stress_tests + 1;

            if(passed)
            begin
                total_passed = total_passed + 1;
                stress_passed = stress_passed + 1;

                $display("PASS: PRE-RESET PACKET");
            end
            else
            begin
                total_failed = total_failed + 1;
                stress_failed = stress_failed + 1;

                $display("FAIL: PRE-RESET PACKET");
            end


            // ---------------- HARD RESET ----------------

            rst = 1;

            clear_inputs;

            repeat(5)
                @(posedge clk);

            rst = 0;

            repeat(3)
                @(posedge clk);


            // ---------------- POST RESET ----------------

            packet =
                make_packet(
                    2,
                    1,
                    1,
                    2,
                    32'hE0000002
                );

            inject_one(
                2,
                1,
                packet
            );

            wait_for_packet(
                1,
                2,
                packet,
                passed
            );

            total_tests = total_tests + 1;
            stress_tests = stress_tests + 1;

            if(passed)
            begin
                total_passed = total_passed + 1;
                stress_passed = stress_passed + 1;

                $display("PASS: POST-RESET PACKET");
            end
            else
            begin
                total_failed = total_failed + 1;
                stress_failed = stress_failed + 1;

                $display("FAIL: POST-RESET PACKET");
            end

        end

    endtask


    // =========================================================
    // MAIN
    // =========================================================

    initial
    begin

        clk = 0;
        rst = 1;

        total_tests = 0;
        total_passed = 0;
        total_failed = 0;

        basic_tests = 0;
        basic_passed = 0;
        basic_failed = 0;

        stress_tests = 0;
        stress_passed = 0;
        stress_failed = 0;

        clear_inputs;


        $display("");
        $display("======================================================");
        $display("       HYBRID NoC COMPREHENSIVE VERIFICATION");
        $display("======================================================");
        $display("");
        $display("1. Exhaustive 256 routing paths");
        $display("2. Simultaneous traffic");
        $display("3. Inter-cluster contention");
        $display("4. Back-to-back packets");
        $display("5. Multi-cluster burst");
        $display("6. Reset / recovery");
        $display("7. Packet integrity");
        $display("");


        // =====================================================
        // RUN ALL TESTS
        // =====================================================

       // TEST 1
exhaustive_test;

// TEST 2
simultaneous_test;

// TEST 3
contention_test;

// TEST 4
back_to_back_test;

// TEST 5
burst_test;

// TEST 6
reset_recovery_test;
        // =====================================================
        // FINAL SUMMARY
        // =====================================================

        $display("");
        $display("");
        $display("======================================================");
        $display("          COMPREHENSIVE HYBRID NoC SUMMARY");
        $display("======================================================");

        $display("");
        $display("BASIC ROUTING");
        $display("------------------------------");

        $display(
            "Tests Run    : %0d",
            basic_tests
        );

        $display(
            "Tests Passed : %0d",
            basic_passed
        );

        $display(
            "Tests Failed : %0d",
            basic_failed
        );


        $display("");
        $display("STRESS TESTS");
        $display("------------------------------");

        $display(
            "Tests Run    : %0d",
            stress_tests
        );

        $display(
            "Tests Passed : %0d",
            stress_passed
        );

        $display(
            "Tests Failed : %0d",
            stress_failed
        );


        $display("");
        $display("OVERALL");
        $display("------------------------------");

        $display(
            "Total Tests  : %0d",
            total_tests
        );

        $display(
            "Total Passed : %0d",
            total_passed
        );

        $display(
            "Total Failed : %0d",
            total_failed
        );


        $display("");

        if(total_failed == 0)
        begin
            $display(
                "RESULT : ALL COMPREHENSIVE TESTS PASSED"
            );
        end
        else
        begin
            $display(
                "RESULT : COMPREHENSIVE VERIFICATION FAILED"
            );
        end

        $display("");
        $display("======================================================");

        #100;

        $finish;

    end

endmodule