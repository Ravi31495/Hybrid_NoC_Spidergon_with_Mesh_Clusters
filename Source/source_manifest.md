# Source Manifest

The supplied final 4×4-mesh/4-cluster project package contains **78 files** in total. This manifest records the source snapshot and keeps the repository honest about what is active versus legacy.

## Main RTL / support files

```text
adaptive_routing.v
address_translator.v
arbiter_bank.v
congestion_checker.v
crossbar_switch.v
fifo.v
gateway_decoder.v
gateway_direction.v
gateway_direction_tb.v
gateway_interface.v
gateway_selector.v
global_network_4cluster.v
grant_to_select.v
hop_calculator.v
hybrid_noc.v
hybrid_noc_v2.v
hybrid_noc_v2_comprehensive_tb.v
hybrid_noc_v2_smoke_tb.v
input_buffer.v
input_port.v
mesh_4x4_v2.v
noc_defines.vh
output_buffer.v
output_port.v
packet_generator.v
packet_receiver.v
priority_logic.v
request_classifier.v
request_generator.v
round_robin_arbiter.v
router.v
router_control_logic.v
router_controller.v
routing_unit.v
spidergon_routing.v
xy_routing.v
```

## Testbenches

```text
adaptive_routing_tb.v
address_translator_tb.v
arbiter_bank_tb.v
congestion_checker_tb.v
crossbar_switch_tb.v
gateway_decoder_tb.v
gateway_integration_tb.v
gateway_interface_tb.v
gateway_mesh_tb.v
gateway_path_tb.v
gateway_selector_tb.v
global_network_4cluster_tb.v
grant_to_select_tb.v
hop_calculator_tb.v
hybrid_noc_comprehensive_tb.v
hybrid_noc_comprehensive_tb_clean.v
hybrid_noc_comprehensive_tb_final.v
hybrid_noc_tb.v
input_buffer_tb.v
input_port_tb.v
mesh_tb.v
output_buffer_tb.v
output_port_tb.v
packet_generator_tb.v
packet_receiver_tb.v
priority_logic_tb.v
request_classifier_tb.v
request_generator_tb.v
round_robin_arbiter_tb.v
router_controller_tb.v
router_control_logic_tb.v
router_tb.v
router_tb_cgpt.v
router_tb_ideal.v
routing_unit_tb.v
spidergon_routing_tb.v
tb_router.v
tb_router2.v
xy_routing_tb.v
```

### Current/legacy notes

- `hybrid_noc.v` and `hybrid_noc_v2.v` are byte-for-byte identical in the supplied archive; the repository documentation treats the V2 naming as a compatibility/iteration artifact rather than a separate architecture.
- `hybrid_noc_comprehensive_tb_final.v` is the preferred full-system verification bench in the supplied snapshot.
- `mesh_tb.v` is a 0-byte legacy placeholder and should not be counted as an active test.
- The original ZIP remains useful as an archival snapshot of the complete source package until every source file is mirrored into browsable GitHub folders.
