# Simulation Guide

This guide is the starting point for anyone who wants to simulate and continue the Hybrid NoC project.

## 1. Final architecture

- 4 clusters
- Each cluster: 4×4 Mesh = 16 routers
- Total: 64 routers
- R0 in each cluster is the gateway router
- Global network: Spidergon-inspired ring + opposite-cluster links
- RTL: Verilog HDL
- Intended simulator flow: Xilinx Vivado / XSim

## 2. Repository layout

```text
Source/
├── RTL/         synthesizable RTL and integration modules
├── Testbench/   simulation testbenches
└── Archive/     original complete source snapshot

Architecture/    topology and design specifications
Verification/    verification methodology and coverage notes
Documentation/   design/handover notes
```

## 3. Recommended first simulation: smoke test

Use this first after cloning the repository:

```text
Source/Testbench/hybrid_noc_v2_smoke_tb.v
```

Its purpose is a quick sanity check before running the larger regression.

### Vivado/XSim

1. Create/open a Vivado RTL project.
2. Add all required RTL files from `Source/RTL/`.
3. Add `Source/Testbench/hybrid_noc_v2_smoke_tb.v` as a simulation source.
4. Set `hybrid_noc_v2_smoke_tb` as the simulation top.
5. Run **Simulation → Run Behavioral Simulation**.
6. Inspect the Tcl/console output and waveform for packet delivery and reset behavior.

Do not add every historical testbench as a top simultaneously. Select one top-level testbench for each run.

## 4. Main functional regression

After the smoke test passes, use:

```text
Source/RTL/hybrid_noc_v2_comprehensive_tb.v
```

Set `hybrid_noc_v2_comprehensive_tb` as the simulation top.

This is the broad functional/system regression and exercises the 64-router V2 architecture, including routing combinations and stress scenarios.

## 5. RTL dependency principle

The testbench files are intentionally separated from the RTL. The safest Vivado setup is to add the complete `Source/RTL/` directory as design/simulation sources and then select only the desired testbench as the simulation top.

Important core modules include:

```text
noc_defines.vh
router.v
mesh_4x4_v2.v
hybrid_noc_v2.v
global_network_4cluster.v
spidergon_routing.v
routing_unit.v
xy_routing.v
adaptive_routing.v
fifo.v
input_buffer.v
output_buffer.v
input_port.v
output_port.v
crossbar_switch.v
arbiter_bank.v
round_robin_arbiter.v
request_generator.v
request_classifier.v
gateway_interface.v
gateway_decoder.v
gateway_direction.v
gateway_selector.v
packet_generator.v
packet_receiver.v
```

## 6. Metrics/performance simulation

The V2 metrics layer contains:

```text
noc_v2_ip_endpoint.v
noc_v2_hybrid_hop_calculator.v
noc_v2_metrics_monitor.v
```

The metrics architecture is documented in:

```text
Architecture/Specifications/V2_METRICS_ARCHITECTURE.md
```

The corrected metrics sanity experiment from the original source archive should be treated as the reference metrics testbench when importing the archive into a local working copy:

```text
hybrid_noc_v2_metrics_sanity_tb_full_fixed.v
```

It is preserved in `Source/Archive/` so the original project snapshot is not lost. If this testbench is needed as an individually browsable GitHub source file, copy that exact file from the archive without rewriting it.

## 7. Unit-level verification

`Source/Testbench/` contains module-level benches for routing, FIFO/buffering, arbitration, crossbar, gateway, packet handling and integration. Use these when debugging a particular module instead of running the full NoC regression.

Typical workflow:

```text
module change
   ↓
corresponding unit TB
   ↓
smoke test
   ↓
comprehensive V2 TB
   ↓
metrics/performance experiment
```

## 8. Avoid common mistakes

- Do not use the old 2×2 Mesh as the final DUT.
- Do not select an obsolete `_DIAGNOSTIC`, `_modified`, or historical testbench as the main regression unless intentionally debugging that version.
- Do not run multiple top-level testbenches simultaneously.
- Keep `noc_defines.vh` available to all modules that include it.
- Check the simulator console for compile/elaboration errors before interpreting waveform results.
- Record simulator version, testbench top, commit SHA and traffic configuration for reproducible results.

## 9. What counts as a completed simulation result

For a meaningful regression record, save:

- testbench name
- DUT/top name
- simulator/tool version
- packet count
- source/destination traffic pattern
- pass/fail count
- packet integrity result
- reset/recovery result
- latency/hop metrics when applicable
- waveform or log reference

Do not claim FPGA timing, resource utilization, power, throughput limits or maximum frequency unless those measurements have actually been produced by synthesis/implementation or hardware testing.

## 10. Handover path

A new developer should read these in order:

1. `README.md`
2. `Architecture/Specifications/architecture.md`
3. `Architecture/Specifications/V2_METRICS_ARCHITECTURE.md`
4. `Source/RTL/noc_defines.vh`
5. `Source/RTL/router.v`
6. `Source/RTL/mesh_4x4_v2.v`
7. `Source/RTL/global_network_4cluster.v`
8. `Source/RTL/spidergon_routing.v`
9. `Source/Testbench/hybrid_noc_v2_smoke_tb.v`
10. `Source/Testbench/hybrid_noc_v2_comprehensive_tb.v`
11. `Verification/VERIFICATION.md`

Then run the smoke test before making architectural changes.