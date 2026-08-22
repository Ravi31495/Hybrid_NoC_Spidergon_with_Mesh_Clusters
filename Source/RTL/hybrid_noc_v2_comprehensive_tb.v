`timescale 1ns/1ps
`include "noc_defines.vh"

module hybrid_noc_v2_comprehensive_tb;

    // =========================================================
    // 4 CLUSTERS x 4x4 ROUTERS = 64 ROUTERS
    // =========================================================

    reg clk;
    reg rst;

    reg [`PACKET_WIDTH-1:0] in_pkt [0:63];
    reg                    in_wr  [0:63];

    wire [`PACKET_WIDTH-1:0] out_pkt [0:63];
    wire                    out_valid [0:63];

    integer total_tests;
    integer total_passed;
    integer total_failed;
    integer basic_tests;
    integer basic_passed;
    integer basic_failed;
    integer stress_tests;
    integer stress_passed;
    integer stress_failed;

    always #5 clk = ~clk;

    // =========================================================
    // DUT
    // =========================================================

    hybrid_noc_v2 DUT
    (
        .clk(clk),
        .rst(rst),
        .c0_local_packet_in0(in_pkt[0]),
        .c0_local_packet_in1(in_pkt[1]),
        .c0_local_packet_in2(in_pkt[2]),
        .c0_local_packet_in3(in_pkt[3]),
        .c0_local_packet_in4(in_pkt[4]),
        .c0_local_packet_in5(in_pkt[5]),
        .c0_local_packet_in6(in_pkt[6]),
        .c0_local_packet_in7(in_pkt[7]),
        .c0_local_packet_in8(in_pkt[8]),
        .c0_local_packet_in9(in_pkt[9]),
        .c0_local_packet_in10(in_pkt[10]),
        .c0_local_packet_in11(in_pkt[11]),
        .c0_local_packet_in12(in_pkt[12]),
        .c0_local_packet_in13(in_pkt[13]),
        .c0_local_packet_in14(in_pkt[14]),
        .c0_local_packet_in15(in_pkt[15]),
        .c1_local_packet_in0(in_pkt[16]),
        .c1_local_packet_in1(in_pkt[17]),
        .c1_local_packet_in2(in_pkt[18]),
        .c1_local_packet_in3(in_pkt[19]),
        .c1_local_packet_in4(in_pkt[20]),
        .c1_local_packet_in5(in_pkt[21]),
        .c1_local_packet_in6(in_pkt[22]),
        .c1_local_packet_in7(in_pkt[23]),
        .c1_local_packet_in8(in_pkt[24]),
        .c1_local_packet_in9(in_pkt[25]),
        .c1_local_packet_in10(in_pkt[26]),
        .c1_local_packet_in11(in_pkt[27]),
        .c1_local_packet_in12(in_pkt[28]),
        .c1_local_packet_in13(in_pkt[29]),
        .c1_local_packet_in14(in_pkt[30]),
        .c1_local_packet_in15(in_pkt[31]),
        .c2_local_packet_in0(in_pkt[32]),
        .c2_local_packet_in1(in_pkt[33]),
        .c2_local_packet_in2(in_pkt[34]),
        .c2_local_packet_in3(in_pkt[35]),
        .c2_local_packet_in4(in_pkt[36]),
        .c2_local_packet_in5(in_pkt[37]),
        .c2_local_packet_in6(in_pkt[38]),
        .c2_local_packet_in7(in_pkt[39]),
        .c2_local_packet_in8(in_pkt[40]),
        .c2_local_packet_in9(in_pkt[41]),
        .c2_local_packet_in10(in_pkt[42]),
        .c2_local_packet_in11(in_pkt[43]),
        .c2_local_packet_in12(in_pkt[44]),
        .c2_local_packet_in13(in_pkt[45]),
        .c2_local_packet_in14(in_pkt[46]),
        .c2_local_packet_in15(in_pkt[47]),
        .c3_local_packet_in0(in_pkt[48]),
        .c3_local_packet_in1(in_pkt[49]),
        .c3_local_packet_in2(in_pkt[50]),
        .c3_local_packet_in3(in_pkt[51]),
        .c3_local_packet_in4(in_pkt[52]),
        .c3_local_packet_in5(in_pkt[53]),
        .c3_local_packet_in6(in_pkt[54]),
        .c3_local_packet_in7(in_pkt[55]),
        .c3_local_packet_in8(in_pkt[56]),
        .c3_local_packet_in9(in_pkt[57]),
        .c3_local_packet_in10(in_pkt[58]),
        .c3_local_packet_in11(in_pkt[59]),
        .c3_local_packet_in12(in_pkt[60]),
        .c3_local_packet_in13(in_pkt[61]),
        .c3_local_packet_in14(in_pkt[62]),
        .c3_local_packet_in15(in_pkt[63]),
        .c0_local_write0(in_wr[0]),
        .c0_local_write1(in_wr[1]),
        .c0_local_write2(in_wr[2]),
        .c0_local_write3(in_wr[3]),
        .c0_local_write4(in_wr[4]),
        .c0_local_write5(in_wr[5]),
        .c0_local_write6(in_wr[6]),
        .c0_local_write7(in_wr[7]),
        .c0_local_write8(in_wr[8]),
        .c0_local_write9(in_wr[9]),
        .c0_local_write10(in_wr[10]),
        .c0_local_write11(in_wr[11]),
        .c0_local_write12(in_wr[12]),
        .c0_local_write13(in_wr[13]),
        .c0_local_write14(in_wr[14]),
        .c0_local_write15(in_wr[15]),
        .c1_local_write0(in_wr[16]),
        .c1_local_write1(in_wr[17]),
        .c1_local_write2(in_wr[18]),
        .c1_local_write3(in_wr[19]),
        .c1_local_write4(in_wr[20]),
        .c1_local_write5(in_wr[21]),
        .c1_local_write6(in_wr[22]),
        .c1_local_write7(in_wr[23]),
        .c1_local_write8(in_wr[24]),
        .c1_local_write9(in_wr[25]),
        .c1_local_write10(in_wr[26]),
        .c1_local_write11(in_wr[27]),
        .c1_local_write12(in_wr[28]),
        .c1_local_write13(in_wr[29]),
        .c1_local_write14(in_wr[30]),
        .c1_local_write15(in_wr[31]),
        .c2_local_write0(in_wr[32]),
        .c2_local_write1(in_wr[33]),
        .c2_local_write2(in_wr[34]),
        .c2_local_write3(in_wr[35]),
        .c2_local_write4(in_wr[36]),
        .c2_local_write5(in_wr[37]),
        .c2_local_write6(in_wr[38]),
        .c2_local_write7(in_wr[39]),
        .c2_local_write8(in_wr[40]),
        .c2_local_write9(in_wr[41]),
        .c2_local_write10(in_wr[42]),
        .c2_local_write11(in_wr[43]),
        .c2_local_write12(in_wr[44]),
        .c2_local_write13(in_wr[45]),
        .c2_local_write14(in_wr[46]),
        .c2_local_write15(in_wr[47]),
        .c3_local_write0(in_wr[48]),
        .c3_local_write1(in_wr[49]),
        .c3_local_write2(in_wr[50]),
        .c3_local_write3(in_wr[51]),
        .c3_local_write4(in_wr[52]),
        .c3_local_write5(in_wr[53]),
        .c3_local_write6(in_wr[54]),
        .c3_local_write7(in_wr[55]),
        .c3_local_write8(in_wr[56]),
        .c3_local_write9(in_wr[57]),
        .c3_local_write10(in_wr[58]),
        .c3_local_write11(in_wr[59]),
        .c3_local_write12(in_wr[60]),
        .c3_local_write13(in_wr[61]),
        .c3_local_write14(in_wr[62]),
        .c3_local_write15(in_wr[63]),
        .c0_local_packet_out0(out_pkt[0]),
        .c0_local_packet_out1(out_pkt[1]),
        .c0_local_packet_out2(out_pkt[2]),
        .c0_local_packet_out3(out_pkt[3]),
        .c0_local_packet_out4(out_pkt[4]),
        .c0_local_packet_out5(out_pkt[5]),
        .c0_local_packet_out6(out_pkt[6]),
        .c0_local_packet_out7(out_pkt[7]),
        .c0_local_packet_out8(out_pkt[8]),
        .c0_local_packet_out9(out_pkt[9]),
        .c0_local_packet_out10(out_pkt[10]),
        .c0_local_packet_out11(out_pkt[11]),
        .c0_local_packet_out12(out_pkt[12]),
        .c0_local_packet_out13(out_pkt[13]),
        .c0_local_packet_out14(out_pkt[14]),
        .c0_local_packet_out15(out_pkt[15]),
        .c1_local_packet_out0(out_pkt[16]),
        .c1_local_packet_out1(out_pkt[17]),
        .c1_local_packet_out2(out_pkt[18]),
        .c1_local_packet_out3(out_pkt[19]),
        .c1_local_packet_out4(out_pkt[20]),
        .c1_local_packet_out5(out_pkt[21]),
        .c1_local_packet_out6(out_pkt[22]),
        .c1_local_packet_out7(out_pkt[23]),
        .c1_local_packet_out8(out_pkt[24]),
        .c1_local_packet_out9(out_pkt[25]),
        .c1_local_packet_out10(out_pkt[26]),
        .c1_local_packet_out11(out_pkt[27]),
        .c1_local_packet_out12(out_pkt[28]),
        .c1_local_packet_out13(out_pkt[29]),
        .c1_local_packet_out14(out_pkt[30]),
        .c1_local_packet_out15(out_pkt[31]),
        .c2_local_packet_out0(out_pkt[32]),
        .c2_local_packet_out1(out_pkt[33]),
        .c2_local_packet_out2(out_pkt[34]),
        .c2_local_packet_out3(out_pkt[35]),
        .c2_local_packet_out4(out_pkt[36]),
        .c2_local_packet_out5(out_pkt[37]),
        .c2_local_packet_out6(out_pkt[38]),
        .c2_local_packet_out7(out_pkt[39]),
        .c2_local_packet_out8(out_pkt[40]),
        .c2_local_packet_out9(out_pkt[41]),
        .c2_local_packet_out10(out_pkt[42]),
        .c2_local_packet_out11(out_pkt[43]),
        .c2_local_packet_out12(out_pkt[44]),
        .c2_local_packet_out13(out_pkt[45]),
        .c2_local_packet_out14(out_pkt[46]),
        .c2_local_packet_out15(out_pkt[47]),
        .c3_local_packet_out0(out_pkt[48]),
        .c3_local_packet_out1(out_pkt[49]),
        .c3_local_packet_out2(out_pkt[50]),
        .c3_local_packet_out3(out_pkt[51]),
        .c3_local_packet_out4(out_pkt[52]),
        .c3_local_packet_out5(out_pkt[53]),
        .c3_local_packet_out6(out_pkt[54]),
        .c3_local_packet_out7(out_pkt[55]),
        .c3_local_packet_out8(out_pkt[56]),
        .c3_local_packet_out9(out_pkt[57]),
        .c3_local_packet_out10(out_pkt[58]),
        .c3_local_packet_out11(out_pkt[59]),
        .c3_local_packet_out12(out_pkt[60]),
        .c3_local_packet_out13(out_pkt[61]),
        .c3_local_packet_out14(out_pkt[62]),
        .c3_local_packet_out15(out_pkt[63]),
        .c0_local_valid0(out_valid[0]),
        .c0_local_valid1(out_valid[1]),
        .c0_local_valid2(out_valid[2]),
        .c0_local_valid3(out_valid[3]),
        .c0_local_valid4(out_valid[4]),
        .c0_local_valid5(out_valid[5]),
        .c0_local_valid6(out_valid[6]),
        .c0_local_valid7(out_valid[7]),
        .c0_local_valid8(out_valid[8]),
        .c0_local_valid9(out_valid[9]),
        .c0_local_valid10(out_valid[10]),
        .c0_local_valid11(out_valid[11]),
        .c0_local_valid12(out_valid[12]),
        .c0_local_valid13(out_valid[13]),
        .c0_local_valid14(out_valid[14]),
        .c0_local_valid15(out_valid[15]),
        .c1_local_valid0(out_valid[16]),
        .c1_local_valid1(out_valid[17]),
        .c1_local_valid2(out_valid[18]),
        .c1_local_valid3(out_valid[19]),
        .c1_local_valid4(out_valid[20]),
        .c1_local_valid5(out_valid[21]),
        .c1_local_valid6(out_valid[22]),
        .c1_local_valid7(out_valid[23]),
        .c1_local_valid8(out_valid[24]),
        .c1_local_valid9(out_valid[25]),
        .c1_local_valid10(out_valid[26]),
        .c1_local_valid11(out_valid[27]),
        .c1_local_valid12(out_valid[28]),
        .c1_local_valid13(out_valid[29]),
        .c1_local_valid14(out_valid[30]),
        .c1_local_valid15(out_valid[31]),
        .c2_local_valid0(out_valid[32]),
        .c2_local_valid1(out_valid[33]),
        .c2_local_valid2(out_valid[34]),
        .c2_local_valid3(out_valid[35]),
        .c2_local_valid4(out_valid[36]),
        .c2_local_valid5(out_valid[37]),
        .c2_local_valid6(out_valid[38]),
        .c2_local_valid7(out_valid[39]),
        .c2_local_valid8(out_valid[40]),
        .c2_local_valid9(out_valid[41]),
        .c2_local_valid10(out_valid[42]),
        .c2_local_valid11(out_valid[43]),
        .c2_local_valid12(out_valid[44]),
        .c2_local_valid13(out_valid[45]),
        .c2_local_valid14(out_valid[46]),
        .c2_local_valid15(out_valid[47]),
        .c3_local_valid0(out_valid[48]),
        .c3_local_valid1(out_valid[49]),
        .c3_local_valid2(out_valid[50]),
        .c3_local_valid3(out_valid[51]),
        .c3_local_valid4(out_valid[52]),
        .c3_local_valid5(out_valid[53]),
        .c3_local_valid6(out_valid[54]),
        .c3_local_valid7(out_valid[55]),
        .c3_local_valid8(out_valid[56]),
        .c3_local_valid9(out_valid[57]),
        .c3_local_valid10(out_valid[58]),
        .c3_local_valid11(out_valid[59]),
        .c3_local_valid12(out_valid[60]),
        .c3_local_valid13(out_valid[61]),
        .c3_local_valid14(out_valid[62]),
        .c3_local_valid15(out_valid[63])
    );

    task clear_inputs;
        integer k;
        begin
            for(k=0;k<64;k=k+1)
            begin
                in_pkt[k] = {`PACKET_WIDTH{1'b0}};
                in_wr[k]  = 1'b0;
            end
        end
    endtask

    // =========================================================
    // RESET
    // =========================================================

    task reset_dut;
        begin
            clear_inputs;
            rst = 1'b1;
            repeat(3) @(posedge clk);
            rst = 1'b0;
            repeat(2) @(posedge clk);
        end
    endtask

    // =========================================================
    // PACKET CREATION
    // Linear router index:
    //   cluster*16 + row*4 + col
    // =========================================================

    function [`PACKET_WIDTH-1:0] make_packet;
        input integer sc;
        input integer sp;
        input integer dc;
        input integer dp;
        input [31:0] payload;
        integer sr, scol, dr, dcol;
        begin
            sr   = sp / 4;
            scol = sp % 4;
            dr   = dp / 4;
            dcol = dp % 4;

            make_packet = {
                dc[1:0], dr[1:0], dcol[1:0],
                sc[1:0], sr[1:0], scol[1:0],
                2'd0, 2'd0, payload
            };
        end
    endfunction

    // =========================================================
    // INJECT ONE PACKET
    // =========================================================

    task inject_one;
        input integer source;
        input [`PACKET_WIDTH-1:0] packet;
        begin
            in_pkt[source] = packet;
            in_wr[source]  = 1'b1;
            @(negedge clk);
            in_wr[source]  = 1'b0;
            in_pkt[source] = {`PACKET_WIDTH{1'b0}};
        end
    endtask

    // =========================================================
    // WAIT FOR EXPECTED PACKET
    // =========================================================

    task wait_for_packet;
        input integer destination;
        input [`PACKET_WIDTH-1:0] expected;
        output reg passed;
        integer k;
        begin
            passed = 1'b0;
            for(k=0;k<150;k=k+1)
            begin
                @(posedge clk);
                #1;
                if(out_valid[destination])
                begin
                    if(out_pkt[destination] == expected)
                        passed = 1'b1;
                    else
                        $display("ERROR: destination %0d received %h, expected %h",
                                 destination,out_pkt[destination],expected);
                    k = 300;
                end
            end
        end
    endtask

    // =========================================================
    // MONITOR MULTIPLE PACKETS
    // =========================================================

    task wait_four;
        input integer d0; input [`PACKET_WIDTH-1:0] e0;
        input integer d1; input [`PACKET_WIDTH-1:0] e1;
        input integer d2; input [`PACKET_WIDTH-1:0] e2;
        input integer d3; input [`PACKET_WIDTH-1:0] e3;
        output reg p0; output reg p1; output reg p2; output reg p3;
        integer k;
        begin
            p0=0; p1=0; p2=0; p3=0;
            for(k=0;k<250;k=k+1)
            begin
                @(posedge clk); #1;
                if(out_valid[d0] && out_pkt[d0]==e0) p0=1;
                if(out_valid[d1] && out_pkt[d1]==e1) p1=1;
                if(out_valid[d2] && out_pkt[d2]==e2) p2=1;
                if(out_valid[d3] && out_pkt[d3]==e3) p3=1;
                if(p0&&p1&&p2&&p3) k=500;
            end
        end
    endtask

    // =========================================================
    // TEST 1: EXHAUSTIVE 4096 ROUTES
    // 64 sources x 64 destinations
    // =========================================================

    task exhaustive_test;
        integer sc, sp, dc, dp;
        integer source, destination;
        reg [`PACKET_WIDTH-1:0] packet;
        reg passed;
        reg [31:0] payload;
        begin
            $display("");
            $display("======================================================");
            $display("TEST GROUP 1 : EXHAUSTIVE 4096 ROUTING PATHS");
            $display("======================================================");

            for(sc=0;sc<4;sc=sc+1)
            begin
                for(sp=0;sp<16;sp=sp+1)
                begin
                    for(dc=0;dc<4;dc=dc+1)
                    begin
                        for(dp=0;dp<16;dp=dp+1)
                        begin
                            reset_dut;
                            source = sc*16 + sp;
                            destination = dc*16 + dp;
                            payload = 32'h10000000 |
                                      (sc<<26) | (sp<<20) |
                                      (dc<<14) | (dp<<8) |
                                      (sp^dp);
                            packet = make_packet(sc,sp,dc,dp,payload);
                            inject_one(source,packet);
                            wait_for_packet(destination,packet,passed);

                            total_tests=total_tests+1;
                            basic_tests=basic_tests+1;
                            if(passed)
                            begin
                                total_passed=total_passed+1;
                                basic_passed=basic_passed+1;
                            end
                            else
                            begin
                                total_failed=total_failed+1;
                                basic_failed=basic_failed+1;
                                $display("FAIL: C%0d/R%0d -> C%0d/R%0d",
                                         sc,sp,dc,dp);
                            end
                        end
                    end
                end
                $display("Completed source cluster C%0d",sc);
            end

            $display("Exhaustive result: %0d / %0d passed",
                     basic_passed,basic_tests);
        end
    endtask

    // =========================================================
    // TEST 2: FOUR SIMULTANEOUS PACKETS
    // =========================================================

    task simultaneous_test;
        reg [`PACKET_WIDTH-1:0] p0,p1,p2,p3;
        reg a,b,c,d;
        begin
            $display("");
            $display("======================================================");
            $display("TEST GROUP 2 : FOUR SIMULTANEOUS PACKETS");
            $display("======================================================");
            reset_dut;
            p0=make_packet(0,15,1,15,32'hA0000001);
            p1=make_packet(1,15,2,0, 32'hA0000002);
            p2=make_packet(2,15,3,15,32'hA0000003);
            p3=make_packet(3,15,0,0, 32'hA0000004);
            fork
                wait_four(31,p0,32,p1,63,p2,0,p3,a,b,c,d);
                begin
                    @(negedge clk);
                    in_pkt[15]=p0; in_wr[15]=1;
                    in_pkt[31]=p1; in_wr[31]=1;
                    in_pkt[47]=p2; in_wr[47]=1;
                    in_pkt[63]=p3; in_wr[63]=1;
                    @(negedge clk); clear_inputs;
                end
            join
            total_tests=total_tests+4; stress_tests=stress_tests+4;
            if(a) begin total_passed=total_passed+1; stress_passed=stress_passed+1; end else begin total_failed=total_failed+1; stress_failed=stress_failed+1; end
            if(b) begin total_passed=total_passed+1; stress_passed=stress_passed+1; end else begin total_failed=total_failed+1; stress_failed=stress_failed+1; end
            if(c) begin total_passed=total_passed+1; stress_passed=stress_passed+1; end else begin total_failed=total_failed+1; stress_failed=stress_failed+1; end
            if(d) begin total_passed=total_passed+1; stress_passed=stress_passed+1; end else begin total_failed=total_failed+1; stress_failed=stress_failed+1; end
            if(a&&b&&c&&d) $display("PASS: FOUR SIMULTANEOUS PACKETS");
            else $display("FAIL: FOUR SIMULTANEOUS PACKETS");
        end
    endtask

    // =========================================================
    // TEST 3: INTER-CLUSTER CONTENTION
    // Three different clusters target one router in C0.
    // =========================================================

    task contention_test;
        reg [`PACKET_WIDTH-1:0] p0,p1,p2;
        reg a,b,c;
        integer k;
        begin
            $display("");
            $display("======================================================");
            $display("TEST GROUP 3 : INTER-CLUSTER CONTENTION");
            $display("======================================================");
            reset_dut;
            p0=make_packet(1,0,0,0,32'hB0000001);
            p1=make_packet(2,0,0,0,32'hB0000002);
            p2=make_packet(3,0,0,0,32'hB0000003);
            a=0;b=0;c=0;
            fork
                begin
                    for(k=0;k<250;k=k+1)
                    begin
                        @(posedge clk); #1;
                        if(out_valid[0]) begin
                            if(out_pkt[0]==p0)a=1;
                            if(out_pkt[0]==p1)b=1;
                            if(out_pkt[0]==p2)c=1;
                        end
                        if(a&&b&&c) k=500;
                    end
                end
                begin
                    @(negedge clk);
                    in_pkt[16]=p0; in_wr[16]=1;
                    in_pkt[32]=p1; in_wr[32]=1;
                    in_pkt[48]=p2; in_wr[48]=1;
                    @(negedge clk); clear_inputs;
                end
            join
            total_tests=total_tests+3; stress_tests=stress_tests+3;
            if(a)begin total_passed=total_passed+1;stress_passed=stress_passed+1;end else begin total_failed=total_failed+1;stress_failed=stress_failed+1;end
            if(b)begin total_passed=total_passed+1;stress_passed=stress_passed+1;end else begin total_failed=total_failed+1;stress_failed=stress_failed+1;end
            if(c)begin total_passed=total_passed+1;stress_passed=stress_passed+1;end else begin total_failed=total_failed+1;stress_failed=stress_failed+1;end
            if(a&&b&&c)$display("PASS: CONTENTION"); else $display("FAIL: CONTENTION");
        end
    endtask

    // =========================================================
    // TEST 4: BACK-TO-BACK
    // =========================================================

    task back_to_back_test;
        reg [`PACKET_WIDTH-1:0] p0,p1,p2;
        reg a,b,c;
        integer k;
        begin
            $display("");
            $display("======================================================");
            $display("TEST GROUP 4 : BACK-TO-BACK PACKETS");
            $display("======================================================");
            reset_dut;
            p0=make_packet(0,0,1,0,32'hC0000001);
            p1=make_packet(0,1,1,1,32'hC0000002);
            p2=make_packet(0,2,1,2,32'hC0000003);
            a=0;b=0;c=0;
            fork
                begin
                    for(k=0;k<250;k=k+1)
                    begin
                        @(posedge clk); #1;
                        if(out_valid[16]&&out_pkt[16]==p0)a=1;
                        if(out_valid[17]&&out_pkt[17]==p1)b=1;
                        if(out_valid[18]&&out_pkt[18]==p2)c=1;
                        if(a&&b&&c)k=500;
                    end
                end
                begin
                    @(negedge clk); in_pkt[0]=p0;in_wr[0]=1;
                    @(negedge clk); in_wr[0]=0;in_pkt[1]=p1;in_wr[1]=1;
                    @(negedge clk); in_wr[1]=0;in_pkt[2]=p2;in_wr[2]=1;
                    @(negedge clk); clear_inputs;
                end
            join
            total_tests=total_tests+3;stress_tests=stress_tests+3;
            if(a)begin total_passed=total_passed+1;stress_passed=stress_passed+1;end else begin total_failed=total_failed+1;stress_failed=stress_failed+1;end
            if(b)begin total_passed=total_passed+1;stress_passed=stress_passed+1;end else begin total_failed=total_failed+1;stress_failed=stress_failed+1;end
            if(c)begin total_passed=total_passed+1;stress_passed=stress_passed+1;end else begin total_failed=total_failed+1;stress_failed=stress_failed+1;end
            if(a&&b&&c)$display("PASS: BACK-TO-BACK"); else $display("FAIL: BACK-TO-BACK");
        end
    endtask

    // =========================================================
    // TEST 5: MULTI-CLUSTER BURST
    // =========================================================

    task burst_test;
        reg [`PACKET_WIDTH-1:0] p0,p1,p2,p3;
        reg a,b,c,d;
        begin
            $display("");
            $display("======================================================");
            $display("TEST GROUP 5 : MULTI-CLUSTER BURST");
            $display("======================================================");
            reset_dut;
            p0=make_packet(0,15,3,0,32'hD0000001);
            p1=make_packet(1,14,0,15,32'hD0000002);
            p2=make_packet(2,13,1,10,32'hD0000003);
            p3=make_packet(3,12,2,5,32'hD0000004);
            fork
                wait_four(48,p0,15,p1,26,p2,37,p3,a,b,c,d);
                begin
                    @(negedge clk);
                    in_pkt[15]=p0;in_wr[15]=1;
                    in_pkt[30]=p1;in_wr[30]=1;
                    in_pkt[45]=p2;in_wr[45]=1;
                    in_pkt[60]=p3;in_wr[60]=1;
                    @(negedge clk);clear_inputs;
                end
            join
            total_tests=total_tests+4;stress_tests=stress_tests+4;
            if(a)begin total_passed=total_passed+1;stress_passed=stress_passed+1;end else begin total_failed=total_failed+1;stress_failed=stress_failed+1;end
            if(b)begin total_passed=total_passed+1;stress_passed=stress_passed+1;end else begin total_failed=total_failed+1;stress_failed=stress_failed+1;end
            if(c)begin total_passed=total_passed+1;stress_passed=stress_passed+1;end else begin total_failed=total_failed+1;stress_failed=stress_failed+1;end
            if(d)begin total_passed=total_passed+1;stress_passed=stress_passed+1;end else begin total_failed=total_failed+1;stress_failed=stress_failed+1;end
            if(a&&b&&c&&d)$display("PASS: BURST"); else $display("FAIL: BURST");
        end
    endtask

    // =========================================================
    // TEST 6: RESET / RECOVERY
    // =========================================================

    task reset_recovery_test;
        reg [`PACKET_WIDTH-1:0] p0,p1;
        reg a,b;
        begin
            $display("");
            $display("======================================================");
            $display("TEST GROUP 6 : RESET / RECOVERY");
            $display("======================================================");
            reset_dut;
            p0=make_packet(3,10,0,1,32'hE0000001);
            inject_one(58,p0);
            wait_for_packet(1,p0,a);
            total_tests=total_tests+1;stress_tests=stress_tests+1;
            if(a)begin total_passed=total_passed+1;stress_passed=stress_passed+1;$display("PASS: PRE-RESET PACKET");end else begin total_failed=total_failed+1;stress_failed=stress_failed+1;$display("FAIL: PRE-RESET PACKET");end

            rst=1; clear_inputs; repeat(5) @(posedge clk); rst=0; repeat(3) @(posedge clk);

            p1=make_packet(2,9,1,14,32'hE0000002);
            inject_one(41,p1);
            wait_for_packet(30,p1,b);
            total_tests=total_tests+1;stress_tests=stress_tests+1;
            if(b)begin total_passed=total_passed+1;stress_passed=stress_passed+1;$display("PASS: POST-RESET PACKET");end else begin total_failed=total_failed+1;stress_failed=stress_failed+1;$display("FAIL: POST-RESET PACKET");end
        end
    endtask

    // =========================================================
    // MAIN
    // =========================================================

    initial
    begin
        clk=0;
        rst=1;
        total_tests=0;total_passed=0;total_failed=0;
        basic_tests=0;basic_passed=0;basic_failed=0;
        stress_tests=0;stress_passed=0;stress_failed=0;
        clear_inputs;
        repeat(3) @(posedge clk);
        rst=0;
        repeat(2) @(posedge clk);

        $display("");
        $display("======================================================");
        $display("       HYBRID NoC V2 COMPREHENSIVE VERIFICATION");
        $display("======================================================");
        $display("64 routers = 4 clusters x 4x4 Mesh");
        $display("1. Exhaustive 4096 routing paths");
        $display("2. Simultaneous traffic");
        $display("3. Inter-cluster contention");
        $display("4. Back-to-back packets");
        $display("5. Multi-cluster burst");
        $display("6. Reset / recovery");

        exhaustive_test;
        simultaneous_test;
        contention_test;
        back_to_back_test;
        burst_test;
        reset_recovery_test;

        $display("");
        $display("======================================================");
        $display("          HYBRID NoC V2 VERIFICATION SUMMARY");
        $display("======================================================");
        $display("BASIC ROUTING");
        $display("------------------------------");
        $display("Tests Run    : %0d",basic_tests);
        $display("Tests Passed : %0d",basic_passed);
        $display("Tests Failed : %0d",basic_failed);
        $display("");
        $display("STRESS TESTS");
        $display("------------------------------");
        $display("Tests Run    : %0d",stress_tests);
        $display("Tests Passed : %0d",stress_passed);
        $display("Tests Failed : %0d",stress_failed);
        $display("");
        $display("OVERALL");
        $display("------------------------------");
        $display("Total Tests  : %0d",total_tests);
        $display("Total Passed : %0d",total_passed);
        $display("Total Failed : %0d",total_failed);
        if(total_failed==0)
            $display("RESULT : ALL HYBRID NoC V2 TESTS PASSED");
        else
            $display("RESULT : HYBRID NoC V2 VERIFICATION FAILED");
        $display("======================================================");
        $finish;
    end

endmodule