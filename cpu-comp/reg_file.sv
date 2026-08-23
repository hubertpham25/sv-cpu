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
