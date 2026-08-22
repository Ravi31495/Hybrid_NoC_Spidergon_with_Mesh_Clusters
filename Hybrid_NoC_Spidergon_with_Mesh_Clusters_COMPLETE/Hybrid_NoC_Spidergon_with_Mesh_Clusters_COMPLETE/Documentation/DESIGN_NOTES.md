# Design Notes & Handover

## What is considered stable

The current source ZIP is preserved under `Source/Archive/`. The individual Verilog files are exposed under `Source/RTL/` and `Source/Testbench/` for easy review.

## Why the archive is preserved

It provides an immutable reference to the source snapshot from the completed development stage. Individual files can be cleaned up later without losing the original baseline.

## Recommended development workflow

Create a feature branch for every major change. Run the smoke test first, then the relevant unit testbench, then the comprehensive system regression.

Do not mix measured synthesis results with simulation-only claims.

## Areas suitable for future development

- higher-volume traffic generation
- latency/throughput monitors
- stronger congestion metrics
- randomized verification
- assertions
- formal verification
- synthesis/timing/resource analysis
- FPGA hardware validation
- comparison with conventional Mesh
