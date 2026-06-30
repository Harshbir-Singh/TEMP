`timescale 1ns / 1ps

module ahb_imem_master (
    input  wire clk,
    input  wire rst,

    input  wire [31:0] instr_addr,
    output wire [31:0] instr_data,

    output wire [31:0] HADDR,
    output wire [1:0]  HTRANS,
    output wire HWRITE,
    output wire [2:0]  HSIZE,
    output wire [2:0]  HBURST,
    output wire [3:0]  HPROT,
    output wire [31:0] HWDATA,

    input  wire [31:0] HRDATA,
    input  wire HREADY,
    input  wire HRESP
);

    assign HADDR  = instr_addr;
    assign HTRANS = rst ? 2'b00 : 2'b10;       // NONSEQ every fetch
    assign HWRITE = 1'b0;        // read only
    assign HSIZE  = 3'b010;      // word
    assign HBURST = 3'b000;      // SINGLE
    assign HPROT = 4'b0010;     // instruction access
    assign HWDATA = 32'b0;

    assign instr_data = HRDATA;

endmodule