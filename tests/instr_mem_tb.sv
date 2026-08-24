module instr_mem_tb;
    logic [31:0] PC;
    logic [31:0] instr_word;

    instr_mem dut(
        .PC(PC),
        .instr_word(instr_word)
    );

    initial begin
        // PC=0 -> slot 0 -> add x3, x1, x2
        PC = 32'd0;
        #5;
        $display("PC=0: instr_word=%h (expected %h)", instr_word,
                  {7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011});

        // PC=4 -> slot 1 -> sub x4, x1, x2
        PC = 32'd4;
        #5;
        $display("PC=4: instr_word=%h (expected %h)", instr_word,
                  {7'b0100000, 5'd2, 5'd1, 3'b000, 5'd4, 7'b0110011});

        // PC=8 -> slot 2 -> addi x5, x1, 10
        PC = 32'd8;
        #5;
        $display("PC=8: instr_word=%h (expected %h)", instr_word,
                  {12'd10, 5'd1, 3'b000, 5'd5, 7'b0010011});

        // PC=12 -> slot 3 -> never preloaded, should read as 0 (or X depending on simulator)
        PC = 32'd12;
        #5;
        $display("PC=12: instr_word=%h (expected 00000000, uninitialized slot)", instr_word);

        $finish;
    end
endmodule