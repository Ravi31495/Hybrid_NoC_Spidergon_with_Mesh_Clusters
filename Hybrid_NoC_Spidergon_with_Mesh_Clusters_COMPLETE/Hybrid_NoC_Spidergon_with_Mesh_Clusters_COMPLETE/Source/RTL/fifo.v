`timescale 1ns / 1ps

module fifo
#(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 8
)
(
    input                   clk,
    input                   rst,

    input                   wr_en,
    input                   rd_en,

    input  [DATA_WIDTH-1:0] data_in,

    output [DATA_WIDTH-1:0] data_out,
    output                  full,
    output                  empty,
    output                  almost_empty
);

localparam ADDR_WIDTH = $clog2(DEPTH);

reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];

reg [ADDR_WIDTH-1:0] wr_ptr;
reg [ADDR_WIDTH-1:0] rd_ptr;
reg [ADDR_WIDTH:0]   count;

`ifndef SYNTHESIS
integer i;
`endif

//--------------------------------------------------
// Status
//--------------------------------------------------

assign full         = (count == DEPTH);
assign empty        = (count == 0);
assign almost_empty = (count == 1);

//--------------------------------------------------
// First Word Fall Through
//--------------------------------------------------

assign data_out =
    empty ? {DATA_WIDTH{1'b0}} : memory[rd_ptr];

//--------------------------------------------------
// FIFO sequential logic
//--------------------------------------------------

always @(posedge clk or posedge rst)
begin

    if (rst)
    begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        count  <= 0;

`ifndef SYNTHESIS
        for (i = 0; i < DEPTH; i = i + 1)
            memory[i] <= {DATA_WIDTH{1'b0}};
`endif
    end

    else
    begin

        //--------------------------------------------------
        // WRITE ONLY
        //--------------------------------------------------

        if (wr_en && !rd_en)
        begin
            if (!full)
            begin
                memory[wr_ptr] <= data_in;

                if (wr_ptr == DEPTH-1)
                    wr_ptr <= 0;
                else
                    wr_ptr <= wr_ptr + 1'b1;

                count <= count + 1'b1;
            end
        end

        //--------------------------------------------------
        // READ ONLY
        //--------------------------------------------------

        else if (!wr_en && rd_en)
        begin
            if (!empty)
            begin

`ifndef SYNTHESIS
                memory[rd_ptr] <= {DATA_WIDTH{1'b0}};
`endif

                if (rd_ptr == DEPTH-1)
                    rd_ptr <= 0;
                else
                    rd_ptr <= rd_ptr + 1'b1;

                count <= count - 1'b1;
            end
        end

        //--------------------------------------------------
        // SIMULTANEOUS READ + WRITE
        //--------------------------------------------------

        else if (wr_en && rd_en)
        begin

            //--------------------------------------------------
            // Normal FIFO operation
            //--------------------------------------------------

            if (!full && !empty)
            begin
                memory[wr_ptr] <= data_in;

`ifndef SYNTHESIS
                memory[rd_ptr] <= {DATA_WIDTH{1'b0}};
`endif

                if (wr_ptr == DEPTH-1)
                    wr_ptr <= 0;
                else
                    wr_ptr <= wr_ptr + 1'b1;

                if (rd_ptr == DEPTH-1)
                    rd_ptr <= 0;
                else
                    rd_ptr <= rd_ptr + 1'b1;

                // Number of entries remains unchanged.
                count <= count;
            end

            //--------------------------------------------------
            // FIFO EMPTY
            //
            // Accept the write.
            // No valid old word exists to read.
            //--------------------------------------------------

            else if (empty)
            begin
                memory[wr_ptr] <= data_in;

                if (wr_ptr == DEPTH-1)
                    wr_ptr <= 0;
                else
                    wr_ptr <= wr_ptr + 1'b1;

                count <= count + 1'b1;
            end

            //--------------------------------------------------
            // FIFO FULL
            //
            // Consume one old word and insert one new word.
            // Count remains FULL.
            //--------------------------------------------------

            else if (full)
            begin
                memory[wr_ptr] <= data_in;

`ifndef SYNTHESIS
                // Do not clear memory here because wr_ptr and
                // rd_ptr may refer to the same physical slot.
`endif

                if (wr_ptr == DEPTH-1)
                    wr_ptr <= 0;
                else
                    wr_ptr <= wr_ptr + 1'b1;

                if (rd_ptr == DEPTH-1)
                    rd_ptr <= 0;
                else
                    rd_ptr <= rd_ptr + 1'b1;

                count <= count;
            end

        end

    end

end

endmodule