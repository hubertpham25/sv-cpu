module pc(
    input logic clk,
    input logic[31:0] next_pc,
    output logic[31:0] curr_pc
);
    always_ff @(posedge clk) begin: move_instr
        curr_pc <= next_pc;
    end: move_instr
endmodule