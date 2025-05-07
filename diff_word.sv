module diff_word #(
    parameter N = 8  // Number of digits in the word
)(
	input clk,
	input rst,
    input  [2*N-1:0] word_in,  // Input word (N digits, 2 bits each)
    output logic [2*N-1:0] word_out  // Output differential word (N digits, 2 bits each)
);
	logic [2*N-1:0] word;
    integer i;
	
	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin 
			word_out=0;
		end
		else begin 
			word_out=word;
		end
	end

    always_comb begin 
        word[2*N-1 -: 2] = word_in[2*N-1 -: 2];  // leftmost digit remains the same
        for (i = N-2; i >=0 ; i -= 1) begin : diff_loop
            word[2*i +: 2] = mod4_subtract(word_in[2*i +: 2], word_in[2*(i+1) +: 2]);
		end
    end

    function [1:0] mod4_subtract;
        input [1:0] current;
        input [1:0] previous;
        logic [2:0] diff;
        
        begin
            diff = {1'b0, current} - {1'b0, previous};  // Perform subtraction in 3 bits
            case (diff)
                3'b001, 3'b101: mod4_subtract = 2'b01;  // mod4(5) = 1
                3'b010, 3'b110: mod4_subtract = 2'b10;  // mod4(6) = 2
                3'b011, 3'b111: mod4_subtract = 2'b11;  // mod4(7) = 3
                default:        mod4_subtract = 2'b00;  // mod4(8) = 4 (0 in binary)
            endcase
        end
    endfunction

endmodule
