
module find_index #(
    parameter N=100,
    parameter A=30,
    parameter B=27
)(
    input clk,
    input rst,
    input [2*(N-1)-1:0] word_in,
    input [2*(N-1)-1:0] diff_word,
    input [9:0] diff_word_sum,
    input [13:0] inv_syn,
    logic reverse_needed,
    
    output logic [6:0] missing_index,
    output logic [1:0] missing_digit
);

    logic [9:0] sum_yd;
    logic [8:0] deltaj;
    logic [6:0] j;
    logic signed [13:0] delta;
    logic [2:0] gamma;
    integer a, t1, t2, t3, t4, t6, t7, i;

    logic [1:0] diff_val, word_val;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            missing_index = 7'b0;
            missing_digit = 2'b00;
        end 
        else begin
            missing_index = j;
            missing_digit = gamma[1:0];
        end
    end
    
    always_comb begin
        if (reverse_needed) begin
            t1 = (B - inv_syn) % 4;
            t2 = (B - inv_syn);
            t3 = (t2 % (4*N)) + (4*N);
        end
        else begin
            t1 = (A - inv_syn) % 4;
            t2 = (A - inv_syn);
            t3 = (t2 % (4*N)) + (4*N);
        end
        gamma = t1;
        delta = t3;

        if (gamma == 0) gamma = 3'b100; // gamma = 4

        if (delta < diff_word_sum) begin
            // case 2a
            j = N - 2;
            sum_yd = 0;
            for (int k = 0; k < N; k++) begin
                if (sum_yd >= delta) break;

                diff_val = (diff_word >> (2*j)) & 2'b11;
                if (diff_val == 0) 
                    sum_yd = sum_yd + 4;
                else 
                    sum_yd = sum_yd + diff_val;

                j--;
            end
            j = N - j - 3;
        end 
        else if (delta >= diff_word_sum + 4) begin
            // case 2b
            sum_yd = diff_word_sum;
            i = N;
            j = 0;
            for (int k = 0; k < N; k++) begin
                if (i < 2) break;

                word_val = (word_in >> (2*j)) & 2'b11;
                if (word_val == 0) 
                    a = gamma - 4;
                else 
                    a = gamma - word_val;

                if (a <= 0) a += 4;

                t4 = (N - i) * 4;

                diff_val = (diff_word >> (2*j)) & 2'b11;
                if (diff_val == 0) 
                    t6 = 4;
                else 
                    t6 = diff_val;

                deltaj = a + sum_yd + t4;
                if (delta == deltaj) break;

                sum_yd -= t6;
                j++;
                i--;
            end
            j = N - j - 1;
        end 
        else begin
            // case 2c
            j = N - 1;
        end
    end

endmodule
