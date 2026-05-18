`timescale 1ns / 1ps

module Main_Decoder(
    input logic [6:0] Op,
    input logic [11:0] funct12,         
    output logic RegWrite,
    output logic ALUSrc,
    output logic MemWrite,
    output logic Branch,
    output logic Jump,
    output logic [2:0] ResultSrc,
    output logic [2:0] ALUOp,
    output logic [2:0] ImmSrc,
    output logic is_csr
);

    logic is_mret;
    assign is_mret = (funct12 == 12'h302);

    always_comb begin
        case (Op)
           
            7'b0000011: begin  // Load
                RegWrite = 1; ImmSrc = 3'b000; ALUSrc = 1;
                MemWrite = 0; ResultSrc = 3'b001; Branch = 0;
                ALUOp = 3'b011; Jump = 0; is_csr = 0;
            end
            
            7'b0110011: begin  // R-type
                RegWrite = 1; ImmSrc = 3'b000; ALUSrc = 0;
                MemWrite = 0; ResultSrc = 3'b000; Branch = 0;
                ALUOp = 3'b010; Jump = 0; is_csr = 0;
            end
           
            7'b0010011: begin  // I-type ALU
                RegWrite = 1; ImmSrc = 3'b000; ALUSrc = 1;
                MemWrite = 0; ResultSrc = 3'b000; Branch = 0;
                ALUOp = 3'b000; Jump = 0; is_csr = 0;
            end
            
            7'b1101111: begin  // JAL
                RegWrite = 1; ImmSrc = 3'b011; ALUSrc = 0;
                MemWrite = 0; ResultSrc = 3'b010; Branch = 0;
                ALUOp = 3'b000; Jump = 1; is_csr = 0;
            end
            
            7'b1100111: begin  // JALR
                RegWrite = 1; ImmSrc = 3'b000; ALUSrc = 1;
                MemWrite = 0; ResultSrc = 3'b010; Branch = 0;
                ALUOp = 3'b000; Jump = 1; is_csr = 0;
            end
           
            7'b0110111: begin  // LUI
                RegWrite = 1; ImmSrc = 3'b100; ALUSrc = 1;
                MemWrite = 0; ResultSrc = 3'b011; Branch = 0;
                ALUOp = 3'b000; Jump = 0; is_csr = 0;
            end
            
            7'b0010111: begin  // AUIPC
                RegWrite = 1; ImmSrc = 3'b100; ALUSrc = 1;
                MemWrite = 0; ResultSrc = 3'b011; Branch = 0;
                ALUOp = 3'b000; Jump = 0; is_csr = 0;
            end
            
            7'b0100011: begin  // Store
                RegWrite = 0; ImmSrc = 3'b001; ALUSrc = 1;
                MemWrite = 1; ResultSrc = 3'b000; Branch = 0;
                ALUOp = 3'b011; Jump = 0; is_csr = 0;
            end
            
            7'b1100011: begin  // Branch
                RegWrite = 0; ImmSrc = 3'b010; ALUSrc = 0;
                MemWrite = 0; ResultSrc = 3'b000; Branch = 1;
                ALUOp = 3'b001; Jump = 0; is_csr = 0;
            end
            
            7'b1110011: begin  
               
                RegWrite = is_mret ? 1'b0 : 1'b1;
                ResultSrc = is_mret ? 3'b000 : 3'b100;
                is_csr = is_mret ? 1'b0  : 1'b1;
                ImmSrc = 3'b000;
                ALUSrc = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOp = 3'b100;
                Jump = 1'b0;
            end
           
            default: begin
                RegWrite = 0; ImmSrc = 3'b000; ALUSrc = 0;
                MemWrite = 0; ResultSrc = 3'b000; Branch = 0;
                ALUOp = 3'b000; Jump = 0; is_csr = 0;
            end
        endcase
    end

endmodule