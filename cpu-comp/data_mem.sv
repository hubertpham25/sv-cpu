module data_mem(
    input logic[5:0] addr,
    input logic[31:0] wr_data,
    input logic clk,
    input logic mem_rd,
    input logic mem_wr,
    output logic[31:0] result
);
    logic[31:0] data_mem [63:0];
    always_ff @(posedge clk) begin: data_wr
        if (mem_wr == 1) begin
            data_mem[addr] <= wr_data;
        end
    end: data_wr
    assign result = data_mem[addr];

endmodule