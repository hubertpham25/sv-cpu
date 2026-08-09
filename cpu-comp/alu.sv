typedef enum {ADD, SUB, OP_AND, OP_OR, OP_XOR} opcode;

module ALU(
    input logic[31:0] input_a,
    input logic[31:0] input_b,
    input opcode opcode_t,
    output logic [31:0] result,
    output logic zero_fg
);
    always_comb begin
        case (opcode_t)
            ADD: result = input_a + input_b;
            SUB: result = input_a - input_b;
            OP_AND: result = input_a & input_b;
            OP_OR: result = input_a | input_b;
            OP_XOR: result = (input_a | input_b) & ~(input_a & input_b);
            default: result = 0;
        endcase
    end
    assign zero_fg = (result == 0);
endmodule