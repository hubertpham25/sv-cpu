module imm_test;
    logic [31:0] instr;
    logic [31:0] immed_val;
    logic [31:0] test_num;
    immed_gen dut(
        .instr(instr),
        .immed_val(immed_val)
    );

    initial begin
        //addi
        test_num = 32'b000010101111_1101010110110_0010011;
        instr = test_num;
        #5;
        $display("Result: %d (expected 175)", immed_val);
        test_num = 32'b10101111111101010000111100010011;
        instr = test_num;
        #5;
        $display("Result: %d (expected -1281)", immed_val);

        //SW
        test_num = 32'b01111111111111111111111110100011;
        instr = test_num;
        #5;
        $display("Result: %d (expected 2047)", immed_val);
        test_num = 32'b10000000000000000000000000100011;
        instr = test_num;
        #5;
        $display("Result: %d (expected -2047)", immed_val);

        //BEQ
        test_num = 32'b01101010010010010101111111100011;
        instr = test_num;
        #5;
        $display("Result: %d (expected 3774)", immed_val);
        test_num = 32'b10100101011001101011101111100011;
        instr = test_num;
        #5;
        $display("Result: %d (expected -1450)", immed_val);


    end
endmodule