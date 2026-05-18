module CSR_Decoder(
    input logic is_csr,
    input logic [2:0] funct3,
    input logic [11:0] funct12,      
    input logic [4:0] rs1_addr,       
    output logic CSR_wen,
    output logic use_imm,
    output logic [1:0] csr_op,
    output logic mret,
    output logic illegal_instr
);
    always_comb begin
        CSR_wen = 0; use_imm = 0; csr_op = 2'b00;
        mret = 0; illegal_instr = 0;
        if(is_csr) begin
            case(funct3)
                3'b001: begin csr_op=2'b00; use_imm=0; CSR_wen=1'b1;          end // CSRRW
                3'b010: begin csr_op=2'b01; use_imm=0; CSR_wen=|rs1_addr;     end // CSRRS csr_we = |rs1 for preventing writing in CSR from x0 mainly for Set and Clear only
                3'b011: begin csr_op=2'b10; use_imm=0; CSR_wen=|rs1_addr;     end // CSRRC
                3'b101: begin csr_op=2'b00; use_imm=1; CSR_wen=1'b1;          end // CSRRWI
                3'b110: begin csr_op=2'b01; use_imm=1; CSR_wen=|rs1_addr;     end // CSRRSI
                3'b111: begin csr_op=2'b10; use_imm=1; CSR_wen=|rs1_addr;     end // CSRRCI
                3'b000: begin // MRET or EBREAK
                    mret = (funct12 == 12'h302); //Distinguish between EBREAK and MRET
                    CSR_wen = 1'b0; use_imm = 1'b0;
                end
                default: illegal_instr = 1'b1;
            endcase
        end
    end
endmodule