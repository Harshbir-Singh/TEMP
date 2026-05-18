`timescale 1ns / 1ps
module Data_Memory(clk, WE, WBE, WD, A, RD);
    input logic clk, WE;
    input logic [3:0]  WBE;
    input logic [31:0] A, WD;
    output logic [31:0] RD;
    logic [31:0] mem [1023:0];

    always_ff @(posedge clk) begin
        if(WE) begin
            if(WBE[0]) mem[A[31:2]][7:0] <= WD[7:0];
            if(WBE[1]) mem[A[31:2]][15:8] <= WD[15:8];
            if(WBE[2]) mem[A[31:2]][23:16] <= WD[23:16];
            if(WBE[3]) mem[A[31:2]][31:24] <= WD[31:24];
        end
    end

    assign RD = mem[A[31:2]];

endmodule