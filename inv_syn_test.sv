module inv_syn_test;


    parameter N = 6;

    reg  [2*N-1:0] word_in;
    wire [13:0] sum_out;

	inv_syn #(.N(N)) uut (
        .word_in(word_in),
        .sum_out(sum_out)
    	);


    initial begin
        
		word_in = 12'b01_10_11_01_10_11;  // [1, 2, 3, 1, 2, 3]
		#50;
		$display("Input: %b, Inv_Sum: %b", word_in, sum_out);

        word_in = 12'b10_11_11_00_00_01;  // [2, 3, 3, 0, 0, 1]
        #50;
        $display("Input: %b, Inv_Sum: %b", word_in, sum_out);

        word_in = 12'b00_11_10_01_00_11;  // [0, 3, 2, 1, 0, 3]
        #50;
        $display("Input: %b, Inv_Sum: %b", word_in, sum_out);

		$finish;
    end

endmodule
