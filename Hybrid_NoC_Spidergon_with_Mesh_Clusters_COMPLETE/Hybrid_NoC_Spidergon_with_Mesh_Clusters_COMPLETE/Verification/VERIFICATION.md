# Verification Guide

## Verification layers

### Unit level
Individual modules have dedicated testbenches for FIFO, buffers, routing, arbitration, crossbar, gateway, packet handling and related logic.

### Integration level
The full Hybrid NoC testbenches exercise local and inter-cluster packet movement.

## Main regression candidates

1. `hybrid_noc_v2_smoke_tb.v` — quick sanity check.
2. `hybrid_noc_v2_comprehensive_tb.v` — broad system verification.
3. `hybrid_noc_comprehensive_tb_final.v` — comprehensive legacy/final verification bench.
4. `hybrid_noc_tb.v` — integration-level testbench.

## Interpreting results

Earlier project notes reported large directed test counts. These should be treated as the coverage of the corresponding testbench, not automatically as proof of every possible source/destination pair of the complete 64-router system.

Before claiming new coverage, record:
- number of packets generated
- source/destination combinations
- traffic pattern
- pass/fail count
- packet-integrity checks
- reset behavior
- simulator and commit used

## Recommended next verification

- randomized traffic
- simultaneous packets
- sustained contention
- FIFO full/empty boundaries
- packet ordering/integrity
- deadlock/livelock checks
- latency measurement
- throughput measurement
- functional coverage
