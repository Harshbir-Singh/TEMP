`timescale 1ns / 1ps

module CSR_File(
    input logic clk,
    input logic rst,
    
    input logic [11:0] csr_raddr,
    
    input logic [11:0] csr_waddr,
    input logic [31:0] csr_wdata,
    input logic csr_wen,
    input logic csr_wen_ex,     
    input logic [11:0] csr_waddr_ex,     
    input logic [31:0] csr_wdata_ex,
    
    input logic [31:0] pc_mepc,
    input logic trap,
    input logic [31:0] mcause_in,
     
    output logic [31:0] csr_rdata,
    output logic [31:0] mtvec_out,
    output logic [31:0] mepc_out,
    output logic [31:0] mstatus_out,
    output logic [31:0] mie_out,
    output logic [31:0] mip_out
);

    logic [31:0] mstatus;  // 0x300
    logic [31:0] mie;      // 0x304
    logic [31:0] mtvec;    // 0x305
    logic [31:0] mscratch; // 0x340
    logic [31:0] mepc;     // 0x341
    logic [31:0] mcause;   // 0x342
    logic [31:0] mip;      // 0x344
    
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            mstatus  <= 32'h0;
            mie <= 32'h0;
            mtvec <= 32'h0;
            mscratch <= 32'h0;
            mepc <= 32'h0;
            mcause <= 32'h0;
            mip <= 32'h0;
        end else begin
            if (trap) begin
               
                mepc <= pc_mepc;
                mcause <= mcause_in;
                mstatus <= {mstatus[31:4], 1'b0, mstatus[2:0]};
            end else if (csr_wen) begin
               
                case (csr_waddr)
                    12'h300: mstatus <= csr_wdata;
                    12'h304: mie <= csr_wdata;
                    12'h305: mtvec <= csr_wdata;
                    12'h340: mscratch <= csr_wdata;
                    12'h341: mepc <= csr_wdata;
                    12'h342: mcause <= csr_wdata;
                    12'h344: mip <= csr_wdata;
                    default: ;
                endcase
            end
        end
    end

  
    always_comb begin
    if (csr_wen_ex && (csr_waddr_ex == csr_raddr))
        csr_rdata = csr_wdata_ex;   
    else if (csr_wen && (csr_waddr == csr_raddr))
        csr_rdata = csr_wdata;      
    else begin
        case (csr_raddr)
            12'h300: csr_rdata = mstatus;
            12'h304: csr_rdata = mie;
            12'h305: csr_rdata = mtvec;
            12'h340: csr_rdata = mscratch;
            12'h341: csr_rdata = mepc;
            12'h342: csr_rdata = mcause;
            12'h344: csr_rdata = mip;
            12'hF14: csr_rdata = 32'h0;
            default: csr_rdata = 32'h0;
        endcase
      end
    end

    
    assign mtvec_out = mtvec;
    assign mepc_out = mepc;
    assign mstatus_out = mstatus;
    assign mie_out = mie;
    assign mip_out = mip;

endmodule