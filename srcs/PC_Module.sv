`timescale 1ns / 1ps
module PC_Module(clk,rst,PC,PC_Next,StallF);
    input logic clk,rst;
    input logic [31:0]PC_Next;
    input logic StallF;
    output logic [31:0]PC;

    always_ff @(posedge clk or negedge rst)
    begin
        if(rst==1'b0)
            PC <= {32{1'b0}};
        else if(~StallF)
            PC <= PC_Next;
    end
endmodule

