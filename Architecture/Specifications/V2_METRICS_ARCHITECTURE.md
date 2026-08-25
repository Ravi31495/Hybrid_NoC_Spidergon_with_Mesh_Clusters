# V2 Metrics Architecture

## Frozen DUT

- 4 clusters x 4x4 = 64 routers
- 48-bit packet
- Metrics infrastructure is outside the frozen V2 DUT

## Measurement path

`IP TX -> packet_generator -> frozen V2 -> packet_receiver -> IP RX`

The metrics monitor observes injection and receive events alongside the frozen DUT.

## Packet format

- `[47:46]` destination cluster
- `[45:44]` destination row
- `[43:42]` destination column
- `[41:40]` source cluster
- `[39:38]` source row
- `[37:36]` source column
- `[35:34]` packet type
- `[33:32]` priority
- `[31:0]` payload / experiment transaction ID

## Measurement rules

1. Do not modify the frozen V2 DUT for metrics.
2. Use a unique payload ID for every performance transaction.
3. Count injection events at the experiment harness boundary.
4. Use packet reception and packet decoding for delivery validation.
5. Local hop count = Manhattan distance.
6. Inter-cluster implemented-path hop model = source -> R0 gateway + one global-network transfer + R0 -> destination.
7. Metrics must describe the implemented RTL accurately rather than claiming unimplemented physical Spidergon forwarding hops.

## Planned metrics

- delivered packets
- unmatched receives
- latency min/avg/max
- hybrid hop count min/avg/max
- throughput
- offered load
- delivery ratio
- latency versus offered load
- local versus inter-cluster traffic comparison

## Infrastructure files

- `Source/RTL/noc_v2_ip_endpoint.v`
- `Source/RTL/noc_v2_hybrid_hop_calculator.v`
- `Source/RTL/noc_v2_metrics_monitor.v`
- `Source/Testbench/hybrid_noc_v2_metrics_sanity_tb_full_fixed.v`
