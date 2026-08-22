`timescale 1ns / 1ps
`include "noc_defines.vh"

module gateway_path_tb;

reg clk;
reg rst;

reg [1:0] current_cluster;
reg [1:0] dest_cluster;

wire gateway_required;
wire [1:0] gateway_dir;

reg [`PACKET_WIDTH-1:0] local_packet_in;
reg local_valid_in;
wire local_ready_out;

wire [`PACKET_WIDTH-1:0] local_packet_out;
wire local_valid_out;
reg local_ready_in;

reg [2:0] route_direction;

wire [`PACKET_WIDTH-1:0] north_packet_out;
wire north_valid_out;
reg north_ready_in;
reg [`PACKET_WIDTH-1:0] north_packet_in;
reg north_valid_in;
wire north_ready_out;

wire [`PACKET_WIDTH-1:0] south_packet_out;
wire south_valid_out;
reg south_ready_in;
reg [`PACKET_WIDTH-1:0] south_packet_in;
reg south_valid_in;
wire south_ready_out;

wire [`PACKET_WIDTH-1:0] east_packet_out;
wire east_valid_out;
reg east_ready_in;
reg [`PACKET_WIDTH-1:0] east_packet_in;
reg east_valid_in;
wire east_ready_out;

wire [`PACKET_WIDTH-1:0] west_packet_out;
wire west_valid_out;
reg west_ready_in;
reg [`PACKET_WIDTH-1:0] west_packet_in;
reg west_valid_in;
wire west_ready_out;


/* Gateway direction encoding */
localparam GW_EAST  = 2'd0;
localparam GW_SOUTH = 2'd1;
localparam GW_WEST  = 2'd2;
localparam GW_LOCAL = 2'd3;

/* Gateway interface direction encoding */
localparam LOCAL = 3'b000;
localparam NORTH = 3'b001;
localparam SOUTH = 3'b010;
localparam EAST  = 3'b011;
localparam WEST  = 3'b100;

integer errors;


/*=============================================================
  DUT 1 : gateway_selector
=============================================================*/

gateway_selector U_SELECTOR (
    .current_cluster(current_cluster),
    .dest_cluster(dest_cluster),
    .gateway_required(gateway_required)
);


/*=============================================================
  DUT 2 : gateway_direction
=============================================================*/

gateway_direction U_DIRECTION (
    .current_cluster(current_cluster),
    .dest_cluster(dest_cluster),
    .direction(gateway_dir)
);


/*=============================================================
  Gateway direction conversion
=============================================================*/

always @(*) begin

    case (gateway_dir)

        GW_EAST:
            route_direction = EAST;

        GW_SOUTH:
            route_direction = SOUTH;

        GW_WEST:
            route_direction = WEST;

        default:
            route_direction = LOCAL;

    endcase

end


/*=============================================================
  DUT 3 : gateway_interface
=============================================================*/

gateway_interface U_INTERFACE (
    .clk(clk),
    .rst(rst),

    .local_packet_in(local_packet_in),
    .local_valid_in(local_valid_in),
    .local_ready_out(local_ready_out),

    .local_packet_out(local_packet_out),
    .local_valid_out(local_valid_out),
    .local_ready_in(local_ready_in),

    .route_direction(route_direction),

    .north_packet_out(north_packet_out),
    .north_valid_out(north_valid_out),
    .north_ready_in(north_ready_in),

    .north_packet_in(north_packet_in),
    .north_valid_in(north_valid_in),
    .north_ready_out(north_ready_out),

    .south_packet_out(south_packet_out),
    .south_valid_out(south_valid_out),
    .south_ready_in(south_ready_in),

    .south_packet_in(south_packet_in),
    .south_valid_in(south_valid_in),
    .south_ready_out(south_ready_out),

    .east_packet_out(east_packet_out),
    .east_valid_out(east_valid_out),
    .east_ready_in(east_ready_in),

    .east_packet_in(east_packet_in),
    .east_valid_in(east_valid_in),
    .east_ready_out(east_ready_out),

    .west_packet_out(west_packet_out),
    .west_valid_out(west_valid_out),
    .west_ready_in(west_ready_in),

    .west_packet_in(west_packet_in),
    .west_valid_in(west_valid_in),
    .west_ready_out(west_ready_out)
);


/*=============================================================
  Clock
=============================================================*/

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end


/*=============================================================
  Initialization
=============================================================*/

