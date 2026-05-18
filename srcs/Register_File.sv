`timescale 1ns / 1ps
module Register_File(clk,rst,WE3,WD3,A1,A2,A3,RD1,RD2);

    input logic clk,rst,WE3;
    input logic [4:0]A1,A2,A3;
    input logic [31:0]WD3;
    output logic [31:0]RD1,RD2;

    logic [31:0] Register [31:0];
    always_ff @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            Register[0]  <= 32'd0;
            Register[1]  <= 32'd0;
            Register[2]  <= 32'd0;
            Register[3]  <= 32'd0;
            Register[4]  <= 32'd0;
            Register[5]  <= 32'd0;
            Register[6]  <= 32'd0;
            Register[7]  <= 32'd0;
            Register[8]  <= 32'd0;
            Register[9]  <= 32'd0;
            Register[10]  <= 32'd0;
            Register[11]  <= 32'd0;
            Register[12]  <= 32'd0;
            Register[13]  <= 32'd0;
            Register[14]  <= 32'd0;
            Register[15]  <= 32'd0;
            Register[16]  <= 32'd0;
            Register[17]  <= 32'd0;
            Register[18]  <= 32'd0;
            Register[19]  <= 32'd0;
            Register[20]  <= 32'd0;
            Register[21]  <= 32'd0;
            Register[22]  <= 32'd0;
            Register[23]  <= 32'd0;
            Register[24]  <= 32'd0;
            Register[25]  <= 32'd0;
            Register[26]  <= 32'd0;
            Register[27]  <= 32'd0;
            Register[28]  <= 32'd0;
            Register[29]  <= 32'd0;
            Register[30]  <= 32'd0;
            Register[31]  <= 32'd0;
        end
        else if (WE3 && (A3 != 5'h00)) begin
            Register[A3] <= WD3;
        end
    end

    assign RD1 = (WE3 && A3==A1 && A3!=0) ? WD3:
                  Register[A1];

    assign RD2 = (WE3 && A3==A2 && A3!=0) ? WD3:
                  Register[A2];
endmodule
