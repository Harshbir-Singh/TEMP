`timescale 1ns / 1ps
module Instruction_Memory(A,RD);
  input logic [31:0]A;
  output logic [31:0]RD;

  logic [31:0] mem [1023:0];
  
  assign RD = mem[A[31:2]];

  initial begin
    $readmemh("memfile.hex",mem);
  end
endmodule
