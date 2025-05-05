module rll_restore_test;


    parameter N = 20;
	logic clk, rst;
    logic [2*N-1:0] word_in;
    logic [13:0] word_out;
	logic [6:0] word_len;

	rll_restore #(.N(N)) uut (
		.clk(clk),
		.rst(rst),
        .word_in(word_in),
        .word_out(word_out),
		.output_len(word_len)
    	);

	initial begin
		clk=0;
		forever #5 clk =~clk;
	end
	
    initial begin
        
		word_in = 40'b0110110110110110110000000011010000011001;
		#50;
		$display("Input: %b, Output: %b, Len: %b", word_in, word_out, word_len);

		$finish;
    end

endmodule