task init;
begin

    rst = 1'b0;

    current_cluster = 2'd0;
    dest_cluster = 2'd0;

    local_packet_in = {`PACKET_WIDTH{1'b0}};
    local_valid_in = 1'b0;
    local_ready_in = 1'b1;

    north_ready_in = 1'b1;
    south_ready_in = 1'b1;
    east_ready_in  = 1'b1;
    west_ready_in  = 1'b1;

    north_packet_in = {`PACKET_WIDTH{1'b0}};
    south_packet_in = {`PACKET_WIDTH{1'b0}};
    east_packet_in  = {`PACKET_WIDTH{1'b0}};
    west_packet_in  = {`PACKET_WIDTH{1'b0}};

    north_valid_in = 1'b0;
    south_valid_in = 1'b0;
    east_valid_in  = 1'b0;
    west_valid_in  = 1'b0;

end
endtask


/*=============================================================
  Test one gateway path
=============================================================*/

task check_path;
input [1:0] cur;
input [1:0] dst;
input [1:0] expected_gw;
input [2:0] expected_route;
begin

    current_cluster = cur;
    dest_cluster = dst;

    local_packet_in = 48'h1234_5678_9ABC;
    local_valid_in = 1'b1;

    #1;

    if (gateway_required !== 1'b1) begin
        $display("ERROR: gateway_required wrong for %0d -> %0d",
                 cur, dst);
        errors = errors + 1;
    end

    if (gateway_dir !== expected_gw) begin
        $display("ERROR: gateway direction wrong for %0d -> %0d",
                 cur, dst);
        errors = errors + 1;
    end

    if (route_direction !== expected_route) begin
        $display("ERROR: route direction wrong for %0d -> %0d",
                 cur, dst);
        errors = errors + 1;
    end

    #1;

    case (expected_route)

        EAST: begin
            if (!east_valid_out ||
                 north_valid_out ||
                 south_valid_out ||
                 west_valid_out) begin
                $display("ERROR: EAST output selection failed");
                errors = errors + 1;
            end
        end

        SOUTH: begin
            if (!south_valid_out ||
                 north_valid_out ||
                 east_valid_out ||
                 west_valid_out) begin
                $display("ERROR: SOUTH output selection failed");
                errors = errors + 1;
            end
        end

        WEST: begin
            if (!west_valid_out ||
                 north_valid_out ||
                 south_valid_out ||
                 east_valid_out) begin
                $display("ERROR: WEST output selection failed");
                errors = errors + 1;
            end
        end

        default: begin
            $display("ERROR: invalid external direction");
            errors = errors + 1;
        end

    endcase

    $display("PASS: Cluster %0d -> Cluster %0d",
             cur, dst);

end
endtask


/*=============================================================
  Same-cluster test
=============================================================*/

task check_local;
begin

    current_cluster = 2'd2;
    dest_cluster = 2'd2;

    local_packet_in = 48'hAAAA_BBBB_CCCC;
    local_valid_in = 1'b1;

    #1;

    if (gateway_required !== 1'b0) begin
        $display("ERROR: same cluster gateway_required");
        errors = errors + 1;
    end

    if (gateway_dir !== GW_LOCAL) begin
        $display("ERROR: same cluster gateway direction");
        errors = errors + 1;
    end

    if (route_direction !== LOCAL) begin
        $display("ERROR: same cluster route direction");
        errors = errors + 1;
    end

    if (north_valid_out ||
        south_valid_out ||
        east_valid_out ||
        west_valid_out) begin

        $display("ERROR: local packet sent to global network");
        errors = errors + 1;

    end

    $display("PASS: Same cluster 2 -> 2");

end
endtask


/*=============================================================
  Back-pressure test
=============================================================*/

task check_backpressure;
begin

    current_cluster = 2'd0;
    dest_cluster = 2'd1;

    local_packet_in = 48'h1111_2222_3333;
    local_valid_in = 1'b1;

    east_ready_in = 1'b0;

    #1;

    if (east_valid_out !== 1'b1) begin
        $display("ERROR: EAST valid lost under back-pressure");
        errors = errors + 1;
    end

    if (local_ready_out !== 1'b0) begin
        $display("ERROR: local_ready_out should be 0");
        errors = errors + 1;
    end

    $display("PASS: EAST back-pressure");

end
endtask


/*=============================================================
  Main test
=============================================================*/

initial begin

    errors = 0;

    init;

    #10;

    $display("");
    $display("==============================================");
    $display("       GATEWAY PATH INTEGRATION TEST");
    $display("==============================================");
    $display("");

    /* Cluster 0 */
    check_path(2'd0, 2'd1, GW_EAST,  EAST);
    check_path(2'd0, 2'd2, GW_SOUTH, SOUTH);
    check_path(2'd0, 2'd3, GW_WEST,  WEST);

    /* Cluster 1 */
    check_path(2'd1, 2'd2, GW_EAST,  EAST);
    check_path(2'd1, 2'd3, GW_SOUTH, SOUTH);
    check_path(2'd1, 2'd0, GW_WEST,  WEST);

    /* Same cluster */
    check_local;

    /* Back-pressure */
    init;
    check_backpressure;

    #10;

    $display("");
    $display("==============================================");

    if (errors == 0)
        $display("RESULT : ALL TESTS PASSED");
    else
        $display("RESULT : %0d TESTS FAILED", errors);

    $display("==============================================");

    $finish;

end

endmodule