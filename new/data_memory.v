`timescale 1ns / 1ps

module ahb_data_memory (
    input wire HCLK,
    input wire HRESETn,
    input wire [31:0] HADDR,
    input wire [1:0]  HTRANS,
    input wire HWRITE,
    input wire [2:0]  HSIZE,
    input wire [31:0] HWDATA,
    output wire [31:0] HRDATA,
    output wire HREADY,
    output wire HRESP
);

    reg [31:0] data_mem [0:65535];

    wire transfer = HTRANS[1] & HREADY;
    wire [15:0] widx = (HADDR - 32'h80000000) >> 2;

    integer i;
    /*
    initial begin
        for (i = 0; i < 65536; i = i + 1)
            data_mem[i] = 32'h00000000;
    end
    */
    always @(posedge HCLK) begin
        if (!HRESETn) begin
            // optional reset
        end
        else if (transfer && HWRITE) begin
            case (HSIZE)
                3'b000: data_mem[widx][HADDR[1:0]*8 +: 8] <= HWDATA[7:0];
                3'b001: data_mem[widx][HADDR[1]*16 +: 16] <= HWDATA[15:0];
                3'b010: data_mem[widx] <= HWDATA;
                default: data_mem[widx] <= HWDATA;
            endcase
        end
    end

    assign HRDATA = data_mem[widx];

    assign HREADY = 1'b1;   // zero wait-state memory
    assign HRESP = 1'b0;   // OKAY

endmodule