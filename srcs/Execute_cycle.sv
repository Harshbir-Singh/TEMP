`timescale 1ns / 1ps

module Execute_cycle(
    input logic clk, rst,
    
    input logic [1:0]  ForwardAE, ForwardBE,
    
    input logic [31:0] RD1E, RD2E, PCE, Imm_Ext_E, PCPlus4E, ResultW,
    input logic [4:0]  RdE,
    input logic [2:0]  funct3E,
    input logic  [6:0]  Jal_opE,
    
    input logic CSR_wenE, use_immE, mretE,
    input logic [1:0]  csr_opE,
    input logic [31:0] csr_rdataE,
    input logic [11:0] csr_addrE,
    input logic [4:0]  rs1_addrE,
    
    input logic RegWriteE, MemWriteE, BranchE, ALUSrcE, JumpE,
    input logic [2:0]  ResultSrcE,
    input logic [3:0]  ALUControlE,
   
    output logic RegWriteM, MemWriteM, PCSrcE,
    output logic [2:0]  ResultSrcM,
    output logic [31:0] ALUResultM, WriteDataM, PCPlus4M,
    output logic [4:0]  RdM,
    output logic [2:0]  funct3M,
    output logic [31:0] PCTargetE, Upper_instM,
   
    output logic CSR_wenM,
    output logic mretM,           
    output logic [1:0] csr_opM,
    output logic [31:0] csr_wdataM, csr_rdataM,
    output logic [11:0] csr_addrM,
    
    output logic [31:0] csr_wdata_fwd   

);

   
    logic [31:0] SrcBE, ALUResultE, SrcAE, WriteData_interim;
    logic ZeroE, BranchOut, SignE, OverflowE, CarryE;
    logic [31:0] PCTargetE_JB, Upper_instE;
    logic [31:0] zimm, csr_operand, csr_wdata_E;

  
    logic RegWriteE_r, MemWriteE_r;
    logic [2:0] ResultSrcE_r;
    logic [31:0] ALUResultE_r, WriteDataE_r, PCPlus4E_r, Upper_instE_r;
    logic [4:0] RdE_r;
    logic [2:0] funct3E_r;
   
    logic CSR_wenE_r;
    logic mretE_r;            
    logic [1:0]  csr_opE_r;
    logic [31:0] csr_wdataE_r, csr_rdataE_r;
    logic [11:0] csr_addrE_r;

    
    PC_Adder Adder(
        .a(PCE),
        .b(Imm_Ext_E),
        .c(PCTargetE_JB)
    );
    assign csr_wdata_fwd = csr_wdata_E;
    
    assign PCTargetE = (Jal_opE == 7'b1100111) ? {ALUResultE[31:1], 1'b0}
                                                 : PCTargetE_JB;

    
    assign Upper_instE = (Jal_opE == 7'b0110111) ? Imm_Ext_E      // LUI
                       : (Jal_opE == 7'b0010111) ? PCTargetE_JB   // AUIPC
                       : 32'h0;

    
    Mux_3x1 A_operand(
        .a(RD1E), .b(ResultW), .c(ALUResultM),
        .s(ForwardAE), .out(SrcAE)
    );

    Mux_3x1 B_operand(
        .a(RD2E), .b(ResultW), .c(ALUResultM),
        .s(ForwardBE), .out(WriteData_interim)
    );

    Mux MUX_E(
        .a(WriteData_interim), .b(Imm_Ext_E),
        .s(ALUSrcE), .c(SrcBE)
    );

    
    ALU alu(
        .A(SrcAE), .B(SrcBE),
        .Result(ALUResultE),
        .ALUControl(ALUControlE),
        .OverFlow(OverflowE), .Carry(CarryE),
        .Zero(ZeroE), .Negative(SignE)
    );

    
    assign BranchOut =
        (funct3E == 3'b000) ?  ZeroE              & BranchE :  // BEQ
        (funct3E == 3'b001) ? ~ZeroE              & BranchE :  // BNE
        (funct3E == 3'b100) ?  (SignE^OverflowE)  & BranchE :  // BLT
        (funct3E == 3'b101) ? ~(SignE^OverflowE)  & BranchE :  // BGE
        (funct3E == 3'b110) ? ~CarryE             & BranchE :  // BLTU
        (funct3E == 3'b111) ?  CarryE             & BranchE :  // BGEU
                               1'b0;

    assign PCSrcE = BranchOut | JumpE;

    
    assign zimm        = {27'b0, rs1_addrE};             
    assign csr_operand = use_immE ? zimm : SrcAE;        
    assign csr_wdata_E =
        (csr_opE == 2'b00) ?  csr_operand :               
        (csr_opE == 2'b01) ?  csr_rdataE | csr_operand :  
        (csr_opE == 2'b10) ?  csr_rdataE & ~csr_operand : 
                              csr_operand;

    
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            RegWriteE_r <= 0;
            ResultSrcE_r <= 3'b000;
            MemWriteE_r <= 0;
            ALUResultE_r <= 32'd0;
            WriteDataE_r <= 32'd0;
            PCPlus4E_r <= 32'd0;
            RdE_r <= 5'b0;
            funct3E_r <= 3'b0;
            Upper_instE_r<= 32'd0;
            CSR_wenE_r <= 1'b0;
            mretE_r <= 1'b0;  
            csr_opE_r <= 2'b00;
            csr_wdataE_r <= 32'd0;
            csr_rdataE_r <= 32'd0;
            csr_addrE_r <= 12'd0;
        end else begin
            RegWriteE_r <= RegWriteE;
            ResultSrcE_r <= ResultSrcE;
            MemWriteE_r <= MemWriteE;
            ALUResultE_r <= ALUResultE;
            WriteDataE_r <= WriteData_interim;
            PCPlus4E_r <= PCPlus4E;
            RdE_r <= RdE;
            funct3E_r <= funct3E;
            Upper_instE_r <= Upper_instE;
            CSR_wenE_r <= CSR_wenE;
            mretE_r <= mretE;  
            csr_opE_r <= csr_opE;
            csr_wdataE_r <= csr_wdata_E;   
            csr_rdataE_r <= csr_rdataE;    
            csr_addrE_r  <= csr_addrE;
        end
    end

   
    assign RegWriteM  = RegWriteE_r;
    assign ResultSrcM = ResultSrcE_r;
    assign MemWriteM  = MemWriteE_r;
    assign ALUResultM = ALUResultE_r;
    assign WriteDataM = WriteDataE_r;
    assign RdM = RdE_r;
    assign PCPlus4M = PCPlus4E_r;
    assign funct3M = funct3E_r;
    assign Upper_instM = Upper_instE_r;
    assign CSR_wenM = CSR_wenE_r;
    assign mretM = mretE_r;        
    assign csr_opM = csr_opE_r;
    assign csr_wdataM = csr_wdataE_r;
    assign csr_rdataM = csr_rdataE_r;
    assign csr_addrM  = csr_addrE_r;

endmodule