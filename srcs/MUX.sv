module Mux (
  input logic [31:0]a,
  input logic [31:0]b,
  input logic s,
  output logic [31:0]c
  );
  assign c = (~s) ? a : b ;
    
endmodule

module Mux_3x1(a,b,c,s,out);
  input logic [31:0] a,b,c;
  input logic [1:0] s;
  output logic [31:0] out;
  assign out = (s == 2'b00)?a:
               (s == 2'b01)?b:
               (s == 2'b10)?c:
               32'd0;
endmodule

module Mux_8x1(a,b,c,d,e,s,out);
  input logic [31:0] a,b,c,d,e;
  input logic [2:0] s;
  output logic [31:0] out;
  assign out = (s == 3'b000)?a:
               (s == 3'b001)?b:
               (s == 3'b010)?c:
               (s == 3'b011)?d:
               (s == 3'b100)?e:
               32'd0;
endmodule