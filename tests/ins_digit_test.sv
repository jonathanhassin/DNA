module ins_digit_test;

    parameter N = 6;

	logic clk;
	logic rst;
    logic [2*N-1:0] word_in;
    logic [6:0] missing_index;
	logic [1:0] missing_digit;
	logic [2*(N+1)-1:0] word_out;

	ins_digit #(.N(N)) uut (
		.clk(clk),
		.rst(rst),
		.word_in(word_in),
        .missing_index(missing_index),
        .missing_digit(missing_digit),
		.word_out(word_out)
    	);

	initial begin
		clk=0;
		forever #5 clk =~clk;
	end
	
    initial begin
        
        word_in = 12'b10_11_11_00_00_01;  // [2,3,3,0,0,1]
		missing_index[6:0] = 7'b100;
		missing_digit = 2'b10;
        #10;
        $display("Input: %b, missing_index: %b, missing_digit: %b, Output: %b", word_in,missing_index,missing_digit, word_out);

		$finish;
    end

endmodule
