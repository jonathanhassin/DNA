module word_sum #(
    parameter N = 4  // Number of digits in the word (default to 4)
)(
	input clk,
	input rst,
    input  [2*N-1:0] word_in,  // Input word (N digits, 2 bits each)
    output logic [9:0] sum_out   // Output sum (variable size assuming N<100)
);
	logic [9:0] sum;
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
        sum = word_in[1:0];  // Start with the first digit
        for (i = 1; i < N; i = i + 1) begin
            sum = sum + word_in[2*i +: 2];  // Accumulate sum
        end
    end

endmodule
