
module deletion_restore #(
    parameter N = 18,
	parameter A = 30,	// constant "a" according the article
	parameter B = 27	// constant "b" according the article
)(
	input clk,
	input rst,
    input [2*(N-1)-1:0] word_in,
	input reverse_needed,
    output logic [2*N-1:0] word_out
);

	logic [9:0] diff_word_sum;
	logic [2*(N-1)-1:0] diff_word;
	logic [13:0] inv_syn;
	logic [6:0] missing_index;
	logic [1:0] missing_digit;
	logic [2*N-1:0] word;
		
		diff_word #(.N(N-1)) diff_word0 (
			.clk(clk),
			.rst(rst),
			.word_in(word_in),
			.word_out(diff_word)
		);
		
		inv_syn #(.N(N-1)) inv_syn0 (
			.clk(clk),
			.rst(rst),
			.word_in(diff_word),
			.sum_out(inv_syn)
		);
		
		word_sum #(.N(N-1)) word_sum0 (
			.clk(clk),
			.rst(rst),
			.word_in(diff_word),
			.sum_out(diff_word_sum)
		);
		
		find_index #(.N(N),.A(A),.B(B)) find_index0 (
			.clk(clk),
			.rst(rst),
			.word_in(word_in),
			.diff_word(diff_word),
			.diff_word_sum(diff_word_sum),
			.inv_syn(inv_syn),
			.reverse_needed(reverse_needed),
			.missing_index(missing_index),
			.missing_digit(missing_digit)
		);
		
		insert_digit #(.N(N)) insert_digit0 (
			.clk(clk),
			.rst(rst),
			.word_in(word_in),
			.missing_digit(missing_digit),
			.missing_index_ltr(missing_index),
			.word_out(word)
		);

		
		always_ff @(posedge clk or posedge rst) begin
			if (rst) word_out=0;
			else begin 
				word_out=word;
			end
		end
		
	
	
endmodule



