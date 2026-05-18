`timescale 1ns / 1ps
module RISC_V(clk, rst);
    input logic clk, rst;
    logic [31:0] InstrD, PCD, PCPlus4D;
    logic [31:0] RD1_E, RD2_E, PCE, PCPlus4E, Imm_Ext_E;
    logic [4:0]  RD_E, RS1_E, RS2_E;
    logic [2:0]  funct3E, ResultSrcE;
    logic [6:0]  Jal_opE;
    logic RegWriteE, ALUSrcE, MemWriteE, BranchE, JumpE;
    logic [3:0]  ALUControlE;
    logic CSR_wenE, use_immE, mretE, illegal_instrE;
    logic [1:0]  csr_opE;
    logic [11:0] csr_addrE;
    logic [31:0] csr_rdataD;   
    logic [31:0] csr_rdataE;   

    
    logic [31:0] ALUResultM, WriteDataM, PCPlus4M, Upper_instM;
    logic [4:0]  RdM;
    logic [2:0]  funct3M, ResultSrcM;
    logic RegWriteM, MemWriteM, PCSrcE;
    logic [31:0] PCTargetE;
    logic CSR_wenM, mretM;           
    logic [1:0]  csr_opM;
    logic [31:0] csr_wdataM, csr_rdataM;
    logic [11:0] csr_addrM;
    logic [31:0] csr_wdata_fwd;
   
    logic [31:0] ReadDataW, ALUResultW, PCPlus4W, Upper_instW;
    logic [4:0]  RdW;
    logic [2:0]  ResultSrcW;
    logic RegWriteW;
    logic [31:0] csr_rdataW;
    logic [11:0] csr_addrW;   

  
    logic [31:0] ResultW;

    logic [1:0]  ForwardAE, ForwardBE;
    logic StallF, StallD, FlushE, FlushD;

   
    logic [31:0] mtvec_toPC, mepc_toPC;
    logic [31:0] mstatus_out, mie_out, mip_out;

    fetch_cycle Fetch(
        .clk(clk),
        .rst(rst),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .mepc_toPC(mepc_toPC),
        .mretE(mretM),          
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD)
    );

    Decode_Cycle Decode(
        .clk(clk),
        .rst(rst),
        .InstrD(InstrD),
        .RegWriteW(RegWriteW),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .ResultW(ResultW),
        .RdW(RdW),
        .RegWriteE(RegWriteE),
        .ALUSrcE(ALUSrcE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .BranchE(BranchE),
        .JumpE(JumpE),
        .ALUControlE(ALUControlE),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .Imm_Ext_E(Imm_Ext_E),
        .RD_E(RD_E),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E),
        .RS1_E(RS1_E),
        .RS2_E(RS2_E),
        .FlushE(FlushE),
        .funct3E(funct3E),
        .Jal_opE(Jal_opE),
        .CSR_wenE(CSR_wenE),
        .use_immE(use_immE),
        .mretE(mretE),
        .illegal_instrE(illegal_instrE),
        .csr_opE(csr_opE),
        .csr_addrE(csr_addrE),
        .csr_rdataD(csr_rdataD),
        .csr_rdataE(csr_rdataE)
    );

    Execute_cycle Execute(
        .clk(clk),
        .rst(rst),
        .RD1E(RD1_E),
        .RD2E(RD2_E),
        .PCE(PCE),
        .RdE(RD_E),
        .Imm_Ext_E(Imm_Ext_E),
        .PCPlus4E(PCPlus4E),
        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .MemWriteE(MemWriteE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .ALUSrcE(ALUSrcE),
        .PCTargetE(PCTargetE),
        .JumpE(JumpE),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .MemWriteM(MemWriteM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .RdM(RdM),
        .PCPlus4M(PCPlus4M),
        .PCSrcE(PCSrcE),
        .ResultW(ResultW),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .funct3E(funct3E),
        .funct3M(funct3M),
        .Jal_opE(Jal_opE),
        .Upper_instM(Upper_instM),
        .CSR_wenE(CSR_wenE),
        .use_immE(use_immE),
        .mretE(mretE),
        .csr_opE(csr_opE),
        .csr_rdataE(csr_rdataE),
        .rs1_addrE(RS1_E),
        .csr_addrE(csr_addrE),
        .CSR_wenM(CSR_wenM),
        .mretM(mretM),          
        .csr_opM(csr_opM),
        .csr_wdataM(csr_wdataM),
        .csr_rdataM(csr_rdataM),
        .csr_addrM(csr_addrM),
        .csr_wdata_fwd(csr_wdata_fwd)
    );

    Memory_cycle Memory(
        .clk(clk),
        .rst(rst),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .MemWriteM(MemWriteM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .PCPlus4M(PCPlus4M),
        .RdM(RdM),
        .ReadDataW(ReadDataW),
        .ALUResultW(ALUResultW),
        .PCPlus4W(PCPlus4W),
        .RdW(RdW),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .funct3M(funct3M),
        .ByteOffsetM(ALUResultM[1:0]),
        .Upper_instM(Upper_instM),
        .Upper_instW(Upper_instW),
        .CSR_wenM(CSR_wenM),
        .csr_opM(csr_opM),
        .csr_wdataM(csr_wdataM),
        .csr_rdataM(csr_rdataM),
        .csr_addrM(csr_addrM),
        .csr_rdataW(csr_rdataW),
        .csr_addrW(csr_addrW)   
    );

    Writeback_cycle Writeback(
        .ReadDataW(ReadDataW),
        .ALUResultW(ALUResultW),
        .PCPlus4W(PCPlus4W),
        .ResultSrcW(ResultSrcW),
        .ResultW(ResultW),
        .Upper_instW(Upper_instW),
        .csr_rdataW(csr_rdataW)
    );

    Hazard_Unit Hazard(
        .RdM(RdM),
        .RdW(RdW),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .RS1_E(RS1_E),
        .RS2_E(RS2_E),
        .ResultSrcE(ResultSrcE),
        .RdE(RD_E),
        .RS1_D(InstrD[19:15]),
        .RS2_D(InstrD[24:20]),
        .FlushE(FlushE),
        .StallD(StallD),
        .StallF(StallF),
        .PCSrcE(PCSrcE),
        .FlushD(FlushD),
        .mretM(mretM)
    );

    
    CSR_File CSR(
        .clk(clk),
        .rst(rst),
        .csr_raddr(InstrD[31:20]),  
        .csr_waddr(csr_addrM),      
        .csr_wdata(csr_wdataM),
        .csr_wen(CSR_wenM),
        .pc_mepc(PCPlus4M),         
        .trap(1'b0),
        .mcause_in(32'd0),
        .csr_rdata(csr_rdataD),
        .mtvec_out(mtvec_toPC),
        .mepc_out(mepc_toPC),
        .mstatus_out(mstatus_out),
        .mie_out(mie_out),
        .mip_out(mip_out),
        .csr_wen_ex(CSR_wenE),         
        .csr_waddr_ex(csr_addrE),       
        .csr_wdata_ex(csr_wdata_fwd)
    );
always_ff @(posedge clk) begin
    $display("T=%0t | InstrD=%h | CSR_wenM=%b | csr_addrM=%h | csr_wdataM=%h | csr_rdataD=%h | mretE=%b | mretM=%b | FlushE=%b | FlushD=%b | PCSrcE=%b",
    $time, InstrD, CSR_wenM, csr_addrM, csr_wdataM, csr_rdataD, mretE, mretM, FlushE, FlushD, PCSrcE);
end
endmodule