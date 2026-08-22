`timescale 1ns / 1ps

module request_generator_tb;

reg fifo_empty;
reg fifo_almost_empty;
reg read_enable;

wire request;

integer errors;


request_generator DUT
(
    .fifo_empty(fifo_empty),
    .fifo_almost_empty(fifo_almost_empty),
    .read_enable(read_enable),
    .request(request)
);


initial
begin

    errors = 0;

    $display("");
    $display("================================================");
    $display("        REQUEST GENERATOR UNIT TEST");
    $display("================================================");
    $display("");


    //--------------------------------------------------
    // TEST 1 : FIFO EMPTY
    //--------------------------------------------------

    fifo_empty = 1'b1;
    fifo_almost_empty = 1'b0;
    read_enable = 1'b0;

    #1;

    if (request !== 1'b0)
    begin
        $display("FAIL: EMPTY FIFO");
        errors = errors + 1;
    end
    else
        $display("PASS: EMPTY FIFO");


    //--------------------------------------------------
    // TEST 2 : EMPTY + READ
    //--------------------------------------------------

    fifo_empty = 1'b1;
    fifo_almost_empty = 1'b0;
    read_enable = 1'b1;

    #1;

    if (request !== 1'b0)
    begin
        $display("FAIL: EMPTY + READ");
        errors = errors + 1;
    end
    else
        $display("PASS: EMPTY + READ");


    //--------------------------------------------------
    // TEST 3 : MULTIPLE ENTRIES
    //--------------------------------------------------

    fifo_empty = 1'b0;
    fifo_almost_empty = 1'b0;
    read_enable = 1'b0;

    #1;

    if (request !== 1'b1)
    begin
        $display("FAIL: DATA AVAILABLE");
        errors = errors + 1;
    end
    else
        $display("PASS: DATA AVAILABLE");


    //--------------------------------------------------
    // TEST 4 : MULTIPLE ENTRIES + READ
    //--------------------------------------------------

    fifo_empty = 1'b0;
    fifo_almost_empty = 1'b0;
    read_enable = 1'b1;

    #1;

    if (request !== 1'b1)
    begin
        $display("FAIL: DATA AVAILABLE + READ");
        errors = errors + 1;
    end
    else
        $display("PASS: DATA AVAILABLE + READ");


    //--------------------------------------------------
    // TEST 5 : EXACTLY ONE ENTRY
    //--------------------------------------------------

    fifo_empty = 1'b0;
    fifo_almost_empty = 1'b1;
    read_enable = 1'b0;

    #1;

    if (request !== 1'b1)
    begin
        $display("FAIL: ONE ENTRY");
        errors = errors + 1;
    end
    else
        $display("PASS: ONE ENTRY");


    //--------------------------------------------------
    // TEST 6 : LAST ENTRY BEING READ
    //--------------------------------------------------

    fifo_empty = 1'b0;
    fifo_almost_empty = 1'b1;
    read_enable = 1'b1;

    #1;

    if (request !== 1'b0)
    begin
        $display("FAIL: LAST ENTRY READ");
        errors = errors + 1;
    end
    else
        $display("PASS: LAST ENTRY READ");


    //--------------------------------------------------
    // TEST 7 : RETURN TO DATA AVAILABLE
    //--------------------------------------------------

    fifo_empty = 1'b0;
    fifo_almost_empty = 1'b0;
    read_enable = 1'b0;

    #1;

    if (request !== 1'b1)
    begin
        $display("FAIL: REQUEST REASSERTION");
        errors = errors + 1;
    end
    else
        $display("PASS: REQUEST REASSERTION");


    //--------------------------------------------------
    // RESULT
    //--------------------------------------------------

    $display("");
    $display("================================================");

    if (errors == 0)
        $display("RESULT : ALL REQUEST GENERATOR TESTS PASSED");
    else
        $display("RESULT : %0d TESTS FAILED", errors);

    $display("================================================");
    $display("");

    $finish;

end

endmodule