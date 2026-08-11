module register_file(
    # (parameter wr_addr = 5, //bit widths
                 wr_data = 32;
    );
    input logic[wr_addr - 1:0] r1, r2,
    input logic[wr_addr - 1:0] w1,
    input logic[wr_data - 1:0] data_wr,
    input logic wr_enable,
    input logic clk
    
);
endmodule