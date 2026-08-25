module pc_tb;
    logic clk;
    logic [31:0] next_pc;
    logic [31:0] curr_pc;

    pc dut(
        .clk(clk),
        .next_pc(next_pc),
        .curr_pc(curr_pc)
    );

    // clock generator
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Test 1: normal sequential stepping, PC+4 each time
        next_pc = 32'd0;
        @(posedge clk);
        $display("Step 1: curr_pc=%d (expected 0)", curr_pc);

        next_pc = 32'd4;
        @(posedge clk);
        $display("Step 2: curr_pc=%d (expected 4)", curr_pc);

        next_pc = 32'd8;
        @(posedge clk);
        $display("Step 3: curr_pc=%d (expected 8)", curr_pc);

        next_pc = 32'd12;
        @(posedge clk);
        $display("Step 4: curr_pc=%d (expected 12)", curr_pc);

        // Test 2: simulate a branch jump to a non-sequential address
        next_pc = 32'd100;
        @(posedge clk);
        $display("Jump: curr_pc=%d (expected 100)", curr_pc);

        // Test 3: confirm normal stepping resumes correctly after the jump
        next_pc = 32'd104;
        @(posedge clk);
        $display("Step after jump: curr_pc=%d (expected 104)", curr_pc);

        $finish;
    end
endmodule