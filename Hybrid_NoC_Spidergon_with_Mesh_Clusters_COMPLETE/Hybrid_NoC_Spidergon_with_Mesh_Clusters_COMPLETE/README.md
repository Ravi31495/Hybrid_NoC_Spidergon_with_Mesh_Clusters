# Hybrid NoC — Spidergon-Inspired Global Network with 4×4 Mesh Clusters

A hierarchical Network-on-Chip (NoC) implemented in Verilog HDL, combining four local 4×4 Mesh clusters with a Spidergon-inspired global inter-cluster network.

## Project status

**Functional RTL + comprehensive simulation/verification baseline completed.**

This repository is intended to be understandable by a new team member without relying on the original development conversation.

## Architecture

| Parameter | Design |
|---|---|
| Clusters | 4 |
| Local topology | 4×4 Mesh |
| Routers / cluster | 16 |
| Total routers | 64 |
| Gateway | R0 of each cluster |
| Global topology | Spidergon-inspired |
| Ring links | C0↔C1↔C2↔C3↔C0 |
| Opposite links | C0↔C2 and C1↔C3 |
| Packet width | 48 bits |
| RTL | Verilog HDL |
| Simulation | Xilinx Vivado / XSim |

> R0 is the gateway router itself; no additional gateway router is added.

## System view

```text
                  ┌──────────── GLOBAL NETWORK ────────────┐
                  │                                         │
             C0 ═══════════════ C1                           │
              ╲                 ╱                            │
               ╲               ╱                             │
                ╲             ╱                              │
                 C3 ═════════ C2                             │
                  │                                         │
                  └─────────────────────────────────────────┘

       Each Cx = independent 4×4 Mesh cluster
       R0 = gateway of that cluster
```

Global ring:
`C0 ↔ C1 ↔ C2 ↔ C3 ↔ C0`

Opposite links:
`C0 ↔ C2`
`C1 ↔ C3`

## Local mesh

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

R0 = gateway
```

## Inter-cluster packet flow

```text
Source endpoint
      ↓
Source 4×4 Mesh
      ↓
Gateway R0
      ↓
Spidergon-inspired global network
      ↓
Destination Gateway R0
      ↓
Destination 4×4 Mesh
      ↓
Destination endpoint
```

## Router datapath

```text
Input → FIFO / Buffer → Routing → Request Classification
                         ↓
                    Arbitration
                         ↓
                      Crossbar
                         ↓
                  Output Buffer → Output
```

The RTL package includes buffering, routing, arbitration, crossbar control, packet handling, gateway logic and global routing.

## Packet format

```text
┌─────────┬─────┬─────┬──────┬──────────┬────────────────┐
│ Cluster │ Row │ Col │ Type │ Priority │ Payload        │
│ 2 bits  │2 bit│2 bit│2 bit │ 2 bits   │ 32 bits        │
└─────────┴─────┴─────┴──────┴──────────┴────────────────┘
                         Total = 48 bits
```

## Source organization

- `Source/RTL/` — synthesizable design modules
- `Source/Testbench/` — module and system verification benches
- `Source/Archive/` — original supplied source ZIP, preserved unchanged
- `Architecture/` — diagrams and formal architecture notes
- `Verification/` — verification matrix and interpretation
- `Documentation/` — design decisions and continuation notes

## Important RTL modules

- `router.v`
- `mesh_4x4_v2.v`
- `hybrid_noc.v`
- `hybrid_noc_v2.v`
- `global_network_4cluster.v`
- `spidergon_routing.v`
- `routing_unit.v`
- `xy_routing.v`
- `adaptive_routing.v`
- `fifo.v`
- `crossbar_switch.v`
- `round_robin_arbiter.v`
- `gateway_interface.v`
- `gateway_selector.v`
- `gateway_direction.v`
- `packet_generator.v`
- `packet_receiver.v`

## Verification

The supplied verification package contains unit-level benches for routing, FIFO/buffering, arbitration, crossbar, gateway and global-network logic, plus full Hybrid NoC integration benches.

The major system benches include:

- `hybrid_noc_v2_comprehensive_tb.v`
- `hybrid_noc_v2_smoke_tb.v`
- `hybrid_noc_comprehensive_tb_final.v`
- `hybrid_noc_tb.v`

The repository documentation distinguishes directed functional checks from true exhaustive system-wide coverage so that verification claims remain precise.

## How a teammate should continue

1. Read this README.
2. Read `Architecture/Specifications/architecture.md`.
3. Open `Source/RTL/noc_defines.vh` to understand packet/port definitions.
4. Read `Source/RTL/router.v`.
5. Follow `routing_unit.v` → `spidergon_routing.v` → `global_network_4cluster.v`.
6. Read `Verification/VERIFICATION.md`.
7. Run the smoke test before modifying RTL.
8. Use the comprehensive testbench as the regression baseline.
9. Keep new experiments in a separate branch.

## Scope boundaries

The completed baseline is the functional RTL and simulation/verification environment. FPGA timing, LUT/FF/BRAM utilization, maximum frequency, power and hardware measurements should only be added when actual Vivado/hardware results are available.

## Author

**Ravi** — Electronics & Communication Engineering

Interests: RTL design, VLSI, FPGA systems, computer architecture and Network-on-Chip design.
