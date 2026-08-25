`timescale 1ns/1ps
`include "noc_defines.vh"

// V2 performance monitor. Simulation/evaluation infrastructure outside the
// frozen DUT. Payload[31:0] is the unique experiment transaction ID.
module noc_v2_metrics_monitor #(
    parameter MAX_INFLIGHT = 1024
)
(
    input clk,
    input rst,
    input [63:0] inject_event,
    input [63:0] receive_event,
    input [64*`PACKET_WIDTH-1:0] inject_packet_bus,
    input [64*`PACKET_WIDTH-1:0] receive_packet_bus,
    output reg [31:0] packets_injected,
    output reg [31:0] packets_received,
    output reg [31:0] unmatched_receives,
    output reg [63:0] total_latency,
    output reg [63:0] min_latency,
    output reg [63:0] max_latency,
    output reg [63:0] total_hops,
    output reg [31:0] min_hops,
    output reg [31:0] max_hops,
    output reg [63:0] experiment_cycles
);

    reg slot_valid [0:MAX_INFLIGHT-1];
    reg [31:0] slot_id [0:MAX_INFLIGHT-1];
    reg [63:0] slot_time [0:MAX_INFLIGHT-1];
    reg [3:0] slot_hops [0:MAX_INFLIGHT-1];

    integer i, j, free_slot, match_slot;
    reg [63:0] cycle_count, latency_now;
    reg [3:0] hops_now;
    reg found_free, found_match;

    function [3:0] calc_hops;
        input [1:0] sc, sr, scol, dc, dr, dcol;
        integer a,b,c,d;
        begin
            if (sc == dc) begin
                a = sr - dr; if (a < 0) a = -a;
                b = scol - dcol; if (b < 0) b = -b;
                calc_hops = a + b;
            end else begin
                c = sr; d = scol; a = dr; b = dcol;
                calc_hops = c + d + 1 + a + b;
            end
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            packets_injected <= 0;
            packets_received <= 0;
            unmatched_receives <= 0;
            total_latency <= 0;
            min_latency <= 64'hFFFF_FFFF_FFFF_FFFF;
            max_latency <= 0;
            total_hops <= 0;
            min_hops <= 32'hFFFF_FFFF;
            max_hops <= 0;
            experiment_cycles <= 0;
            cycle_count <= 0;
            for (i=0;i<MAX_INFLIGHT;i=i+1) begin
                slot_valid[i] <= 0;
                slot_id[i] <= 0;
                slot_time[i] <= 0;
                slot_hops[i] <= 0;
            end
        end else begin
            cycle_count <= cycle_count + 1'b1;
            experiment_cycles <= cycle_count;

            for (i=0;i<64;i=i+1) begin
                if (inject_event[i]) begin
                    found_free = 0; free_slot = -1;
                    for (j=0;j<MAX_INFLIGHT;j=j+1)
                        if (!found_free && !slot_valid[j]) begin found_free=1; free_slot=j; end
                    if (found_free) begin
                        slot_valid[free_slot] <= 1;
                        slot_id[free_slot] <= inject_packet_bus[i*`PACKET_WIDTH + 31 -: 32];
                        slot_time[free_slot] <= cycle_count;
                        slot_hops[free_slot] <= calc_hops(
                            inject_packet_bus[i*`PACKET_WIDTH + 41 -: 2],
                            inject_packet_bus[i*`PACKET_WIDTH + 39 -: 2],
                            inject_packet_bus[i*`PACKET_WIDTH + 37 -: 2],
                            inject_packet_bus[i*`PACKET_WIDTH + 47 -: 2],
                            inject_packet_bus[i*`PACKET_WIDTH + 45 -: 2],
                            inject_packet_bus[i*`PACKET_WIDTH + 43 -: 2]);
                        packets_injected <= packets_injected + 1'b1;
                    end
                end
            end

            for (i=0;i<64;i=i+1) begin
                if (receive_event[i]) begin
                    found_match=0; match_slot=-1;
                    for (j=0;j<MAX_INFLIGHT;j=j+1)
                        if (!found_match && slot_valid[j] &&
                            slot_id[j] == receive_packet_bus[i*`PACKET_WIDTH + 31 -: 32]) begin
                            found_match=1; match_slot=j;
                        end
                    if (found_match) begin
                        latency_now = cycle_count - slot_time[match_slot];
                        hops_now = slot_hops[match_slot];
                        packets_received <= packets_received + 1'b1;
                        total_latency <= total_latency + latency_now;
                        total_hops <= total_hops + hops_now;
                        if (latency_now < min_latency) min_latency <= latency_now;
                        if (latency_now > max_latency) max_latency <= latency_now;
                        if (hops_now < min_hops) min_hops <= hops_now;
                        if (hops_now > max_hops) max_hops <= hops_now;
                        slot_valid[match_slot] <= 0;
                    end else unmatched_receives <= unmatched_receives + 1'b1;
                end
            end
        end
    end
endmodule
