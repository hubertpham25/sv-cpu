import packages::*:;
module ALU_tb;
    packages::instructions_t instr;
    logic[31:0] result;
    logic zero_fg;

    ALU dut(
        .instr(instr),
        .result(result),
        .zero_fg(zero_fg)
    );

    initial begin
        instr.a <= 2; #5
        instr.b <= 1; #5
    end

endmodule