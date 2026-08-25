import packages::*;
module ALU(
    input logic[31:0] a,
    input logic[31:0] b,
    input packages::opcode_t opcode
    output logic [31:0] result,
    output logic zero_fg
);
    always_comb begin
        case (opcode)
            packages::ADD: result = a + b;
            packages::SUB: result = a - b;
            packages::OP_AND: result = a & b;
            packages::OP_OR: result = a | b;
            packages::OP_XOR: result = (a | b) & ~(a & b);
            packages::OP_SLT: result = (a < b) ? 1:0;
            default: result = 0;
        endcase
    end
    assign zero_fg = (result == 0);
endmodule