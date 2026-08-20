# Source manifest

The current source snapshot contains the following Verilog files. They are listed here so the repository structure can be checked before the files are moved into their final folders.

## RTL

`adaptive_routing.v`  
`address_translator.v`  
`arbiter_bank.v`  
`congestion_checker.v`  
`crossbar_switch.v`  
`fifo.v`  
`gateway_decoder.v`  
`gateway_direction.v`  
`gateway_interface.v`  
`gateway_selector.v`  
`global_network_4cluster.v`  
`grant_to_select.v`  
`hop_calculator.v`  
`hybrid_noc.v`  
`hybrid_noc_v2.v`  
`input_buffer.v`  
`input_port.v`  
`mesh_4x4_v2.v`  
`noc_defines.vh`  
`noc_v2_hybrid_hop_calculator.v`  
`noc_v2_ip_endpoint.v`  
`noc_v2_metrics_monitor.v`  
`output_buffer.v`  
`output_port.v`  
`packet_generator.v`  
`packet_receiver.v`  
`priority_logic.v`  
`request_classifier.v`  
`request_generator.v`  
`round_robin_arbiter.v`  
`router.v`  
`router_controller.v`  
`router_control_logic.v`  
`routing_unit.v`  
`spidergon_routing.v`  
`xy_routing.v`

## Testbenches

The snapshot also contains module-level, gateway, routing, mesh, global-network and full-system testbenches, including the V2 comprehensive, smoke and metrics sanity benches.

The original archive remains the reference for the exact source contents while the final folder placement is being reviewed.