module insert_digit #(
    parameter N = 6  // Number of digits in the word (default to 4)
)(
	input clk,
	input rst,
    input [2*(N-1)-1:0] word_in,  // Input word (N digits, 2 bits each)
    input [6:0] missing_index_ltr,
	input [1:0] missing_digit,
	output logic  [2*N-1:0] word_out // Output word (N+1 digits, 2 bits each)
);

	logic [2*N-1:0] word;
	logic [6:0] missing_index_rtl;

	integer signed k,l,i,j;
	
	always_ff @(posedge clk or posedge rst) begin
		if (rst) 
			word_out=0;
		else 
			word_out=word;

	end

	always_comb begin

		missing_index_rtl=N-missing_index_ltr-1;
		i=N-1;
		j=i<<1;
		k=0;
		l=0;
		while(i>=$signed(missing_index_rtl)) begin
			word[j+2 +: 2]=word_in[j +: 2];
			i--;
			j-=2;
		end
		while(k<missing_index_rtl) begin
			word[l +: 2]=word_in[l +: 2];
			k++;
			l+=2;
		end
		word[missing_index_rtl*2 +:2]=missing_digit;
		
	end
	
endmodule
