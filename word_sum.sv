module word_sum #(
    parameter N = 4  // Number of digits in the word (default to 4)
)(
    input  [2*N-1:0] word_in,  // Input word (N digits, 2 bits each)
    output reg [9:0] sum_out   // Output sum (variable size assuming N<100)
);

    integer i;
    always @(*) begin
        sum_out = word_in[1:0];  // Start with the first digit
        for (i = 1; i < N; i = i + 1) begin
            sum_out = sum_out + word_in[2*i +: 2];  // Accumulate sum
        end
    end

endmodule
