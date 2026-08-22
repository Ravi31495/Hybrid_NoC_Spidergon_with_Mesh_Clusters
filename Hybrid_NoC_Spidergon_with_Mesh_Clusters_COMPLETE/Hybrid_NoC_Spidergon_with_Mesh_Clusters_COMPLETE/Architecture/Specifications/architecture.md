# Architecture Specification

## 1. System

The final architecture consists of four clusters. Each cluster is a 4×4 Mesh containing 16 routers, giving 64 routers overall.

R0 in each cluster is the gateway. It is an existing router in the Mesh, not an extra router.

## 2. Global topology

Clusters are connected by a Spidergon-inspired global layer:

- C0 ↔ C1
- C1 ↔ C2
- C2 ↔ C3
- C3 ↔ C0
- C0 ↔ C2
- C1 ↔ C3

This provides both ring and opposite-cluster paths.

## 3. Routing hierarchy

Local traffic is handled inside a cluster using Mesh routing. Inter-cluster traffic first reaches the source gateway, traverses the global network, reaches the destination gateway, and then uses destination-cluster routing.

## 4. Router responsibilities

The router integrates input buffering, routing decision, request generation/classification, arbitration, crossbar selection and output buffering.

## 5. Development principle

Keep the architecture modular. Changes to global routing should not require rewriting FIFO or arbitration logic. New traffic generators and performance monitors should be added around the stable RTL baseline rather than mixed into core routing logic.
