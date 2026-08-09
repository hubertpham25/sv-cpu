import packages::*;
module ALU(
    input packages::instructions_t instr,
    output logic [31:0] result,
    output logic zero_fg
);
    always_comb begin
        case (instr.opcode)
            packages::ADD: result = instr.a + instr.b;
            packages::SUB: result = instr.a - instr.b;
            packages::OP_AND: result = instr.a & instr.b;
            packages::OP_OR: result = instr.a | instr.b;
            packages::OP_XOR: result = (instr.a | instr.b) & ~(instr.a & instr.b);
            default: result = 0;
        endcase
    end
    assign zero_fg = (result == 0);
endmodule