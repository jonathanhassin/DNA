module top_module #(
    parameter N = 100,  //  number of digits in the original word (will be set to 100)
	parameter M = N-2-13, //  number of digits in the middle word (w/o redundancy bits)
	parameter A = 30,  // constant "a" according the article
	parameter B = ((5*(N-2)*(N-1)/2)-A)%(4*(N-2))	// constant "b" according the article
)(
	input clk,
	input rst,
    input [2*N-1:0] word_in,
	input [6:0] word_in_len,
	input [2*M-1:0] final_word_check,
    output logic [2*M-1:0] word_out,
	output logic [6:0] word_out_len,
	output logic final_correct
);

	logic reverse_needed,in_prefix,was_deletion;
	logic [6:0] word_len;
	logic [2*(N-2)-1:0] word_wo_prefix;
	logic [2*(N-2)-1:0] word_after_restore;
	logic [2*(N-2)-1:0] restored_word_out;
	logic [2*(N-2)-1:0] reversed_word_out;
	logic [2*(N-2)-1:0] word_1st_diff;
	logic [2*(N-2)-1:0] word_reversed;
	logic [2*M-1:0] word_wo_y;
	logic [2*M-1:0] word_2nd_diff;
	logic [2*M-1:0] word_no_rll;
	
	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin 
			word_out=0;
			word_out_len=0;
		end 
		else begin 
			word_out=word_no_rll;
			word_out_len=word_len;
		end
	end
	
	// word is 100 digits or 99 digit + 1 trash digit if there was a deletion
	assign was_deletion = (word_in_len==N-1);
		
	//handle prefix removes 2 leftmost digits and calculates critical signals
	//if there was a deletion and it wasn't at the prefix, the leftmost digit of the output word is trash
	handle_prefix #(.N(N)) handle_prefix0 (
		.clk(clk),
		.rst(rst),
		.word_in(word_in),
		.word_in_len(word_in_len),
		.reverse_needed(reverse_needed),
		.in_prefix(in_prefix),
		.word_out(word_wo_prefix)
	);
	// by now word is 98 digits or 97 digits + 1 trash digit on the right

	deletion_restore #(.N(N-2),.A(A),.B(B)) deletion_restore0 (
		.clk(clk),
		.rst(rst),
		.word_in(word_wo_prefix[2*(N-3)-1:0]),
		.reverse_needed(reverse_needed),
		.word_out(restored_word_out)
	);
		
	assign word_after_restore=(was_deletion && !in_prefix) ? restored_word_out : word_wo_prefix;
	
	// by now word is 98 digits
	diff_word #(.N(N-2)) diff_word0 (
		.clk(clk),
		.rst(rst),
		.word_in(word_after_restore),
		.word_out(word_1st_diff)
	);
		
	reverse_word #(.N(N-2)) reverse_word0 (
		.clk(clk),
		.rst(rst),
		.word_in(word_1st_diff),
		.word_out(reversed_word_out)
	);

	assign word_reversed = reverse_needed ? reversed_word_out : word_1st_diff;
			
	remove_y #(.N(N-2),.M(M)) remove_y0 (
		.clk(clk),
		.rst(rst),
		.word_in(word_reversed),
		.word_in_len(word_in_len),
		.word_out(word_wo_y)
	);
		
	// by now word is 84 digits
	diff_word #(.N(M)) diff_word1 (
		.clk(clk),
		.rst(rst),
		.word_in(word_wo_y),
		.word_out(word_2nd_diff)
	);
	
	rll_restore #(.M(M)) rll_restore0 (
		.clk(clk),
		.rst(rst),
		.word_in(word_2nd_diff),
		.word_out(word_no_rll),
		.word_out_len(word_len)
	);	
	
	assign final_correct=(final_word_check==word_no_rll);
	
endmodule



