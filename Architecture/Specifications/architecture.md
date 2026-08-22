# Architecture Specification

## System topology

- **Global:** 4-cluster Spidergon-inspired interconnect
- **Local:** 4×4 Mesh inside each cluster
- **Clusters:** 4
- **Routers per cluster:** 16
- **Total routers:** 64
- **Gateway:** R0 in each cluster; no additional gateway router

## Local Mesh

Each cluster is a 4×4 grid of routers. Router coordinates are represented using 2-bit row and 2-bit column fields. The local network provides NORTH, SOUTH, EAST and WEST connectivity plus LOCAL endpoint access.

## Global layer

The global topology uses the ring:

`C0 ↔ C1 ↔ C2 ↔ C3 ↔ C0`

and opposite-cluster links:

`C0 ↔ C2`

`C1 ↔ C3`

The RTL implements this as a Spidergon-inspired global routing layer rather than claiming strict conformance to a particular canonical Spidergon implementation.

## Router ports

| Encoding | Port |
|---:|---|
| 0 | LOCAL |
| 1 | NORTH |
| 2 | SOUTH |
| 3 | EAST |
| 4 | WEST |
| 5 | GATEWAY |

## Packet

The design uses a fixed **48-bit packet** containing destination cluster/row/column, source cluster/row/column, packet type, priority, and a 32-bit payload.

## Routing hierarchy

```text
Endpoint → Local Mesh → Gateway R0 → Global Layer → Gateway R0 → Destination Mesh → Endpoint
```

Local routing is handled by XY/adaptive routing support. Cluster-level routing is handled by the global Spidergon-inspired routing logic.

## Router microarchitecture

The router integrates:

- Input ports and FIFO buffering
- Routing-unit logic
- Request generation/classification
- Arbitration and priority logic
- Crossbar switching
- Output buffering
- Router control logic
- Gateway path

## Verification scope

The supplied final comprehensive testbench defines **272 checks**: 256 directed routing checks plus simultaneous-traffic, contention, back-to-back, burst, and reset/recovery checks.

The 256 directed checks exercise four cluster IDs × four source-router indices × four destination cluster IDs × four destination-router indices. They are a directed baseline and are **not** a complete 64×64 source/destination sweep.

Simulation result logs and FPGA implementation reports are not claimed until the corresponding artifacts are added to the repository.
