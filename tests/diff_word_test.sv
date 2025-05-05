module differential_test;


    parameter N = 8;

    reg  [2*N-1:0] word_in;
    wire [2*N-1:0] word_out;

	differential #(.N(N)) uut (
        .word_in(word_in),
        .word_out(word_out)
    	);


    initial begin
        
        word_in = 16'b10_11_11_00_00_01_10_00;  // [2,3,3,0,0,1,2,0]
        #10;
        $display("Input: %b, Output: %b", word_in, word_out);

        word_in = 16'b00_11_10_01_00_11_10_01;  // [0, 3, 2, 1, 0, 3, 2, 1]
        #10;
        $display("Input: %b, Output: %b", word_in, word_out);

		$finish;
    end

endmodule
