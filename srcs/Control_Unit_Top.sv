`timescale 1ns / 1ps

module Control_Unit_Top(
    input logic [6:0]  Op, funct7,
    input logic  [2:0]  funct3,
    input logic  [11:0] funct12,
    input logic  [4:0]  rs1_addr,
    output logic RegWrite, ALUSrc, MemWrite, Branch, Jump,
    output logic [2:0]  ResultSrc, ImmSrc,
    output logic [3:0]  ALUControl,
    output logic CSR_wen, use_imm, mret, illegal_instr,
    output logic [1:0]  csr_op
);

    logic [2:0] ALUOp;
    logic is_csr;

    Main_Decoder Main_Decoder(
        .Op(Op),
        .funct12(funct12),          
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp),
        .Jump(Jump),
        .is_csr(is_csr)
    );

    ALU_Decoder ALU_Decoder(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .op(Op),
        .ALUControl(ALUControl)
    );

    CSR_Decoder CSR_Decoder(
        .is_csr(is_csr),
        .funct3(funct3),
        .funct12(funct12),
        .rs1_addr(rs1_addr),
        .CSR_wen(CSR_wen),
        .use_imm(use_imm),
        .csr_op(csr_op),
        .mret(mret),
        .illegal_instr(illegal_instr)
    );

endmodule