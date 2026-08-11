import packages::*;
module ALU_tb;
    packages::instructions_t instr;
    logic[31:0] result;
    logic zero_fg;

    ALU dut(
        .instr(instr),
        .result(result),
        .zero_fg(zero_fg)
    );

    initial begin
        instr.a = 2;
        instr.b = 1;
        instr.opcode = packages::ADD; #5;
        $display("alu result = %d (expected 3)", result); #5;

        instr.a = 2;
        instr.b = 1;
        instr.opcode = packages::SUB; #5;
        $display("alu result = %d (expected 1)", result);

        instr.a = 2;
        instr.b = 1;
        instr.opcode = packages::OP_AND; #5;
        $display("alu result = %d (expected 0)", result); #5

        instr.a = 3;
        instr.b = 1;
        instr.opcode = packages::OP_AND; #5;
        $display("alu result = %d (expected 1)", result);

        instr.a = 2;
        instr.b = 1;
        instr.opcode = packages::OP_OR; #5;
        $display("alu result = %d (expected 3)", result);
    end
endmodule