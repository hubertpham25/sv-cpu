module instr_mem(
    input logic[31:0] PC,
    output logic[31:0] instr_word
);
    logic[31:0] instr_memory [63:0];
    logic[5:0] instr_addr;
    assign instr_addr = PC[7:2];
    assign instr_word = instr_memory[instr_addr];
    //temp inits
    initial begin
        instr_memory[0] = {7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011};
        instr_memory[1] = {7'b0100000, 5'd2, 5'd1, 3'b000, 5'd4, 7'b0110011};
        instr_memory[2] = {12'd10, 5'd1, 3'b000, 5'd5, 7'b0010011};
    end
endmodule