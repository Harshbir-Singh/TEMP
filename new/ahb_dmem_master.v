`timescale 1ns / 1ps

module ahb_dmem_master (
    input wire clk,
    input wire rst,

    input wire mem_access,
    input wire mem_write,
    input wire [31:0] addr,
    input wire [31:0] wdata,
    input wire [2:0] funct3,

    output wire [31:0] rdata,
    output wire mem_ready,

    output wire [31:0] HADDR,
    output wire [1:0]  HTRANS,
    output wire HWRITE,
    output wire [2:0] HSIZE,
    output wire [2:0] HBURST,
    output wire [3:0] HPROT,
    output wire [31:0] HWDATA,

    input  wire [31:0] HRDATA,
    input  wire HREADY,
    input  wire HRESP
);

    assign HADDR  = addr;
    assign HWRITE = mem_access & mem_write;

    assign HSIZE = (funct3[1:0] == 2'b00) ? 3'b000 :   // byte
                   (funct3[1:0] == 2'b01) ? 3'b001 :   // halfword
                                             3'b010;    // word

    assign HBURST = 3'b000;       // SINGLE transfer
    assign HPROT  = 4'b0011;      // normal data access
    assign HWDATA = wdata;

    assign HTRANS = mem_access ? 2'b10 : 2'b00; // NONSEQ / IDLE

    assign rdata = HRDATA;

    assign mem_ready = HREADY & ~HRESP;

endmodule