`timescale 1ns / 1ps

module ahb_instruction_memory (
    input wire HCLK,
    input wire HRESETn,
    input wire [31:0] HADDR,
    input wire [1:0] HTRANS,
    input wire HWRITE,
    input wire [2:0] HSIZE,
    output wire [31:0] HRDATA,
    output wire HREADY,
    output wire HRESP
);

    reg [31:0] imem [0:16383];
    wire transfer = HTRANS[1];
    wire [31:0] iaddr = (HADDR - 32'h80000000) >> 2;

    assign HRDATA = (!HWRITE && transfer && (HSIZE == 3'b010) && (iaddr < 32'd16384))
                    ? imem[iaddr]
                    : 32'h00000013;   // NOP

    assign HREADY = 1'b1;
    assign HRESP = 1'b0;

    /*
    initial begin
        $readmemh("program.hex", imem);
    end
    */
endmodule