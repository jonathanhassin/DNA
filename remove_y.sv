module remove_y #(
	parameter N = 98 // Number of digits in the word
	parameter M = 84 // Number of digits in the final word
)(
	input  [2*N-1:0] word_in,  // Input word (N digits, 2 bits each), word after differential word
	output logic [2*M-1:0] word_out  // Output sword after changes. The word shrinks
);   
	always @(*) begin
		word_out[167:106]=word_in[191:130];
		word_out[105:16]=word_in[123:34];		
		word_out[15:0]=word_in[27:12];				
	end

endmodule