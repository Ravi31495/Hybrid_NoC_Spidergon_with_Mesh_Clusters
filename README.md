# Hybrid NoC — Spidergon-Inspired Global Network with 4×4 Mesh Clusters

A hierarchical **Network-on-Chip (NoC)** architecture implemented in **Verilog HDL**, combining four local **4×4 Mesh clusters** with a **Spidergon-inspired global inter-cluster network**.

The project explores how hierarchical topology can keep local communication structured while providing direct global connectivity between clusters. The RTL includes the router datapath/control, routing, buffering, arbitration, crossbar switching, gateway logic, packet handling, and a multi-scenario verification environment.

> **Project status:** Completed functional RTL architecture and comprehensive simulation/verification environment. Synthesis, FPGA implementation, and measured PPA results are intentionally kept separate until final hardware artifacts are added.

---

## Architecture at a Glance

| Item | Implementation |
|---|---|
| Global architecture | 4-cluster Spidergon-inspired interconnect |
| Local architecture | 4×4 Mesh per cluster |
| Clusters | 4 |
| Routers per cluster | 16 |
| Total routers | 64 |
| Gateway | Router R0 of each cluster |
| Packet width | 48 bits |
| Cluster address | 2 bits |
| Router row/column fields | 2 bits each |
| Router ports | LOCAL, NORTH, SOUTH, EAST, WEST, GATEWAY |
| RTL language | Verilog HDL |
| Main verification | Directed routing + simultaneous traffic + contention + burst/back-to-back + reset recovery |

---

## Why a Hybrid NoC?

A single large Mesh is simple, but communication between distant nodes can require many hops. A purely global topology can reduce inter-cluster distance but increases global wiring and control complexity.

This design separates the problem into two levels:

```text
                    HYBRID NoC
                         │
          ┌──────────────┴──────────────┐
          │                             │
     LOCAL NETWORK                 GLOBAL NETWORK
          │                             │
   4 × 4 Mesh / Cluster       Spidergon-inspired layer
          │                             │
     ┌────┴────┐              ┌─────────┴─────────┐
     │ 16      │              │ C0 ↔ C1 ↔ C2 ↔ C3│
     │ routers │              │ + opposite links  │
     └────┬────┘              └─────────┬─────────┘
          │                             │
          └──────── Gateway ────────────┘
```

Local traffic can remain within its mesh. Inter-cluster traffic reaches the gateway router, crosses the global layer, and then enters the destination cluster for local delivery.

---

## Global Topology

The four clusters are connected using a Spidergon-inspired topology with ring links and opposite-cluster links:

```text
                         C0
                    ╱    │    ╲
                   ╱     │     ╲
                 C3──────┼──────C1
                   ╲     │     ╱
                    ╲    │    ╱
                         C2

Ring:
C0 ↔ C1 ↔ C2 ↔ C3 ↔ C0

Opposite links:
C0 ↔ C2
C1 ↔ C3
```

The global routing RTL explicitly maps source and destination cluster IDs to the corresponding inter-cluster direction.

See [`spidergon_routing.v`](Source/RTL/spidergon_routing.v) and [`global_network_4cluster.v`](Source/RTL/global_network_4cluster.v).

---

## Local 4×4 Mesh

Each cluster contains **16 routers arranged as a 4×4 mesh**. Router R0 acts as the cluster gateway; it is not an additional router.

```text
┌────┬────┬────┬────┐
│ R0 │ R1 │ R2 │ R3 │
├────┼────┼────┼────┤
│ R4 │ R5 │ R6 │ R7 │
├────┼────┼────┼────┤
│ R8 │ R9 │R10 │R11 │
├────┼────┼────┼────┤
│R12 │R13 │R14 │R15 │
└────┴────┴────┴────┘

R0 = Gateway router
```

The router interface distinguishes the local endpoint from directional mesh links and the gateway path.

---

## Router Microarchitecture

The router is decomposed into reusable RTL blocks:

```text
                 ┌───────────────────────┐
                 │       Router          │
                 ├───────────────────────┤
 Input ports ───►│ Input Buffers / FIFO   │
                 │          │            │
                 │          ▼            │
                 │    Routing Unit       │
                 │          │            │
                 │          ▼            │
                 │ Request Classification│
                 │          │            │
                 │          ▼            │
                 │ Arbitration / Grants  │
                 │          │            │
                 │          ▼            │
                 │      Crossbar         │
                 │          │            │
                 │          ▼            │
                 │    Output Buffers     │
                 └──────────┬────────────┘
                            ▼
                       Output ports
```

Key RTL components include:

- FIFO-based input buffering
- Routing-unit logic
- XY routing
- Adaptive/congestion-aware routing support
- Request classification and generation
- Round-robin arbitration
- Priority logic
- Crossbar switching
- Output buffering
- Router control/state logic
- Gateway selection and interface logic

---

## Packet Format

The design uses a **48-bit packet** with address, type, priority, and payload fields.

