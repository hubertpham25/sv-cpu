module pc_adder_tb;
    logic [31:0] curr_pc;
    logic [31:0] imm;
    logic branch;
    logic zero_flag;
    logic [31:0] next_pc;

    pc_adder dut(
        .curr_pc(curr_pc),
        .imm(imm),
        .branch(branch),
        .zero_flag(zero_flag),
        .next_pc(next_pc)
    );

    initial begin
        // Test 1: not a branch at all -> should always take curr_pc + 4
        curr_pc = 32'd0;
        imm = 32'd100;   // large offset, should be ignored
        branch = 0;
        zero_flag = 0;
        #5;
        $display("Not branch, zero=0: next_pc=%d (expected 4)", next_pc);

        // Test 2: not a branch, but zero_flag happens to be 1 -> should STILL take curr_pc + 4
        // (this specifically checks branch && zero_flag, not zero_flag alone)
        curr_pc = 32'd4;
        imm = 32'd100;
        branch = 0;
        zero_flag = 1;
        #5;
        $display("Not branch, zero=1: next_pc=%d (expected 8)", next_pc);

        // Test 3: branch instruction, but condition not met (zero_flag=0) -> not taken, curr_pc+4
        curr_pc = 32'd8;
        imm = 32'd20;
        branch = 1;
        zero_flag = 0;
        #5;
        $display("Branch, not taken: next_pc=%d (expected 12)", next_pc);

        // Test 4: branch instruction, condition met (zero_flag=1) -> taken, curr_pc + imm
        curr_pc = 32'd12;
        imm = 32'd20;
        branch = 1;
        zero_flag = 1;
        #5;
        $display("Branch, taken: next_pc=%d (expected 32)", next_pc);

        // Test 5: branch taken with a different pc/imm combo, to confirm addition is general
        curr_pc = 32'd100;
        imm = 32'd44;
        branch = 1;
        zero_flag = 1;
        #5;
        $display("Branch, taken (2): next_pc=%d (expected 144)", next_pc);

        $finish;
    end
endmodule