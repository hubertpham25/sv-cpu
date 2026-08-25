package packages;
    typedef enum {ADD, SUB, OP_AND, OP_OR, OP_XOR, OP_SLT} opcode_t;
    typedef enum logic[6:0] {ADDI_OP = 7'b0010011, SW_OP = 7'b0100011, 
                            BEQ_OP = 7'b1100011, RTYPE = 7'b0110011,
                            LW_OP = 7'b0000011} immed_opcode_t;
endpackage
//Top level CPU
import packages::*;
import packages::*;
module CPU(input logic clk);
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
    
    // instruction memory output: at top ^^^^
    
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
        .wr_enable(reg_wr),
        .r1(instr[19:15]),
        .r2(instr[24:20]),
        .w1(instr[11:7]),
        .wr_data(mem_to_reg ? datamem_result : alu_result),
        .out_r1(out_r1),
        .out_r2(out_r2)
    );

    ALU alu_inst(
        .a(out_r1),
        .b(alu_src ? out_r2 : imm_val),
        .opcode(alu_op),
        .result(alu_result),
        .zero_fg(zero_fg)
    );

    DATA_MEM datamem_inst(
        .addr(alu_result[7:2]),
        .wr_data(out_r2),
        .clk(clk),
        .mem_rd(mem_rd),
        .mem_wr(mem_wr),
        .result(datamem_result)
    );

    IMMED_GEN immgen_inst(
        .instr(instr),
        .immed_val(imm_val)
    );

    PC_ADDER pcadder_inst(
        .curr_pc(curr_pc),
        .imm(imm_val),
        .branch(branch),
        .zero_fg(zero_fg),
        .next_pc(next_pc)
    );

    PC pc_inst(
        .clk(clk),
        .next_pc(next_pc),
        .curr_pc(curr_pc)
    );

    INSTR_MEM instrmem_inst(
        .pc(curr_pc),
        .instr_word(instr)
    );
endmodule

module ALU(
    input logic[31:0] a,
    input logic[31:0] b,
    input packages::opcode_t opcode,
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

module CONTROL_UNIT(
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
        funct7 = instr[31:25];
        case (opcode)
            packages::RTYPE: begin
                alu_src = 1;
                mem_rd = 0;
                branch = 0;
                mem_to_reg = 0;
                mem_wr = 0;
                reg_wr = 1;
        
                if (funct3 == 0) begin //funct3 = 0x0
                    if (funct7 == 0) begin // add
                        alu_op = packages::ADD;
                    end
                    else if (funct7 == 7'h20) begin // sub 0x20
                        alu_op = packages::SUB;
                    end
                    else begin // just safe else statement
                        alu_op = packages::ADD;
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
            default: begin
                alu_src = 0;
                mem_rd = 0;
                branch = 0;
                mem_to_reg = 0;
                mem_wr = 0;
                reg_wr = 0;

                alu_op = packages::ADD;
            end
        endcase
    end
endmodule

module DATA_MEM(
    input logic[5:0] addr,
    input logic[31:0] wr_data,
    input logic clk,
    input logic mem_rd,
    input logic mem_wr,
    output logic[31:0] result
);
    logic[31:0] data_mem [63:0];
    always_ff @(posedge clk) begin: data_wr
        if (mem_wr == 1) begin
            data_mem[addr] <= wr_data;
        end
    end: data_wr
    assign result = data_mem[addr];

endmodule

import packages::immed_opcode_t;
module IMMED_GEN(
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

module INSTR_MEM(
    input logic[31:0] pc,
    output logic[31:0] instr_word
);
    logic[31:0] instr_memory [63:0];
    logic[5:0] instr_addr;
    assign instr_addr = pc[7:2];
    assign instr_word = instr_memory[instr_addr];
    initial begin
        $readmemh("program.hex", instr_memory);
    end
endmodule

module PC_ADDER(
    input logic[31:0] curr_pc,
    input logic[31:0] imm,
    input logic branch,
    input logic zero_fg,
    output logic[31:0] next_pc
);
    logic[31:0] branch_pc;
    logic[31:0] add_pc;
    assign branch_pc = curr_pc + imm;
    assign add_pc = curr_pc + 4;
    always_comb begin
        if (branch == 1 && zero_fg == 1) begin
            next_pc = branch_pc;
        end
        else begin
            next_pc = add_pc;
        end
    end
endmodule

module PC(
    input logic clk,
    input logic[31:0] next_pc,
    output logic[31:0] curr_pc
);
    always_ff @(posedge clk) begin: move_instr
        curr_pc <= next_pc;
    end: move_instr
endmodule

module REG_FILE #(parameter wr_addr = 5, wr_dataddr = 32)( //<- bit widths as param
    input logic clk,
    input logic wr_enable,
    input logic[wr_addr-1:0] r1, r2, // register address to read from
    input logic[wr_addr-1:0] w1, // register address to write to
    input logic[wr_dataddr-1:0] wr_data, // data to write to register
    output logic[wr_dataddr-1:0] out_r1, out_r2 // read outputs
);
    logic [31:0] register_file [31:0];
    always_ff @(posedge clk) begin : write
        if (wr_enable && (w1 != 0)) begin
            // w1 does not equal to address 0 -> special register
            register_file[w1] <= wr_data;
        end
    end : write
    always_comb begin : read
        if (r1 == 0) begin
            out_r1 = 0; 
        end
        else begin
            out_r1 = register_file[r1];
        end
        if (r2 == 0) begin
            out_r2 = 0;
        end
        else begin
            out_r2 = register_file[r2];
        end
        
    end : read
endmodule
