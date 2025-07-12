module divisor_clk(
    input wire clk_in,       // 1 MHz
    output reg clk_out = 0   // 1/2 MHz
);
    always @(posedge clk_in)
        clk_out <= ~clk_out;
endmodule