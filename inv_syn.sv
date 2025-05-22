module inv_syn #(
    parameter N = 6  // Number of digits in the word (default to 4)
)(
	input clk,
	input rst,
    input  [2*N-1:0] word_in,  // Input word (N digits, 2 bits each)
    output logic [13:0] sum_out  // Output sum (adjusted for larger values)
);
	logic [13:0] sum;
    integer i;
	
	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin 
			sum_out=0;
		end
		else begin 
			sum_out=sum;
		end
	end

    always_comb begin 
        sum = 0;  // Initialize sum to zero
        for (i = 0; i < N; i = i + 1) begin
			if (word_in[2*i +: 2]==2'b00) begin
				sum = sum + (4 * (i+1));  // Weighted sum calculation
			end
			else begin
				sum = sum + (word_in[2*i +: 2] * (i+1));  // Weighted sum calculation
			end 
		
        end
    end

endmodule
