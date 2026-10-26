# Hybrid NoC Architecture Images

These original SVG diagrams are editable vector illustrations for the architecture/rethinking documentation. They can be embedded in Markdown, presentations, or reports.

## Diagrams

1. [Local 2×2 Mesh Cluster](./01_local_2x2_mesh.svg) — four routers and their local/directional connectivity.
2. [Gateway Concept](./02_gateway_concept.svg) — how a gateway bridges a local Mesh and global network.
3. [Four-Cluster Spidergon-Inspired Network](./03_global_spidergon.svg) — four gateways with ring links and opposite-cluster links.
4. [Hybrid Mesh–Spidergon Overview](./04_hybrid_overview.svg) — local Mesh clusters connected through the global layer.
5. [Packet Journey](./05_packet_journey.svg) — conceptual comparison of intra-cluster and inter-cluster communication.

**Architecture note:** These diagrams illustrate the project concept and current 4-cluster, 2×2-Mesh baseline. They are explanatory drawings, not timing-accurate or pin-level RTL schematics. Confirm port numbering, exact link directions, and gateway implementation against the RTL before using them as implementation evidence.
