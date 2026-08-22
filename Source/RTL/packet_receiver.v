
`timescale 1ns / 1ps

module packet_receiver
#(
    parameter CLUSTER_BITS  = 2,
    parameter ROW_BITS      = 2,
    parameter COL_BITS      = 2,
    parameter TYPE_BITS     = 2,
    parameter PRIORITY_BITS = 2,
    parameter PAYLOAD_BITS  = 32,

    parameter PACKET_WIDTH =
            (2*CLUSTER_BITS) +
            (2*ROW_BITS) +
            (2*COL_BITS) +
            TYPE_BITS +
            PRIORITY_BITS +
            PAYLOAD_BITS
)
(
    input clk,
    input rst,

    input [PACKET_WIDTH-1:0] packet_in,
    input packet_valid_in,

    input [CLUSTER_BITS-1:0] my_cluster,
    input [ROW_BITS-1:0]     my_row,
    input [COL_BITS-1:0]     my_col,

    output reg packet_received,

    output reg [CLUSTER_BITS-1:0] src_cluster,
    output reg [ROW_BITS-1:0]     src_row,
    output reg [COL_BITS-1:0]     src_col,

    output reg [TYPE_BITS-1:0]     packet_type,
    output reg [PRIORITY_BITS-1:0] priority,

    output reg [PAYLOAD_BITS-1:0] payload
);

reg [CLUSTER_BITS-1:0] dst_cluster;
reg [ROW_BITS-1:0]     dst_row;
reg [COL_BITS-1:0]     dst_col;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        packet_received <= 1'b0;

        src_cluster <= 0;
        src_row     <= 0;
        src_col     <= 0;

        packet_type <= 0;
        priority    <= 0;
        payload     <= 0;
    end

    else
    begin

        packet_received <= 1'b0;

        if(packet_valid_in)
        begin

            // Destination check
            if( packet_in[47:46] == my_cluster &&
                packet_in[45:44] == my_row &&
                packet_in[43:42] == my_col )
            begin

                packet_received <= 1'b1;

                src_cluster <= packet_in[41:40];
                src_row     <= packet_in[39:38];
                src_col     <= packet_in[37:36];

                packet_type <= packet_in[35:34];
                priority    <= packet_in[33:32];

                payload     <= packet_in[31:0];

            end

        end

    end

end
endmodule