```text
┌──────────┬──────────┬──────────┬──────┬──────────┬────────────────────────┐
│ Cluster  │   Row    │   Col    │ Type │ Priority │        Payload          │
│  2 bits  │  2 bits  │  2 bits  │2 bit │  2 bits  │       32 bits           │
└──────────┴──────────┴──────────┴──────┴──────────┴────────────────────────┘
                                      Total = 48 bits
```

The packet format is defined centrally in [`noc_defines.vh`](Source/RTL/noc_defines.vh).

---

## Routing Flow

For an inter-cluster packet, the intended hierarchy is:

```text
Source Endpoint
      │
      ▼
Source 4×4 Mesh
      │
      ▼
Gateway Router (R0)
      │
      ▼
Global Spidergon-inspired Network
      │
      ▼
Destination Gateway (R0)
      │
      ▼
Destination 4×4 Mesh
      │
      ▼
Destination Endpoint
```

This separates **local XY/adaptive routing** from **global cluster-level routing**.

---

## Verification

The repository includes unit-level testbenches for major RTL blocks and an integration-level comprehensive Hybrid NoC testbench.

The final comprehensive testbench contains:

- **256 directed routing checks** generated from the cluster/source/destination coordinate loops
- Four simultaneous inter-cluster packet checks
- Inter-cluster contention checks
- Back-to-back traffic checks
- Multi-cluster burst checks
- Reset/recovery checks

The testbench therefore defines **272 verification checks in total** across basic routing and stress/recovery scenarios.

The 256-route group is a directed functional baseline; it should **not** be interpreted as an exhaustive 64×64 router-pair sweep of the complete 64-router system. Additional traffic and full-mesh coverage can be added as future verification expansion.

### Verification layers

```text
Unit RTL Tests
      │
      ├── FIFO / buffers
      ├── Router control
      ├── Routing units
      ├── Arbitration
      ├── Crossbar
      ├── Gateway blocks
      └── Global network
              │
              ▼
      Integration Tests
              │
              ├── Directed routing
              ├── Simultaneous traffic
              ├── Contention
              ├── Bursts / back-to-back traffic
              └── Reset recovery
```

---

## Repository Structure

```text
Hybrid_NoC_Spidergon_with_Mesh_Clusters/
│
├── README.md
├── Architecture/
│   ├── Diagrams/
│   └── Specifications/
│
├── Source/
│   ├── RTL/
│   ├── Testbench/
│   └── source_manifest.md
│
├── Verification/
│   └── VERIFICATION.md
│
└── Documentation/
    └── DESIGN_NOTES.md
```

The complete project source is maintained as part of the repository source package, while the most important RTL modules are exposed individually for easier review.

---

## Tools & Technologies

- **Verilog HDL** — RTL design
- **Xilinx Vivado / XSim** — simulation and FPGA-oriented workflow
- **Git / GitHub** — version control and project documentation
- Digital design concepts: FSM/control logic, FIFOs, arbitration, routing, buffering, packet switching, and hierarchical NoC topology

---

## Engineering Highlights

### Hierarchical topology
Designed a two-level communication structure rather than treating the complete 64-router system as one flat network.

### Gateway-based global communication
R0 in each cluster acts as the gateway, avoiding the need for a separate gateway router.

### Modular RTL
The design is decomposed into independently testable blocks, making the architecture easier to debug and extend.

### Traffic handling
The verification environment goes beyond a single happy-path packet and includes simultaneous traffic, contention, bursts, back-to-back transfers, and reset recovery scenarios.

### Verification-first development
Major blocks have dedicated testbenches, while the complete system has integration-level verification.

---

## Current Scope & Future Extensions

The functional RTL and simulation environment form the completed project baseline. Natural next extensions include:

- Full 64×64 source/destination coverage
- Higher-volume random traffic generation
- Quantitative latency and throughput measurement
- Deadlock/livelock analysis under congestion
- Formal assertions and functional coverage
- Vivado synthesis and timing analysis
- LUT/FF/BRAM/resource utilization reporting
- Maximum-frequency and power analysis
- FPGA hardware validation
- Comparison against a conventional flat Mesh NoC

These items are deliberately separated from the current implementation so that future measured results are not confused with simulation-only claims.

---

## Project Files

- [`Source/RTL`](Source/RTL) — main synthesizable RTL modules
- [`Source/Testbench`](Source/Testbench) — verification testbenches
- [`Architecture/Diagrams`](Architecture/Diagrams) — architecture and data-flow diagrams
- [`Verification/VERIFICATION.md`](Verification/VERIFICATION.md) — verification scope and test matrix
- [`Documentation/DESIGN_NOTES.md`](Documentation/DESIGN_NOTES.md) — implementation notes

---

## Author

**Ravi** — Electronics & Communication Engineering

Interested in RTL design, VLSI, FPGA systems, computer architecture, and on-chip interconnects.

---

*Academic engineering project — developed as a modular Verilog RTL implementation and verification study of hierarchical Network-on-Chip architectures.*
