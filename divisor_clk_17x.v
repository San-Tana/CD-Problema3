module divisor_clk_17x(
    input clk_in,       // 1 
    output clk_OUT = 0   // 1/2 
);
    wire [16:0] clk_out; 
	 divisor_clk divc0 (.clk_in(clk_in) , .clk_out(clk_out[0]));
	 divisor_clk divc1 (.clk_in(clk_out[0]) , .clk_out(clk_out[1]));
	 divisor_clk divc2 (.clk_in(clk_out[1]) , .clk_out(clk_out[2]));
	 divisor_clk divc3 (.clk_in(clk_out[2]) , .clk_out(clk_out[3]));
	 divisor_clk divc4 (.clk_in(clk_out[3]) , .clk_out(clk_out[4]));
	 divisor_clk divc5 (.clk_in(clk_out[4]) , .clk_out(clk_out[5]));
	 divisor_clk divc6 (.clk_in(clk_out[5]) , .clk_out(clk_out[6]));
	 divisor_clk divc7 (.clk_in(clk_out[6]) , .clk_out(clk_out[7]));
	 divisor_clk divc8 (.clk_in(clk_out[7]) , .clk_out(clk_out[8]));
	 divisor_clk divc9 (.clk_in(clk_out[8]) , .clk_out(clk_out[9]));
	 divisor_clk divc10 (.clk_in(clk_out[9]) , .clk_out(clk_out[10]));
	 divisor_clk divc11 (.clk_in(clk_out[10]) , .clk_out(clk_out[11]));
	 divisor_clk divc12 (.clk_in(clk_out[11]) , .clk_out(clk_out[12]));
	 divisor_clk divc13 (.clk_in(clk_out[12]) , .clk_out(clk_out[13]));
	 divisor_clk divc14 (.clk_in(clk_out[13]) , .clk_out(clk_out[14]));
	 divisor_clk divc15 (.clk_in(clk_out[14]) , .clk_out(clk_out[15]));
	 divisor_clk divc16 (.clk_in(clk_out[15]) , .clk_out(clk_out[16]));
	 divisor_clk divc17 (.clk_in(clk_out[16]) , .clk_out(clk_OUT));

endmodule