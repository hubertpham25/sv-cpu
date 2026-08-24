import packages::*;

module control_unit_tb;
    logic [31:0] instr;
    logic reg_wr, alu_src, mem_rd, mem_wr, mem_to_reg, branch;
    packages::opcode_t alu_op;

    control_unit dut(
        .instr(instr),
        .reg_wr(reg_wr),
        .alu_src(alu_src),
        .mem_rd(mem_rd),
        .mem_wr(mem_wr),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .alu_op(alu_op)
    );

    initial begin
        // add: funct7=0000000 rs2 rs1 funct3=000 rd opcode=0110011
        instr = {7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011};
        #5;
        $display("ADD: reg_wr=%b(1) alu_src=%b(1) mem_rd=%b(0) mem_wr=%b(0) mem_to_reg=%b(0) branch=%b(0) alu_op=%s(ADD)",
                  reg_wr, alu_src, mem_rd, mem_wr, mem_to_reg, branch, alu_op.name());

        // sub: funct7=0100000 rs2 rs1 funct3=000 rd opcode=0110011
        instr = {7'b0100000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011};
        #5;
        $display("SUB: reg_wr=%b(1) alu_src=%b(1) mem_rd=%b(0) mem_wr=%b(0) mem_to_reg=%b(0) branch=%b(0) alu_op=%s(SUB)",
                  reg_wr, alu_src, mem_rd, mem_wr, mem_to_reg, branch, alu_op.name());

        // and: funct7=0000000 rs2 rs1 funct3=111 rd opcode=0110011
        instr = {7'b0000000, 5'd2, 5'd1, 3'b111, 5'd3, 7'b0110011};
        #5;
        $display("AND: reg_wr=%b(1) alu_src=%b(1) mem_rd=%b(0) mem_wr=%b(0) mem_to_reg=%b(0) branch=%b(0) alu_op=%s(OP_AND)",
                  reg_wr, alu_src, mem_rd, mem_wr, mem_to_reg, branch, alu_op.name());

        // or: funct7=0000000 rs2 rs1 funct3=110 rd opcode=0110011
        instr = {7'b0000000, 5'd2, 5'd1, 3'b110, 5'd3, 7'b0110011};
        #5;
        $display("OR: reg_wr=%b(1) alu_src=%b(1) mem_rd=%b(0) mem_wr=%b(0) mem_to_reg=%b(0) branch=%b(0) alu_op=%s(OP_OR)",
                  reg_wr, alu_src, mem_rd, mem_wr, mem_to_reg, branch, alu_op.name());

        // slt: funct7=0000000 rs2 rs1 funct3=010 rd opcode=0110011
        instr = {7'b0000000, 5'd2, 5'd1, 3'b010, 5'd3, 7'b0110011};
        #5;
        $display("SLT: reg_wr=%b(1) alu_src=%b(1) mem_rd=%b(0) mem_wr=%b(0) mem_to_reg=%b(0) branch=%b(0) alu_op=%s(OP_SLT)",
                  reg_wr, alu_src, mem_rd, mem_wr, mem_to_reg, branch, alu_op.name());

        // addi: imm[11:0]=5 rs1 funct3=000 rd opcode=0010011
        instr = {12'd5, 5'd1, 3'b000, 5'd3, 7'b0010011};
        #5;
        $display("ADDI: reg_wr=%b(1) alu_src=%b(0) mem_rd=%b(0) mem_wr=%b(0) mem_to_reg=%b(0) branch=%b(0) alu_op=%s(ADD)",
                  reg_wr, alu_src, mem_rd, mem_wr, mem_to_reg, branch, alu_op.name());

        // lw: imm[11:0]=8 rs1 funct3=010 rd opcode=0000011
        instr = {12'd8, 5'd1, 3'b010, 5'd3, 7'b0000011};
        #5;
        $display("LW: reg_wr=%b(1) alu_src=%b(0) mem_rd=%b(1) mem_wr=%b(0) mem_to_reg=%b(1) branch=%b(0) alu_op=%s(ADD)",
                  reg_wr, alu_src, mem_rd, mem_wr, mem_to_reg, branch, alu_op.name());

        // sw: imm[11:5]=0 rs2 rs1 funct3=010 imm[4:0]=8 opcode=0100011
        instr = {7'b0000000, 5'd2, 5'd1, 3'b010, 5'd8, 7'b0100011};
        #5;
        $display("SW: reg_wr=%b(0) alu_src=%b(0) mem_rd=%b(0) mem_wr=%b(1) mem_to_reg=%b(x) branch=%b(0) alu_op=%s(ADD)",
                  reg_wr, alu_src, mem_rd, mem_wr, mem_to_reg, branch, alu_op.name());

        // beq: imm[12|10:5]=0 rs2 rs1 funct3=000 imm[4:1|11]=0 opcode=1100011
        instr = {7'b0000000, 5'd2, 5'd1, 3'b000, 5'd0, 7'b1100011};
        #5;
        $display("BEQ: reg_wr=%b(0) alu_src=%b(1) mem_rd=%b(0) mem_wr=%b(0) mem_to_reg=%b(x) branch=%b(1) alu_op=%s(SUB)",
                  reg_wr, alu_src, mem_rd, mem_wr, mem_to_reg, branch, alu_op.name());

        // unrecognized opcode -> should hit default, no latch (all outputs driven)
        instr = {25'b0, 7'b1111111};
        #5;
        $display("DFLT: reg_wr=%b(0) alu_src=%b(0) mem_rd=%b(0) mem_wr=%b(0) mem_to_reg=%b(0) branch=%b(0) alu_op=%s",
                  reg_wr, alu_src, mem_rd, mem_wr, mem_to_reg, branch, alu_op.name());

        $finish;
    end
endmodule