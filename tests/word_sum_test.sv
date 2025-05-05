module word_sum_test;
   
    parameter N=4;
    reg  [2*N-1:0] word_in;  // Input word (N digits, 2 bits each)
    wire [9:0] sum_out;
	
	word_sum #(.N(N)) uut (
		.word_in(word_in),
		.sum_out(sum_out)
		);

    initial begin
        
        word_in = 8'b01_00_00_10; // [1,0,0,2]
	#50;
	$display("Input: %b, Output: %b", word_in, sum_out);
		
	word_in = 8'b10_00_01_11; // [2,0,1,3]
	#50;
	$display("Input: %b, Output: %b", word_in, sum_out);

	word_in = 8'b11_01_10_10; // [3,1,2,2]
	#50;
	$display("Input: %b, Output: %b", word_in, sum_out);

    end

endmodule
