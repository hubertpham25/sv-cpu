package packages;
    typedef enum {ADD, SUB, OP_AND, OP_OR, OP_XOR} opcode_t;
    typedef struct {
        logic[31:0] a, b;
        opcode_t opcode;
    } instructions_t;
endpackage