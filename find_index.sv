module find_index #(
    parameter N=98,
	parameter A=24
)(
    input [2*N-1:0] word_in,
    input [8:0] word_sum,
	input [13:0] inv_syn,
	output logic [6:0] missing_index,
	output logic [1:0] missing_digit
);

    logic [8:0] sum_diff_word, logic [8:0] deltaj, logic [6:0] j , logic [13:0] delta, logic [2:0] gamma, logic [2:0] a;

	always_ff @(posedge clk or posedge rst) begin
		if (rst) missing_index=7'b0;
		else begin
				missing_index=j;
				missing_digit=gamma[1:0];
	end

	always_comb begin

		gamma = (A-inv_syn)%4;
		if (gamma==0) gamma=3'b100;
		delta = (A-inv_syn)%(4*N);
		
		//cases logic according to the article
		if (delta >= word_sum+4) begin
			// case 2a
			j=0;
			sum_diff_word = 0;
			while (sum_diff_word < delta) begin
				sum_diff_word += diff_word[j];
				j++;
			end
		end else if (delta < word_sum) begin
			// case 2b
			sum_diff_word = word_sum;
			j = N;
			while (j >= 0) begin
				a=gamma-word_in[j-2]
				if (a < 0) begin
					a+=4;
				end
				deltaj = a + sum_diff_word + (n-j) << 2;
				if (delta == deltaj) begin
					return j;
				end
				sum_diff_word -= diff_word[j-2];
				j--;
			end
		end else j=N;
		
	end

endmodule

