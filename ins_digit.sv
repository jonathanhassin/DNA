module ins_digit #(
    parameter N = 6  // Number of digits in the word (default to 4)
)(
	input clk,
	input rst,
    input [2*N-1:0] word_in,  // Input word (N digits, 2 bits each)
    input [6:0] missing_index,
	input [1:0] missing_digit,
	output logic  [2*(N+1)-1:0] word_out // Output word (N+1 digits, 2 bits each)
);

	logic [2*(N+1)-1:0] word;
	logic [6:0] missing_index_c;
	integer i,j;
	
	always_ff @(posedge clk or posedge rst) begin
		if (rst) word_out=0;
		else begin 
			word_out=word;
		end
	end

	always_comb begin
		missing_index_c=N-missing_index-1;
		for (i=0;i<=N+1;i++) begin
			j=i<<1;
			if (i<missing_index_c) 
				word[j +: 2]=word_in[j +: 2];
			else if (i==missing_index_c) 
				word[j +: 2]=missing_digit;
			else 
				word[j +: 2]=word_in[j-2 +: 2];
		end
	end
	
endmodule
