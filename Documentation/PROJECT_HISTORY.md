# Project History

This repository is the consolidated showcase repository for the Hybrid NoC work that previously appeared across multiple project repositories.

## Evolution

### Earlier functional milestone
The earlier `SoC` repository documented a **4-cluster, 2×2 Mesh** version with gateway-based global communication and an initial functional verification flow.

### Current architecture
The design was subsequently expanded to:

- **4×4 Mesh per cluster**
- **4 clusters**
- **16 routers per cluster**
- **64 routers total**
- R0 of every cluster serving as the gateway
- Spidergon-inspired global inter-cluster routing
- Expanded router, gateway, buffering, arbitration and verification RTL

### Consolidation decision
Multiple repositories were created during development. This repository is now intended to be the **single public showcase** for the project so that a reviewer does not have to navigate several partial or milestone repositories.

The older repositories remain useful as development history, but the final public-facing narrative belongs here.

## What this repository emphasizes

1. Architecture clarity
2. Readable RTL structure
3. Verification methodology
4. Engineering decisions and trade-offs
5. Traceable evolution from the smaller Mesh milestone to the 4×4 clustered design

The repository intentionally avoids presenting unmeasured synthesis, timing, power, or FPGA results as completed results. Those can be added later when the corresponding reports are available.
