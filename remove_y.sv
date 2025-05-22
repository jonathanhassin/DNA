module remove_y #(
	parameter N = 128, // Number of digits in the word
	parameter M = 112 // Number of digits in the final word
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
		for (i=108;i<=2*N-27;i++) begin 
			word[i]=word_in[i+22];
			if (i==165) 
				i=165;
		end
		word[107:18]=word_in[123:34];		
		word[17:0]=word_in[27:10];
	end
	
endmodule