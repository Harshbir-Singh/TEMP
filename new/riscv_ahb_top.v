module riscv_ahb_top (
    input clk,
    input rst
);

    wire [31:0] d_HADDR;
    wire [1:0]  d_HTRANS;
    wire d_HWRITE;
    wire [2:0] d_HSIZE;
    wire [2:0] d_HBURST;
    wire [3:0] d_HPROT;
    wire [31:0] d_HWDATA;
    wire [31:0] d_HRDATA;
    wire d_HREADY;
    wire d_HRESP;
    
    wire [31:0] i_HADDR;
    wire [31:0] i_HWDATA;
    wire [31:0] i_HRDATA;
    wire [1:0]  i_HTRANS;
    wire i_HWRITE;
    wire i_HREADY;
    wire i_HRESP;
    wire [2:0] i_HSIZE; 
    wire [2:0] i_HBURST;
    wire [3:0] i_HPROT;

    riscv core (
        .clk(clk),
        .rst(rst),
        
        .Valid_W(),
        .PCW(),
        .InstrW(),
        .RegWriteW(),
        .RdW(),
        .ResultW(),
        .MemWriteW(),
        .ALUResultW(),
        .WriteDataW(),
         //Data Memory
        .d_HADDR(d_HADDR),
        .d_HTRANS(d_HTRANS),
        .d_HWRITE(d_HWRITE),
        .d_HSIZE(d_HSIZE),
        .d_HBURST(d_HBURST),
        .d_HPROT(d_HPROT),
        .d_HWDATA(d_HWDATA),
        .d_HRDATA(d_HRDATA),
        .d_HREADY(d_HREADY),
        .d_HRESP(d_HRESP),

         //Instruction Memory
        .i_HADDR(i_HADDR), 
        .i_HTRANS(i_HTRANS), 
        .i_HWRITE(i_HWRITE),
        .i_HSIZE(i_HSIZE), 
        .i_HBURST(i_HBURST), 
        .i_HPROT(i_HPROT),
        .i_HWDATA(i_HWDATA), 
        .i_HRDATA(i_HRDATA),
        .i_HREADY(i_HREADY), 
        .i_HRESP(i_HRESP)

    );
    
    ahb_instruction_memory imem (
        .HCLK(clk),
        .HRESETn(~rst),
        .HADDR(i_HADDR),
        .HTRANS(i_HTRANS),
        .HWRITE(i_HWRITE),
        .HSIZE(i_HSIZE),
        .HRDATA(i_HRDATA),
        .HREADY(i_HREADY),
        .HRESP(i_HRESP)
    );
    ahb_data_memory dmem (
        .HCLK(clk),
        .HRESETn(~rst),
        .HADDR(d_HADDR),
        .HTRANS(d_HTRANS),
        .HWRITE(d_HWRITE),
        .HSIZE(d_HSIZE),
        .HWDATA(d_HWDATA),
        .HRDATA(d_HRDATA),
        .HREADY(d_HREADY),
        .HRESP(d_HRESP)
    );

endmodule