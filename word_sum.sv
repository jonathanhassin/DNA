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
		if (rst) sum_out=0;
		else sum_out=sum;
	end

    always_comb begin 
        sum = 0;
        for (i = 0; i < N; i++) begin
            if (!word_in[2*i +: 2]) sum=sum+4;
			else sum = sum + word_in[2*i +: 2];
        end
    end

endmodule
