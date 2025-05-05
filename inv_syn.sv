module inv_syn #(
    parameter N = 6  // Number of digits in the word (default to 4)
)(
    input  [2*N-1:0] word_in,  // Input word (N digits, 2 bits each)
    output reg [13:0] sum_out  // Output sum (adjusted for larger values)
);

    integer i;
    always @(*) begin
        sum_out = 0;  // Initialize sum to zero
        for (i = 0; i < N; i = i + 1) begin
			if (word_in[2*i+1 : 2*i]==2'b00) begin
				sum_out = sum_out + (4 * (i+1));  // Weighted sum calculation
			end
			else begin
				sum_out = sum_out + (word_in[2*i+1 : 2*i] * (i+1));  // Weighted sum calculation
			end 
		
        end
    end

endmodule
