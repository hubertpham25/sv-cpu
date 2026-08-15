typedef enum {ADDI_OP = 7'b0010011, 
            SW_OP = 7'b0100011, BEQ_OP = 7'b1100011, RTYPE = 7'b0110011} immed_opcode;
module immed_gen(
    input logic [31:0] instr,
    output logic [31:0] immed_val
);
    logic [6:0] opcode;
    assign opcode = instr[6:0];
    always_comb begin
        case (opcode)
            ADDI_OP:
            SW_OP: 
            BEQ_OP: 
            default: //RTYPE
        endcase
        
    end

endmodule