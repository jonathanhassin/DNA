
module deletion_restore #(
    parameter N = 100,
	parameter A = 24  // constant "a" according the article
)(
	input clk,
	input rst,
    input [2*N-1:0] word_in,
    output logic [2*(N+1)-1:0] word_out
);

	logic [8:0] word_sum;
	logic [2*N-1:0] diff_word;
	logic [13:0] inv_syn;
	logic [6:0] missing_index;
	logic [1:0] missing_digit;
	logic [2*(N+1)-1:0] word;
	
		
	always_ff @(posedge clk or posedge rst) begin
		if (rst) word_out=0;
		else begin 
			word_out=word;
		end
	end
	
	always_comb begin
		diff_word diff_word0 (
			.clk(clk),
			.rst(rst),
			.word_in(word_in),
			.word_out(diff_word)
		);
		
		inv_syn inv_syn0 (
			.clk(clk),
			.rst(rst),
			.word_in(diff_word),
			.sum_out(inv_syn)
		);
		
		word_sum word_sum0 )
			.clk(clk),
			.rst(rst),
			.word_in(word_in),
			.sum_out(word_sum)
		);
		
		find_index find_index0 (
			.clk(clk),
			.rst(rst),
			.word_in(diff_word),
			.word_sum(word_sum),
			.inv_syn(inv_syn),
			.missing_index(missing_index),
			.missing_digit(missing_digit)
		);
		
		insert_digit insert_digit0 (
			.clk(clk),
			.rst(rst),
			.word_in(word_in);
			.missing_digit(missing_digit),
			.missing_index(missing_index),
			.word_out(word)
		);
	end
	
endmodule



