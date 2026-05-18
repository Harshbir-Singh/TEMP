`timescale 1ns / 1ps
module Decode_Cycle(clk, rst, InstrD, RegWriteW, PCD, PCPlus4D, ResultW, RdW, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE,JumpE,
    BranchE, ALUControlE, RD1_E, RD2_E, Imm_Ext_E, RD_E, PCE, PCPlus4E, RS1_E, RS2_E, FlushE, funct3E,Jal_opE,
    CSR_wenE, use_immE, mretE, illegal_instrE, csr_opE,csr_addrE, csr_rdataD, csr_rdataE );
  input logic clk, rst, RegWriteW,FlushE;
  input logic [31:0] InstrD, PCD, PCPlus4D, ResultW;
  input logic [4:0] RdW ; 
  input logic [31:0] csr_rdataD; 
  
  output logic RegWriteE,ALUSrcE,MemWriteE,BranchE,JumpE;
  output logic [2:0] ResultSrcE;
  output logic [3:0] ALUControlE;
  output logic [31:0] RD1_E, RD2_E, Imm_Ext_E;
  output logic [4:0] RS1_E, RS2_E, RD_E;
  output logic [2:0] funct3E;
  output logic [6:0] Jal_opE;
  output logic [31:0] PCE, PCPlus4E;
  output logic CSR_wenE, use_immE, mretE, illegal_instrE;
  output logic [1:0] csr_opE;
  output logic [11:0] csr_addrE;
  output logic [31:0] csr_rdataE;
  
  //control unit
  logic RegWriteD,ALUSrcD,MemWriteD,BranchD,JumpD;
  logic [2:0] ResultSrcD;
  logic [2:0] ImmSrcD;
  logic [3:0] ALUControlD;
  
  //CSR
  logic CSR_wenD, use_immD, mretD, illegal_instrD;
  logic [1:0] csr_opD;
  
  
  // register file
  logic [31:0] RD1_D, RD2_D;
  
  //Sign Extend
  logic [31:0] Imm_Ext_D;
  
  //Registers
  logic [31:0] PCD_r, PCPlus4D_r, RD1_D_r, RD2_D_r, Imm_Ext_D_r;
  logic RegWriteD_r,ALUSrcD_r,MemWriteD_r,BranchD_r, JumpD_r;
  logic [2:0] ResultSrcD_r;
  logic [3:0] ALUControlD_r;
  logic [4:0] Rd_D_r,RS1_D_r,RS2_D_r;
  logic [2:0] funct3_D_r;
  logic [6:0] Jal_opD_r;
  logic CSR_wenD_r, use_immD_r, mretD_r, illegal_instrD_r;
  logic [1:0] csr_opD_r;
  logic [11:0] csr_addrD_r;
  logic [31:0] csr_rdataD_r;
  
  Control_Unit_Top CU(
    .Op(InstrD[6:0]),
    .RegWrite(RegWriteD),
    .ImmSrc(ImmSrcD),
    .ALUSrc(ALUSrcD),
    .MemWrite(MemWriteD),
    .ResultSrc(ResultSrcD),
    .Branch(BranchD),
    .funct3(InstrD[14:12]),
    .funct7(InstrD[31:25]),
    .ALUControl(ALUControlD),
    .Jump(JumpD),
    .CSR_wen(CSR_wenD), 
    .use_imm(use_immD), 
    .mret(mretD), 
    .illegal_instr(illegal_instrD), 
    .csr_op(csr_opD),
    .funct12(InstrD[31:20]),
    .rs1_addr(InstrD[19:15])
  );
  
  Register_File RF(
    .clk(clk),
    .rst(rst),
    .WE3(RegWriteW),
    .WD3(ResultW),
    .A1(InstrD[19:15]),
    .A2(InstrD[24:20]),
    .A3(RdW),
    .RD1(RD1_D),
    .RD2(RD2_D)
  );
  
  Sign_Extend SE(
    .In(InstrD[31:0]),
    .Imm_Ext(Imm_Ext_D),
    .ImmSrc(ImmSrcD),
    .funct3(InstrD[14:12])
  );
  
  always_ff @(posedge clk or negedge rst)
    begin
      if((rst == 1'b0)||FlushE)
        begin
          PCD_r <= 32'd0; 
          PCPlus4D_r <= 32'd0;
          RD1_D_r <= 32'd0;
          RD2_D_r <= 32'd0; 
          Imm_Ext_D_r <= 32'd0;
          RegWriteD_r <= 0;
          ALUSrcD_r <= 0; 
          MemWriteD_r <= 0;
          BranchD_r <= 0;
          Rd_D_r <= 5'b00000;
          ResultSrcD_r <= 3'b000;
          ALUControlD_r<=4'b0000;
          RS1_D_r<=0;
          RS2_D_r<=0;
          JumpD_r<=0;
          funct3_D_r<=3'b000;
          Jal_opD_r<=7'b0000000;
          CSR_wenD_r <= 1'b0;
          use_immD_r <= 1'b0;
          mretD_r <= 1'b0;
          illegal_instrD_r <= 1'b0;
          csr_opD_r <= 2'b00;
          csr_addrD_r <= 12'h000;
          csr_rdataD_r <= 32'd0;
        end
      else
        begin
          PCD_r <= PCD; 
          PCPlus4D_r <= PCPlus4D ;
          RD1_D_r <= RD1_D;
          RD2_D_r <= RD2_D; 
          Imm_Ext_D_r <= Imm_Ext_D;
          RegWriteD_r <= RegWriteD;
          ALUSrcD_r <= ALUSrcD; 
          MemWriteD_r <= MemWriteD;
          BranchD_r <= BranchD;
          Rd_D_r <= InstrD[11:7];
          ResultSrcD_r <= ResultSrcD;
          ALUControlD_r<=ALUControlD;
          RS1_D_r <= InstrD[19:15];
          RS2_D_r <= InstrD[24:20];
          funct3_D_r <= InstrD[14:12];
          JumpD_r <= JumpD;
          Jal_opD_r <= InstrD[6:0];
          CSR_wenD_r <= CSR_wenD;
          use_immD_r <= use_immD;
          mretD_r <= mretD;
          illegal_instrD_r <= illegal_instrD;
          csr_opD_r <= csr_opD;
          csr_addrD_r <=InstrD[31:20];
          csr_rdataD_r <= csr_rdataD;
        end
    end
    
    assign PCE = PCD_r; 
    assign PCPlus4E = PCPlus4D_r ;
    assign RD1_E = RD1_D_r;
    assign RD2_E = RD2_D_r; 
    assign Imm_Ext_E = Imm_Ext_D_r;
    assign RegWriteE = RegWriteD_r;
    assign ALUSrcE = ALUSrcD_r; 
    assign MemWriteE = MemWriteD_r;
    assign BranchE = BranchD_r;
    assign JumpE = JumpD_r;
    assign RD_E = Rd_D_r;
    assign ResultSrcE = ResultSrcD_r;
    assign ALUControlE = ALUControlD_r;
    assign RS1_E = RS1_D_r;
    assign RS2_E = RS2_D_r;
    assign funct3E = funct3_D_r;
    assign Jal_opE = Jal_opD_r;
    assign CSR_wenE = CSR_wenD_r;
    assign use_immE = use_immD_r;
    assign mretE = mretD_r;
    assign illegal_instrE = illegal_instrD_r;
    assign csr_opE  = csr_opD_r;
    assign csr_addrE = csr_addrD_r;
    assign csr_rdataE = csr_rdataD_r;
    
endmodule
