module instr_mem(
    input logic[31:0] PC,
    output logic[31:0] instr_word
);
    logic[31:0] instr_memory [63:0];
    logic[5:0] instr_addr;
    assign instr_addr = PC[7:2];
    assign instr_word = instr_memory[instr_addr];
endmodule