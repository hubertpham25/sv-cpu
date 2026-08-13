module registerf_tb;
    logic clk;
    logic wr_enable;
    logic [4:0] r1, r2;
    logic [4:0] w1;
    logic [31:0] wr_data;
    logic [31:0] out_r1, out_r2;

    REG_FILE dut(
        .clk(clk),
        .wr_enable(wr_enable),
        .r1(r1), .r2(r2),
        .w1(w1),
        .wr_data(wr_data),
        .out_r1(out_r1), .out_r2(out_r2)
    );

    

endmodule