`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name : gateway_selector
// Description : Determines whether a packet must leave the
//               current mesh cluster through its gateway.
//
// Output:
//   gateway_required = 0 -> destination is in this cluster
//   gateway_required = 1 -> destination is in another cluster
//////////////////////////////////////////////////////////////////////////////////

module gateway_selector
(
    input  [1:0] current_cluster,
    input  [1:0] dest_cluster,

    output reg gateway_required
);

always @(*)
begin

    //--------------------------------------------------
    // Packet stays inside the current cluster
    //--------------------------------------------------

    if (current_cluster == dest_cluster)
    begin
        gateway_required = 1'b0;
    end

    //--------------------------------------------------
    // Packet must leave the current cluster
    //--------------------------------------------------

    else
    begin
        gateway_required = 1'b1;
    end

end

endmodule