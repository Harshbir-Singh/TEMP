`timescale 1ns / 1ps
module fetch_cycle(clk, rst, InstrD, PCD, PCPlus4D,PCSrcE, PCTargetE, mepc_toPC, mretE,StallF, StallD, FlushD);

  input logic clk, rst, PCSrcE, StallF, StallD, FlushD;
  input logic mretE;                    
  input logic[31:0] PCTargetE;
  input logic [31:0] mepc_toPC;         
  output logic [31:0] PCD, InstrD, PCPlus4D;

  logic [31:0] PC_F, PCF, PCPlus4F, InstrF;
  logic [31:0] InstrF_reg, PCF_reg, PCPlus4F_reg;

  assign PC_F = mretE ? mepc_toPC:  //CSR
                PCSrcE ? PCTargetE: //JUMP/BRANCH
                          PCPlus4F;

  PC_Module Program_Counter(
    .clk(clk),
    .rst(rst),
    .PC(PCF),
    .PC_Next(PC_F),
    .StallF(StallF)
  );

  PC_Adder Adder(
    .a(PCF),
    .b(32'd4),
    .c(PCPlus4F)
  );

  Instruction_Memory IMEM(
    .A(PCF),
    .RD(InstrF)
  );

  always_ff @(posedge clk or negedge rst) begin
    if (rst == 1'b0) 
      begin
        InstrF_reg <= 32'h00000013; 
        PCF_reg <= 32'd0;
        PCPlus4F_reg <= 32'd0;
      end
    else if (FlushD) 
      begin
        InstrF_reg   <= 32'h00000013; 
        PCF_reg      <= 32'd0;
        PCPlus4F_reg <= 32'd0;
      end
    else if (~StallD) 
      begin
        InstrF_reg <= InstrF;
        PCF_reg <= PCF;
        PCPlus4F_reg <= PCPlus4F;
      end
  end

  assign InstrD = InstrF_reg;
  assign PCD = PCF_reg;
  assign PCPlus4D = PCPlus4F_reg;

endmodule