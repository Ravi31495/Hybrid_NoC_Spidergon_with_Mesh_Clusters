# Design Notes

## Architectural decisions

### 1. Hierarchical network
The system is split into four local clusters and one global communication layer. This keeps local routing independent from cluster-to-cluster routing.

### 2. 4×4 local Mesh
Each cluster contains 16 routers arranged as four rows by four columns. The cluster gateway is the existing R0 router, so the gateway does not consume an additional router position.

### 3. Gateway-based global traffic
Inter-cluster packets are routed to the gateway, transferred through the global network, and then injected into the destination cluster's local mesh.

### 4. Modular router
The router is decomposed into buffering, routing, request generation/classification, arbitration, crossbar, output handling, and control blocks. This makes individual functions easier to verify and replace.

### 5. 48-bit packet
The packet carries cluster, row, column, type, priority, and payload information. The address fields allow the same packet format to be interpreted at both local and global levels.

## Port convention

The RTL uses the following physical router port encoding:

| Port | Meaning |
|---:|---|
| 0 | LOCAL |
| 1 | NORTH |
| 2 | SOUTH |
| 3 | EAST |
| 4 | WEST |
| 5 | GATEWAY |

Global clockwise/counter-clockwise values are kept separate from physical router-port encodings.

## Project maturity

The repository focuses on the implemented RTL and functional verification baseline. Experimental files and older variants are retained only when they are useful for traceability; the main README points reviewers toward the current architecture.
