`timescale 1ns / 1ps
module Writeback_cycle(ReadDataW, ALUResultW, PCPlus4W, ResultSrcW, ResultW,Upper_instW,csr_rdataW);
  input logic [31:0] ReadDataW, ALUResultW, PCPlus4W,Upper_instW;
  input logic [2:0] ResultSrcW;
  input logic [31:0] csr_rdataW;    
  output logic [31:0] ResultW; 
  
  Mux_8x1 Mux_WriteBack(
      .a(ALUResultW),
      .b(ReadDataW),
      .c(PCPlus4W),
      .d(Upper_instW),
      .e(csr_rdataW),
      .s(ResultSrcW),
      .out(ResultW)
  );
       
endmodule
