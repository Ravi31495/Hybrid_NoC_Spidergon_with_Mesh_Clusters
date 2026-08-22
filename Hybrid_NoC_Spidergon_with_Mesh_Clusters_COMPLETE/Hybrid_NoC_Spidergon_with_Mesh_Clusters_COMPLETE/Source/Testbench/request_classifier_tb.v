`timescale 1ns / 1ps
`include "noc_defines.vh"

module request_classifier_tb;

reg [4:0] request;

reg [2:0] dir0;
reg [2:0] dir1;
reg [2:0] dir2;
reg [2:0] dir3;
reg [2:0] dir4;

wire [4:0] local_req;
wire [4:0] north_req;
wire [4:0] south_req;
wire [4:0] east_req;
wire [4:0] west_req;

integer errors;


//--------------------------------------------------
// DUT
//--------------------------------------------------

request_classifier DUT
(
    .request(request),

    .dir0(dir0),
    .dir1(dir1),
    .dir2(dir2),
    .dir3(dir3),
    .dir4(dir4),

    .local_req(local_req),
    .north_req(north_req),
    .south_req(south_req),
    .east_req(east_req),
    .west_req(west_req)
);


//--------------------------------------------------
// Test
//--------------------------------------------------

initial
begin

    errors = 0;

    request = 5'b00000;

    dir0 = `LOCAL;
    dir1 = `LOCAL;
    dir2 = `LOCAL;
    dir3 = `LOCAL;
    dir4 = `LOCAL;

    #1;

    $display("");
    $display("================================================");
    $display("       REQUEST CLASSIFIER UNIT TEST");
    $display("================================================");
    $display("");


    //--------------------------------------------------
    // TEST 1 : NO REQUESTS
    //--------------------------------------------------

    if ({west_req,east_req,south_req,north_req,local_req}
        !== 25'b0)
    begin
        $display("FAIL: NO REQUESTS");
        errors = errors + 1;
    end
    else
        $display("PASS: NO REQUESTS");


    //--------------------------------------------------
    // TEST 2 : ALL FIVE DIFFERENT DIRECTIONS
    //--------------------------------------------------

    request = 5'b11111;

    dir0 = `LOCAL;
    dir1 = `NORTH;
    dir2 = `SOUTH;
    dir3 = `EAST;
    dir4 = `WEST;

    #1;

    if (local_req !== 5'b00001)
    begin
        $display("FAIL: LOCAL CLASSIFICATION");
        errors = errors + 1;
    end
    else
        $display("PASS: LOCAL CLASSIFICATION");

    if (north_req !== 5'b00010)
    begin
        $display("FAIL: NORTH CLASSIFICATION");
        errors = errors + 1;
    end
    else
        $display("PASS: NORTH CLASSIFICATION");

    if (south_req !== 5'b00100)
    begin
        $display("FAIL: SOUTH CLASSIFICATION");
        errors = errors + 1;
    end
    else
        $display("PASS: SOUTH CLASSIFICATION");

    if (east_req !== 5'b01000)
    begin
        $display("FAIL: EAST CLASSIFICATION");
        errors = errors + 1;
    end
    else
        $display("PASS: EAST CLASSIFICATION");

    if (west_req !== 5'b10000)
    begin
        $display("FAIL: WEST CLASSIFICATION");
        errors = errors + 1;
    end
    else
        $display("PASS: WEST CLASSIFICATION");


    //--------------------------------------------------
    // TEST 3 : MULTIPLE REQUESTS TO EAST
    //--------------------------------------------------

    request = 5'b10101;

    dir0 = `EAST;
    dir2 = `EAST;
    dir4 = `EAST;

    dir1 = `LOCAL;
    dir3 = `LOCAL;

    #1;

    if (east_req !== 5'b10101)
    begin
        $display("FAIL: MULTIPLE EAST REQUESTS");
        errors = errors + 1;
    end
    else
        $display("PASS: MULTIPLE EAST REQUESTS");


    //--------------------------------------------------
    // TEST 4 : MULTIPLE REQUESTS TO NORTH
    //--------------------------------------------------

    request = 5'b11010;

    dir1 = `NORTH;
    dir3 = `NORTH;
    dir4 = `WEST;
    dir0 = `LOCAL;
    dir2 = `LOCAL;

    #1;

    if (north_req !== 5'b01010)
    begin
        $display("FAIL: MULTIPLE NORTH REQUESTS");
        errors = errors + 1;
    end
    else
        $display("PASS: MULTIPLE NORTH REQUESTS");


    //--------------------------------------------------
    // TEST 5 : REQUEST BIT MUST CONTROL CLASSIFICATION
    //--------------------------------------------------

    request = 5'b00000;

    dir0 = `EAST;
    dir1 = `NORTH;
    dir2 = `SOUTH;
    dir3 = `WEST;
    dir4 = `LOCAL;

    #1;

    if ((local_req !== 5'b00000) ||
        (north_req !== 5'b00000) ||
        (south_req !== 5'b00000) ||
        (east_req  !== 5'b00000) ||
        (west_req  !== 5'b00000))
    begin
        $display("FAIL: INACTIVE REQUESTS");
        errors = errors + 1;
    end
    else
        $display("PASS: INACTIVE REQUESTS");


    //--------------------------------------------------
    // TEST 6 : INVALID DIRECTION
    //--------------------------------------------------

    request = 5'b00001;

    dir0 = 3'b111;

    #1;

    if ({west_req,east_req,south_req,north_req,local_req}
        !== 25'b0)
    begin
        $display("FAIL: INVALID DIRECTION");
        errors = errors + 1;
    end
    else
        $display("PASS: INVALID DIRECTION");


    //--------------------------------------------------
    // RESULT
    //--------------------------------------------------

    $display("");
    $display("================================================");

    if (errors == 0)
        $display("RESULT : ALL REQUEST CLASSIFIER TESTS PASSED");
    else
        $display("RESULT : %0d TESTS FAILED", errors);

    $display("================================================");
    $display("");

    $finish;

end

endmodule