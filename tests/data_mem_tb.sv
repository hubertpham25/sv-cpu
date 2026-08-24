module data_mem_tb;
    logic [5:0] addr;
    logic [31:0] wr_data;
    logic clk;
    logic mem_rd;
    logic mem_wr;
    logic [31:0] result;

    data_mem dut(
        .addr(addr),
        .wr_data(wr_data),
        .clk(clk),
        .mem_rd(mem_rd),
        .mem_wr(mem_wr),
        .result(result)
    );

    // clock generator
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Test 1: read from an unwritten address -> expect 0
        mem_rd = 1;
        mem_wr = 0;
        addr = 6'd0;
        @(posedge clk);
        @(posedge clk);
        $display("Read addr 0 (before write): result=%d (expected 0)", result);

        // Test 2: write 42 into address 0
        mem_rd = 0;
        mem_wr = 1;
        addr = 6'd0;
        wr_data = 32'd42;
        @(posedge clk);
        @(posedge clk);
        $display("Wrote 42 to addr 0");

        // Test 3: read back address 0 -> expect 42
        mem_rd = 1;
        mem_wr = 0;
        addr = 6'd0;
        @(posedge clk);
        @(posedge clk);
        $display("Read addr 0 (after write): result=%d (expected 42)", result);

        // Test 4: write a different value to a different address
        mem_rd = 0;
        mem_wr = 1;
        addr = 6'd5;
        wr_data = 32'd777;
        @(posedge clk);
        @(posedge clk);
        $display("Wrote 777 to addr 5");

        // Test 5: confirm addr 5 has new value, addr 0 is unchanged
        mem_rd = 1;
        mem_wr = 0;
        addr = 6'd5;
        @(posedge clk);
        @(posedge clk);
        $display("Read addr 5: result=%d (expected 777)", result);

        addr = 6'd0;
        @(posedge clk);
        @(posedge clk);
        $display("Read addr 0 (still): result=%d (expected 42, unchanged)", result);

        // Test 6: confirm mem_wr=0 means no write happens
        mem_rd = 0;
        mem_wr = 0;
        addr = 6'd0;
        wr_data = 32'd9999;
        @(posedge clk);
        @(posedge clk);
        mem_rd = 1;
        addr = 6'd0;
        @(posedge clk);
        @(posedge clk);
        $display("Read addr 0 (after attempted write with mem_wr=0): result=%d (expected 42, unchanged)", result);

        $finish;
    end
endmodule