module registerf_tb;
    logic clk;
    logic wr_enable;
    logic [4:0] r1, r2;
    logic [4:0] w1;
    logic [31:0] wr_data;
    logic [31:0] out_r1, out_r2;

    REG_FILE dut(
        .clk(clk),
        .wr_enable(wr_enable),
        .r1(r1), .r2(r2),
        .w1(w1),
        .wr_data(wr_data),
        .out_r1(out_r1), .out_r2(out_r2)
    );

    initial begin // clock/tick generator
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin // actual testing and setting vars. dependent on the clk
        wr_enable = 1; // write enable on
        r1 = 1; // register 1
        r2 = 2; // register 2
        w1 = 1; // write to register 1
        wr_data = 10; // write 10
        @(posedge clk);
        @(posedge clk);
        $display("register %d: %d (expected 10)", r1, out_r1); #5;
        $display("register %d: %d (expected 0)", r2, out_r2); #5;
        // test 2: with write to special register
        wr_enable = 1;
        r1 = 0;
        r2 = 1;
        w1 = 0;
        wr_data = 10;
        @(posedge clk);
        @(posedge clk);
        $display("register %d: %d (writing to special register -> 0)", r1, out_r1); #5;
        $display("register %d: %d (expected 10)", r2, out_r2); #5
        // test 3: reading
        wr_enable = 0; 	
        r1 = 31;
        r2 = 1;
        @(posedge clk);
        @(posedge clk);
        $display("register %d: %d (expected 0)", r1, out_r1); #5;
        $display("register %d: %d (expected 10)", r2, out_r2); #5;
        $finish;
    end
endmodule