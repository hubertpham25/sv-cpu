typedef enum {ADDI_OP = 7'b0010011, 
            SW_OP = 7'b0100011, BEQ_OP = 7'b1100011, RTYPE = 7'b0110011} immed_opcode;
module immed_gen(
    input logic [31:0] instr,
    output logic [31:0] immed_val
);
    logic [6:0] opcode;
    assign opcode = instr[6:0];
    logic [11:0] imm_11_0;
    logic [12:0] beq_imm;
    always_comb begin
        case (opcode)
            ADDI_OP: begin
                imm_11_0 = instr[31:20];
                immed_val = {{20{instr[31]}}, imm_11_0};
            end
            SW_OP: begin
                imm_11_0 = {instr[31:25], instr[11:7]};
                immed_val = {{20{instr[31]}}, imm_11_0};
            end
            BEQ_OP: begin
                beq_imm = {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
                immed_val = {{19{instr[31]}}, beq_imm};
            end
            default: begin
                immed_val = 0;
            end
        endcase
        
    end

endmodule