module check_reverse_test;
   
    parameter N=4;
    reg  [2*N-1:2*(N-1)-2] word_in;  // Input word (N digits, 2 bits each)
    wire reverse_needed; // Indicates if reversal is needed
    wire in_prefix;       // Indicates if deletion occurred in suffix

	
	check_reverse #(.N(N)) uut (
		.word_in(word_in),
		.reverse_needed(reverse_needed),
		.in_prefix(in_prefix)
		);

    initial begin
        
        word_in = 4'b01_00; // [1,4...]
	#50;
	$display("Input: %b, reverse needed?: %b, in prefix?: %b", word_in, reverse_needed,in_prefix);
		
	word_in = 4'b10_11; // [2,3...]
	#50;
	$display("Input: %b, reverse needed?: %b, in prefix?: %b", word_in, reverse_needed,in_prefix);

	word_in = 4'b01_10; // [1,2...]
	#50;
	$display("Input: %b, reverse needed?: %b, in prefix?: %b", word_in, reverse_needed,in_prefix);

	word_in = 4'b10_10; // [2,2...]
	#50;
	$display("Input: %b, reverse needed?: %b, in prefix?: %b", word_in, reverse_needed,in_prefix);

	word_in = 4'b11_10; // [3,2...]
	#50;
	$display("Input: %b, reverse needed?: %b, in prefix?: %b", word_in, reverse_needed,in_prefix);

	word_in = 4'b00_10; // [4,2...]
	#50;
	$display("Input: %b, reverse needed?: %b, in prefix?: %b", word_in, reverse_needed,in_prefix);

    end

endmodule
