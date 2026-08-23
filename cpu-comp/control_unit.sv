import packages::*;
module control_unit(
    input logic[31:0] instr,
    output logic reg_wr, // should it write to a register
    output logic alu_src, // does ALU second operand come from a register (1) or immediate (0)
    output logic mem_rd, // should data memory be read this cycle
    output logic mem_wr, // should data memory be written this cycle
    output logic mem_to_reg, // when writing to register, does value come from ALU result (0) or data memory (1)
    output logic branch, // is it a branch instruction
    output packages::opcode_t alu_op
);
    logic[6:0] opcode;
    logic[2:0] funct3;
    logic[6:0] funct7;
    always_comb begin
        opcode = instr[6:0];
        funct3 = instr[14:12];
        case (opcode)
            packages::RTYPE: begin
                alu_src = 1;
                mem_rd = 0;
                branch = 0;
                mem_to_reg = 0;
                mem_wr = 0;
                reg_wr = 1;
        
                if (funct3 == 0) begin //funct3 = 0x0
                    funct7 = instr[31:25];
                    if (funct7 == 0) begin // add
                        alu_op = packages::ADD;
                    end
                    else if (funct7 == 7'h20) begin // sub 0x20
                        alu_op = packages::SUB;
                    end
                end
                else if (funct3 == 3'h4) begin // funct3 = 0x4
                    alu_op = packages::OP_XOR;
                end
                else if (funct3 == 3'h6) begin //0x6
                    alu_op = packages::OP_OR;
                end
                else if (funct3 == 3'h7) begin //0x7
                    alu_op = packages::OP_AND;
                end
                else if (funct3 == 3'h2) begin //0x2
                    alu_op = packages::OP_SLT;
                end
                else begin //safe option
                    alu_op = packages::ADD; 
                end
            end
            packages::ADDI_OP: begin //I-type. Might not be worth renaming and touching other files
                alu_src = 0;
                mem_rd = 0;
                branch = 0;
                mem_to_reg = 0;
                mem_wr = 0;
                reg_wr = 1;

                if (funct3 == 3'h0) begin //addi
                    alu_op = packages::ADD;
                end
                else begin
                    alu_op = packages::ADD;
                end
            end 
            packages::SW_OP: begin
                alu_src = 0;
                mem_rd = 0;
                branch = 0;
                mem_to_reg = 0;
                mem_wr = 1;
                reg_wr = 0;

                alu_op = packages::ADD;
            end
            packages::BEQ_OP: begin
                alu_src = 1;
                mem_rd = 0;
                branch = 1;
                mem_to_reg = 0;
                mem_wr = 0;
                reg_wr = 0;

                alu_op = packages::SUB;
            end
            packages::LW_OP: begin
                alu_src = 0;
                mem_rd = 1;
                branch = 0;
                mem_to_reg = 1;
                mem_wr = 0;
                reg_wr = 1;

                alu_op = packages::ADD;
            end
        endcase
    end
endmodule