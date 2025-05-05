
module reverse_word #(
    parameter N = 4  // Number of digits in the word (default to 4)
)(
    input  [2*N-1:0] word_in,  // Input word (N digits, 2 bits each)
    output [2*N-1:0] word_out  // Output reversed word (N digits, 2 bits each)
);

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : reverse_loop
            assign word_out[2*i +: 2] = reverse_digit(word_in[2*i +: 2]);
        end
    endgenerate

    function [1:0] reverse_digit;
        input [1:0] digit;
        case (digit)
            2'b00: reverse_digit = 2'b01;  // 4/0 -> 1
            2'b01: reverse_digit = 2'b00;  // 1 -> 4/0
            2'b10: reverse_digit = 2'b11;  // 2 -> 3
            2'b11: reverse_digit = 2'b10;  // 3 -> 2
            default: reverse_digit = 2'bxx;
        endcase
    endfunction

endmodule
