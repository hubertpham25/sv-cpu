import packages::*;
module CPU;
    logic clk;

    // output control unit wires
    logic[31:0] instr; 
    // ^ from instr_memory to control unit, shared between r1,r2 and w1 in register file
    logic reg_wr;
    logic alu_src;
    logic mem_rd;
    logic mem_wr;
    logic mem_to_reg;
    logic branch;
    opcode_t alu_op;

    // register file output wires
    logic[31:0] out_r1, out_r2;

    // ALU output wires
    logic[31:0] alu_result;
    logic zero_fg; // goes to PC Adder

    // Data memory output wires
    logic[31:0] datamem_result;

    // Immediate generator output wire
    logic[31:0] imm_val;

    // PC_Adder output wire
    logic[31:0] next_pc;

    // PC output wire
    logic[31:0] curr_pc;

    CONTROL_UNIT cu_inst(
        .instr(instr),
        .reg_wr(reg_wr),
        .alu_src(alu_src),
        .mem_rd(mem_rd),
        .mem_wr(mem_wr),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .alu_op(alu_op)
    );

    REG_FILE regfile_inst(
        .clk(clk),
        .wr_data(reg_wr),
        .r1(instr),
        .r2(instr),
        .w1(instr),
        // make the mux behavior
        .out_r1(out_r1),
        .out_r2(out_r2)
    );

    ALU alu_inst(
        .a(out_r1),
        // mux behavior for b
        .opcode(alu_op)
        .result(alu_result),
        .zero_fg(zero_fg);
    );

    DATA_MEM datamem_inst(
        .addr(result),
        // wr_data is from the mux behavior from reg file
        .clk(clk),
        .mem_rd(mem_rd),
        .mem_wr(mem_wr)
        .result(datamem_result)
    );

    IMMED_GEN immgen_inst(
        .instr(instr),
        .immed_val(imm_val)
    );

    PC_ADDER pcadder_inst(
        .curr_pc(curr_pc),
        .imm(imm_val)
        .branch(branch),
        .zero_fg(zero_fg),
        .next_pc(next_pc)
    )

    PC pc_inst(
        .next_pc(next_pc),
        .curr_pc(curr_pc)
    )


endmodule;