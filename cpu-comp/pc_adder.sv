module PC_ADDER(
    input logic[31:0] curr_pc,
    input logic[31:0] imm,
    input logic branch,
    input logic zero_fg,
    output logic[31:0] next_pc
);
    logic[31:0] branch_pc;
    logic[31:0] add_pc;
    assign branch_pc = curr_pc + imm;
    assign add_pc = curr_pc + 4;
    always_comb begin
        if (branch == 1 && zero_fg == 1) begin
            next_pc = branch_pc;
        end
        else begin
            next_pc = add_pc;
        end
    end
endmodule