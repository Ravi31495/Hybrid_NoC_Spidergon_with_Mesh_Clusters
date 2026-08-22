# Source Code

This directory is the code-facing part of the project.

## Recommended starting points

| File | Why it matters |
|---|---|
| `RTL/noc_defines.vh` | Global packet, port and network definitions |
| `RTL/router.v` | Main six-port router integration |
| `RTL/spidergon_routing.v` | Global cluster-to-cluster direction selection |
| `RTL/mesh_4x4_v2.v` | 4×4 local Mesh construction |
| `RTL/hybrid_noc.v` | Top-level Hybrid NoC integration |
| `RTL/global_network_4cluster.v` | Global inter-cluster network |
| `Testbench/hybrid_noc_comprehensive_tb_final.v` | Main comprehensive system-level verification |

## Suggested reading order

```text
noc_defines.vh
      ↓
router.v
      ↓
mesh_4x4_v2.v
      ↓
spidergon_routing.v
      ↓
global_network_4cluster.v
      ↓
hybrid_noc.v
      ↓
hybrid_noc_comprehensive_tb_final.v
```

The supplied final source snapshot contains the complete RTL and testbench set documented in `source_manifest.md`. Legacy and experimental variants are retained for traceability and are not presented as separate final architectures.
