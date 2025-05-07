
module top_module #(
    parameter N = 100,  // Number of digits in the original word (will be set to 100)
	parameter M = 84, // Number of digits in the current word
	parameter A = 24  // constant "a" according the article
)(
    input [2*N-1:0] word_in,
	input [6:0] word_in_len,
    output logic [2*(N-2)-1:0] word_out,
	output logic [6:0] word_out_len
);

	logic reverse_needed,in_prefix,was_deletion;
	logic [2*(N-2)-1:0] word;
	logic [6:0] word_len;
	
	initial begin
		clk=0;
		forever #5 clk =~clk;
	end
	
	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin 
			word_out=0;
			word_out_len=0;
		end 
		else begin 
			word_out=word;
			word_out_len=word_len;
		end
	end
	
	always_comb begin
		
		/*
		word_len word_len0 (
			.clk(clk),
			.rst(rst),
			.word_in(word_in)
			.word_len(word_len)
		);
		*/
		
		if (word_in_len==2'd99) was_deletion=1;
		else was_deletion=0;
		
		handle_prefix handle_prefix0 #(.N(N)) uut (
			.clk(clk),
			.rst(rst),
			.prefix(word_in[N*2-1 -: 4]),
			.reverse_needed(reverse_needed),
			.in_prefix(in_prefix),
			.word_out(word)
		);
		// by now word is 98 digits or 97 digits + 1 trash digit on the right

		if (was_deletion && !in_prefix) 
			deletion_restore deletion_restore0 #(.N(N-3),.A(A)) uut (
				.clk(clk),
				.rst(rst),
				.word_in(word_in),
				.word_out(word)
			);
		end
		
		// by now word is 98 digits
		diff_word diff_word0 #(.N(N-2)) uut (
			.clk(clk),
			.rst(rst),
			.word_in(word),
			.word_out(word)
		);
		
		if (reverse_needed) begin
			reverse_word reverse_word0 #(.N(N-2)) uut (
				.clk(clk),
				.rst(rst),
				.word_in(word),
				.word_out(word)
			);
		end 
		
		remove_y remove_y0 #(.N(N-2),.M(M)) uut (
			.clk(clk),
			.rst(rst),
			.word_in(word),
			.word_out(word)
		);
		
		// by now word is 84 digits
		diff_word diff_word1 #(.N(M)) uut (
			.clk(clk),
			.rst(rst),
			.word_in(word),
			.word_out(word)
		);
	
		rll_restore rll_restore0 #(.N(M)) uut (
			.clk(clk),
			.rst(rst),
			.word_in(word),
			.word_out(word),
			.output_len(word_out_len)
		);
		
	end
	
endmodule



