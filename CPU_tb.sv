module CPU_tb;
    logic clk;

    CPU dut(
        .clk(clk)
    );

    // clock generator
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Program (see program.hex), word-addressed, PC in bytes:
    //  0: addi x1, x0, 5        -> x1 = 5
    //  4: addi x2, x0, 10       -> x2 = 10
    //  8: add  x3, x1, x2       -> x3 = 15
    // 12: sub  x4, x2, x1       -> x4 = 5
    // 16: sw   x3, 0(x0)        -> mem[0] = 15
    // 20: lw   x5, 0(x0)        -> x5 = 15
    // 24: beq  x1, x4, 8        -> x1(5) == x4(5) -> branch TAKEN, PC = 24+8 = 32
    // 28: addi x6, x0, 99       -> SKIPPED (branch jumps over this)
    // 32: addi x7, x0, 42       -> x7 = 42
    //
    // Expected final state: x1=5 x2=10 x3=15 x4=5 x5=15 x6=0(never written) x7=42
    // mem[0] = 15

    initial begin
        // run for enough cycles to execute all 9 instructions
        // (single-cycle CPU: 1 instruction per clock edge)
        repeat (12) @(posedge clk);

        $display("---- Final register values ----");
        $display("x1 = %d (expected 5)",  dut.regfile_inst.register_file[1]);
        $display("x2 = %d (expected 10)", dut.regfile_inst.register_file[2]);
        $display("x3 = %d (expected 15)", dut.regfile_inst.register_file[3]);
        $display("x4 = %d (expected 5)",  dut.regfile_inst.register_file[4]);
        $display("x5 = %d (expected 15)", dut.regfile_inst.register_file[5]);
        $display("x6 = %d (expected 0, never written - branch should skip it)", dut.regfile_inst.register_file[6]);
        $display("x7 = %d (expected 42)", dut.regfile_inst.register_file[7]);

        $display("---- Final data memory value ----");
        $display("mem[0] = %d (expected 15)", dut.datamem_inst.data_mem[0]);

        $display("---- Final PC ----");
        $display("curr_pc = %d (expected 36, one past the last instruction)", dut.curr_pc);

        $finish;
    end
endmodule