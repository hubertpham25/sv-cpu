package packages;
    typedef enum {ADD, SUB, OP_AND, OP_OR, OP_XOR} opcode_t;
    typedef struct packed {
        logic[31:0] a, b;
        opcode_t opcode;
    } instructions_t;

    typedef enum logic[6:0] {ADDI_OP = 7'b0010011, 
            SW_OP = 7'b0100011, BEQ_OP = 7'b1100011, RTYPE = 7'b0110011} immed_opcode_t;
endpackage