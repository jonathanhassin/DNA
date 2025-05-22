
module reverse_word #(
    parameter N = 4  // Number of digits in the word (default to 4)
)(
	input clk,
	input rst,
    input  [2*N-1:0] word_in,  // Input word (N digits, 2 bits each)
    output logic [2*N-1:0] word_out  // Output reversed word (N digits, 2 bits each)
);
	
	logic [2*N-1:0] word;
    integer i;
    
	always_ff @(posedge clk or posedge rst) begin
		if (rst) 
			word_out=0;
		else
			word_out=word;
	end
	
	always_comb begin
        for (i = 0; i < N; i = i + 1) begin : reverse_loop
            word[2*i +: 2] = reverse_digit(word_in[2*i +: 2]);
        end
    end

    function [1:0] reverse_digit;
        input [1:0] digit;
        case (digit)
            2'b00: reverse_digit = 2'b01;  // 4/0 -> 1
            2'b01: reverse_digit = 2'b00;  // 1 -> 4/0
            2'b10: reverse_digit = 2'b11;  // 2 -> 3
            2'b11: reverse_digit = 2'b10;  // 3 -> 2
        endcase
    endfunction

endmodule
