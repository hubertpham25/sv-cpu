import packages::opcode_t;
module ALU_tb;
    logic[31:0] a, b;
    opcode_t opcode;
    logic[31:0] result;
    logic zero_fg;

    ALU dut(
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .zero_fg(zero_fg)
    );

    initial begin
        a = 2;
        b = 1;
        opcode = packages::ADD;
        #5;
        $display("alu result = %d (expected 3)", result);

        a = 2;
        b = 1;
        opcode = packages::SUB;
        #5;
        $display("alu result = %d (expected 1)", result);

        a = 2;
        b = 1;
        opcode = packages::OP_AND;
        #5;
        $display("alu result = %d (expected 0)", result);

        a = 3;
        b = 1;
        opcode = packages::OP_AND;
        #5;
        $display("alu result = %d (expected 1)", result);

        a = 2;
        b = 1;
        opcode = packages::OP_OR;
        #5;
        $display("alu result = %d (expected 3)", result);

        a = 5;
        b = 3;
        opcode = packages::OP_XOR;
        #5;
        $display("alu result = %d (expected 6)", result);

        a = 2;
        b = 5;
        opcode = packages::OP_SLT;
        #5;
        $display("alu result = %d (expected 1)", result);

        a = 5;
        b = 2;
        opcode = packages::OP_SLT;
        #5;
        $display("alu result = %d (expected 0)", result);

        a = 3;
        b = 3;
        opcode = packages::SUB;
        #5;
        $display("alu result = %d, zero_fg = %b (expected 0, 1)", result, zero_fg);

        $finish;
    end
endmodule