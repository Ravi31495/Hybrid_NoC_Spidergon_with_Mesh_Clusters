`timescale 1ns / 1ps

module arbiter_bank_tb;

reg clk;
reg rst;

reg [4:0] local_req;
reg [4:0] north_req;
reg [4:0] south_req;
reg [4:0] east_req;
reg [4:0] west_req;

wire [4:0] local_grant;
wire [4:0] north_grant;
wire [4:0] south_grant;
wire [4:0] east_grant;
wire [4:0] west_grant;

integer errors;

arbiter_bank DUT
(
    .clk(clk),
    .rst(rst),

    .local_req(local_req),
    .north_req(north_req),
    .south_req(south_req),
    .east_req(east_req),
    .west_req(west_req),

    .local_grant(local_grant),
    .north_grant(north_grant),
    .south_grant(south_grant),
    .east_grant(east_grant),
    .west_grant(west_grant)
);

always #5 clk = ~clk;


//--------------------------------------------------
// Check one bank
//--------------------------------------------------

task check_bank;
    input [4:0] req;
    input [4:0] grant;
    input [255:0] name;

    begin

        // No grant when there are no requests
        if (req == 5'b00000)
        begin
            if (grant !== 5'b00000)
            begin
                $display("FAIL: %0s - grant with no request", name);
                errors = errors + 1;
            end
        end

        // Grant must belong to requester
        else if ((grant & ~req) != 5'b00000)
        begin
            $display("FAIL: %0s - grant is not a requester", name);
            $display("      Request = %05b", req);
            $display("      Grant   = %05b", grant);
            errors = errors + 1;
        end

        // At most one grant
        else if ((grant != 5'b00000) &&
                 ((grant & (grant - 1)) != 5'b00000))
        begin
            $display("FAIL: %0s - multiple grants", name);
            $display("      Request = %05b", req);
            $display("      Grant   = %05b", grant);
            errors = errors + 1;
        end

        else
        begin
            $display("PASS: %0s  Request=%05b Grant=%05b",
                     name, req, grant);
        end

    end
endtask


//--------------------------------------------------
// Check all five banks
//--------------------------------------------------

task check_all_banks;

    begin

        check_bank(local_req, local_grant, "LOCAL");
        check_bank(north_req, north_grant, "NORTH");
        check_bank(south_req, south_grant, "SOUTH");
        check_bank(east_req, east_grant, "EAST");
        check_bank(west_req, west_grant, "WEST");

    end

endtask


//--------------------------------------------------
// Test
//--------------------------------------------------

initial
begin

    errors = 0;

    clk = 1'b0;
    rst = 1'b1;

    local_req = 5'b00000;
    north_req = 5'b00000;
    south_req = 5'b00000;
    east_req  = 5'b00000;
    west_req  = 5'b00000;


    $display("");
    $display("================================================");
    $display("           ARBITER BANK UNIT TEST");
    $display("================================================");
    $display("");


    //--------------------------------------------------
    // TEST 1 : RESET
    //--------------------------------------------------

    #20;

    #1;

    if ((local_grant !== 5'b00000) ||
        (north_grant !== 5'b00000) ||
        (south_grant !== 5'b00000) ||
        (east_grant  !== 5'b00000) ||
        (west_grant  !== 5'b00000))
    begin
        $display("FAIL: RESET");
        errors = errors + 1;
    end
    else
        $display("PASS: RESET");


    rst = 1'b0;


    //--------------------------------------------------
    // TEST 2 : NO REQUESTS
    //--------------------------------------------------

    @(negedge clk);

    check_all_banks;


    //--------------------------------------------------
    // TEST 3 : SINGLE REQUEST PER BANK
    //--------------------------------------------------

    local_req = 5'b00100;
    north_req = 5'b01000;
    south_req = 5'b00010;
    east_req  = 5'b10000;
    west_req  = 5'b00001;

    @(negedge clk);
    #1;

    check_all_banks;


    //--------------------------------------------------
    // TEST 4 : DIFFERENT REQUEST PATTERNS
    //--------------------------------------------------

    local_req = 5'b10101;
    north_req = 5'b01010;
    south_req = 5'b00111;
    east_req  = 5'b11000;
    west_req  = 5'b10001;

    @(negedge clk);
    #1;

    check_all_banks;


    //--------------------------------------------------
    // TEST 5 : ALL REQUESTERS ACTIVE
    //--------------------------------------------------

    local_req = 5'b11111;
    north_req = 5'b11111;
    south_req = 5'b11111;
    east_req  = 5'b11111;
    west_req  = 5'b11111;

    @(negedge clk);
    #1;

    check_all_banks;


    //--------------------------------------------------
    // TEST 6 : ALL ACTIVE - SECOND CYCLE
    //--------------------------------------------------

    @(negedge clk);
    #1;

    check_all_banks;


    //--------------------------------------------------
    // TEST 7 : ALL ACTIVE - THIRD CYCLE
    //--------------------------------------------------

    @(negedge clk);
    #1;

    check_all_banks;


    //--------------------------------------------------
    // TEST 8 : ALL ACTIVE - FOURTH CYCLE
    //--------------------------------------------------

    @(negedge clk);
    #1;

    check_all_banks;


    //--------------------------------------------------
    // TEST 9 : ALL ACTIVE - FIFTH CYCLE
    //--------------------------------------------------

    @(negedge clk);
    #1;

    check_all_banks;


    //--------------------------------------------------
    // TEST 10 : CLEAR REQUESTS
    //--------------------------------------------------

    local_req = 5'b00000;
    north_req = 5'b00000;
    south_req = 5'b00000;
    east_req  = 5'b00000;
    west_req  = 5'b00000;

    @(negedge clk);
    #1;

    if ((local_grant !== 5'b00000) ||
        (north_grant !== 5'b00000) ||
        (south_grant !== 5'b00000) ||
        (east_grant  !== 5'b00000) ||
        (west_grant  !== 5'b00000))
    begin
        $display("FAIL: CLEAR REQUESTS");
        errors = errors + 1;
    end
    else
        $display("PASS: CLEAR REQUESTS");


    //--------------------------------------------------
    // RESULT
    //--------------------------------------------------

    $display("");
    $display("================================================");

    if (errors == 0)
        $display("RESULT : ALL ARBITER BANK TESTS PASSED");
    else
        $display("RESULT : %0d ARBITER BANK TESTS FAILED", errors);

    $display("================================================");
    $display("");

    $finish;

end

endmodule