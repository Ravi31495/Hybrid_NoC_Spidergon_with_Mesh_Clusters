`ifndef NOC_DEFINES_VH
`define NOC_DEFINES_VH

///////////////////////////////////////////////////////////////////////////////
// Hybrid NoC Global Definitions
///////////////////////////////////////////////////////////////////////////////
//
// This file contains global packet, network, port, and routing definitions.
//
///////////////////////////////////////////////////////////////////////////////


//=============================================================================
// PACKET CONFIGURATION
//=============================================================================

`define PACKET_WIDTH      48

`define CLUSTER_BITS      2
`define ROW_BITS          2
`define COL_BITS          2

`define TYPE_BITS         2
`define PRIORITY_BITS     2
`define PAYLOAD_BITS      32


//=============================================================================
// NETWORK CONFIGURATION
//=============================================================================

`define NUM_CLUSTERS      4

// Router now has:
//   0 = LOCAL
//   1 = NORTH
//   2 = SOUTH
//   3 = EAST
//   4 = WEST
//   5 = GATEWAY

`define ROUTER_PORTS      6


//=============================================================================
// PHYSICAL ROUTER PORT ENCODING
//=============================================================================

`define LOCAL             3'b000
`define NORTH             3'b001
`define SOUTH             3'b010
`define EAST              3'b011
`define WEST              3'b100
`define GATEWAY           3'b101


//=============================================================================
// GLOBAL / SPIDERGON ROUTING DIRECTIONS
//=============================================================================
//
// These are NOT physical router ports.
//
// They represent directions in the global Spidergon topology.
//
// They are intentionally kept separate from LOCAL/NORTH/SOUTH/EAST/WEST/GATEWAY.
//
///////////////////////////////////////////////////////////////////////////////

// IMPORTANT:
// Existing Spidergon code may already use these values.
// Do not change their meaning without checking spidergon_routing.v.

`define CLOCKWISE         3'b110
`define COUNTER_CLOCKWISE 3'b111


//=============================================================================
// PACKET TYPES
//=============================================================================

`define DATA_PACKET       2'b00
`define CONTROL_PACKET    2'b01
`define ACK_PACKET        2'b10
`define RESERVED_PACKET   2'b11


//=============================================================================
// PACKET PRIORITIES
//=============================================================================

`define LOW_PRIORITY      2'b00
`define MEDIUM_PRIORITY   2'b01
`define HIGH_PRIORITY     2'b10
`define CRITICAL_PRIORITY 2'b11


`endif