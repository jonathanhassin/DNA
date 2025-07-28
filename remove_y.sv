module remove_y #(
	parameter N = 98, // Number of digits in the word
	parameter M = N-13 // Number of digits in the final word
)(
	input clk,
	input rst,
	input  [2*N-1:0] word_in,  // Input word (N digits, 2 bits each), word after differential word
	input [6:0] word_in_len,
	output logic [2*M-1:0] word_out  // Output sword after changes. The word shrinks
);   

	logic [2*M-1:0] word; 
	integer i;
		
	always_ff @(posedge clk or posedge rst) begin
		if (rst) word_out=0;
		else word_out=word; 	
	end
		
	always_comb begin
		word[169:108]=word_in[191:130];
		word[107:18]=word_in[123:34];		
		word[17:0]=word_in[27:10];
	end
	
endmodule
