# Architecture notes

This file records the architecture described for the current RTL package. It is intentionally short; the diagrams carry most of the structure so that the design can be understood without reading a long block of text.

## System size

- 4 clusters
- 4×4 mesh per cluster
- 16 routers per cluster
- 64 routers in the complete system

## Packet

The supplied architecture description specifies a fixed 48-bit packet containing destination/source cluster, row and column fields, type, priority and a 32-bit payload.

## Routing

Local communication uses XY/adaptive routing. Inter-cluster traffic is directed through a gateway and the Spidergon-inspired global layer.

## Router structure

The router design includes input buffering, routing, request generation/classification, arbitration, crossbar control and output buffering. The source archive contains the individual RTL and testbench modules.

## Verification information supplied with the project

The project notes report 4096/4096 exhaustive cases, 16/16 stress cases and 4112/4112 overall for the V2 verification flow. These figures are recorded here as supplied project information; they have not been independently rerun during this repository import.

## Source preservation

The original ZIP is the source snapshot used for this first repository import. No RTL refactoring is being done at this stage. Cleanup and naming changes can be handled later after the repository structure is reviewed.
