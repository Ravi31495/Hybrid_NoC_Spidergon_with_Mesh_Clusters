`timescale 1ns / 1ps

module grant_to_select_tb;

    reg  [4:0] grant;
    wire [2:0] sel;

    integer errors;

    //--------------------------------------------------
    // DUT
    //--------------------------------------------------

    grant_to_select DUT
    (
        .grant (grant),
        .sel   (sel)
    );

    //--------------------------------------------------
    // Test
    //--------------------------------------------------

    initial
    begin

        errors = 0;

        $display("");
        $display("================================================");
        $display("          GRANT TO SELECT UNIT TEST");
        $display("================================================");
        $display("");

        //--------------------------------------------------
        // TEST 1 : NO GRANT
        //--------------------------------------------------

        grant = 5'b00000;
        #1;

        if (sel !== 3'd0)
        begin
            $display("FAIL: NO GRANT");
            $display("      Expected = 0");
            $display("      Actual   = %0d", sel);
            errors = errors + 1;
        end
        else
            $display("PASS: NO GRANT");

        //--------------------------------------------------
        // TEST 2 : INPUT 0
        //--------------------------------------------------

        grant = 5'b00001;
        #1;

        if (sel !== 3'd0)
        begin
            $display("FAIL: GRANT INPUT 0");
            $display("      Expected = 0");
            $display("      Actual   = %0d", sel);
            errors = errors + 1;
        end
        else
            $display("PASS: GRANT INPUT 0");

        //--------------------------------------------------
        // TEST 3 : INPUT 1
        //--------------------------------------------------

        grant = 5'b00010;
        #1;

        if (sel !== 3'd1)
        begin
            $display("FAIL: GRANT INPUT 1");
            $display("      Expected = 1");
            $display("      Actual   = %0d", sel);
            errors = errors + 1;
        end
        else
            $display("PASS: GRANT INPUT 1");

        //--------------------------------------------------
        // TEST 4 : INPUT 2
        //--------------------------------------------------

        grant = 5'b00100;
        #1;

        if (sel !== 3'd2)
        begin
            $display("FAIL: GRANT INPUT 2");
            $display("      Expected = 2");
            $display("      Actual   = %0d", sel);
            errors = errors + 1;
        end
        else
            $display("PASS: GRANT INPUT 2");

        //--------------------------------------------------
        // TEST 5 : INPUT 3
        //--------------------------------------------------

        grant = 5'b01000;
        #1;

        if (sel !== 3'd3)
        begin
            $display("FAIL: GRANT INPUT 3");
            $display("      Expected = 3");
            $display("      Actual   = %0d", sel);
            errors = errors + 1;
        end
        else
            $display("PASS: GRANT INPUT 3");

        //--------------------------------------------------
        // TEST 6 : INPUT 4
        //--------------------------------------------------

        grant = 5'b10000;
        #1;

        if (sel !== 3'd4)
        begin
            $display("FAIL: GRANT INPUT 4");
            $display("      Expected = 4");
            $display("      Actual   = %0d", sel);
            errors = errors + 1;
        end
        else
            $display("PASS: GRANT INPUT 4");

        //--------------------------------------------------
        // TEST 7 : ALL GRANTS
        //
        // Multiple grants are invalid after arbitration.
        // grant_to_select defaults to select 0.
        //--------------------------------------------------

        grant = 5'b11111;
        #1;

        if (sel !== 3'd0)
        begin
            $display("FAIL: ALL GRANTS");
            $display("      Expected = 0");
            $display("      Actual   = %0d", sel);
            errors = errors + 1;
        end
        else
            $display("PASS: ALL GRANTS");

        //--------------------------------------------------
        // TEST 8 : MULTIPLE GRANTS 00011
        //--------------------------------------------------

        grant = 5'b00011;
        #1;

        if (sel !== 3'd0)
        begin
            $display("FAIL: MULTIPLE GRANTS 00011");
            $display("      Expected = 0");
            $display("      Actual   = %0d", sel);
            errors = errors + 1;
        end
        else
            $display("PASS: MULTIPLE GRANTS 00011");

        //--------------------------------------------------
        // TEST 9 : MULTIPLE GRANTS 00110
        //--------------------------------------------------

        grant = 5'b00110;
        #1;

        if (sel !== 3'd0)
        begin
            $display("FAIL: MULTIPLE GRANTS 00110");
            $display("      Expected = 0");
            $display("      Actual   = %0d", sel);
            errors = errors + 1;
        end
        else
            $display("PASS: MULTIPLE GRANTS 00110");

        //--------------------------------------------------
        // TEST 10 : MULTIPLE GRANTS 11000
        //--------------------------------------------------

        grant = 5'b11000;
        #1;

        if (sel !== 3'd0)
        begin
            $display("FAIL: MULTIPLE GRANTS 11000");
            $display("      Expected = 0");
            $display("      Actual   = %0d", sel);
            errors = errors + 1;
        end
        else
            $display("PASS: MULTIPLE GRANTS 11000");

        //--------------------------------------------------
        // TEST 11 : EVERY VALID ONE-HOT VALUE
        //--------------------------------------------------

        grant = 5'b00001;
        #1;

        if (sel !== 3'd0)
        begin
            $display("FAIL: ONE-HOT 0");
            errors = errors + 1;
        end

        grant = 5'b00010;
        #1;

        if (sel !== 3'd1)
        begin
            $display("FAIL: ONE-HOT 1");
            errors = errors + 1;
        end

        grant = 5'b00100;
        #1;

        if (sel !== 3'd2)
        begin
            $display("FAIL: ONE-HOT 2");
            errors = errors + 1;
        end

        grant = 5'b01000;
        #1;

        if (sel !== 3'd3)
        begin
            $display("FAIL: ONE-HOT 3");
            errors = errors + 1;
        end

        grant = 5'b10000;
        #1;

        if (sel !== 3'd4)
        begin
            $display("FAIL: ONE-HOT 4");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("PASS: ALL VALID ONE-HOT GRANTS");

        //--------------------------------------------------
        // RESULT
        //--------------------------------------------------

        $display("");
        $display("================================================");

        if (errors == 0)
            $display("RESULT : ALL GRANT TO SELECT TESTS PASSED");
        else
            $display("RESULT : %0d TESTS FAILED", errors);

        $display("================================================");
        $display("");

        $finish;

    end

endmodule