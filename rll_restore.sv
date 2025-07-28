module rll_restore #(
	parameter M = 20 // Number of digits in the word (default to 20)
)(
	input clk,
	input rst,
	input [M*2-1:0] word_in,  // Input word (M digits, 2 bits each)
	output logic [M*2-1:0] word_out,  // Output word after changes
	output logic [6:0] word_out_len
);   
	// Internal signals
	logic [M*2-1:0] word;        // Working copy of word
	logic [M*2-1:0] temp_word;   // Temporary word for modifications
	logic [7:0] index;           // Index in bits
	logic [7:0] index_bits;      // Extracted index bits
	logic [6:0] first_bit;       // Tracks position in word
	integer i, k;
	
	// Helper function: convert 4 base-4 digits to base-10
	function automatic int to_base_10 (input logic [7:0] word_in);
		return (word_in[7:6] << 6) + (word_in[5:4] << 4) + (word_in[3:2] << 2) + word_in[1:0];
	endfunction

	// Sequential logic for outputs
	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin
			word_out = 0; 
			word_out_len = 0;
		end 
		else begin
			word_out = word >> first_bit; // Remove unnecessary bits
			word_out_len = (M*2 - first_bit) >> 1; // Output word length in digits
		end
	end

	// Combinational logic for processing the word
	always_comb begin
		// Initialize to prevent latch inference
		first_bit = 0;
		word = word_in;
		temp_word = word_in;

		// Main loop: process each block up to M times
		for (k = 0; k < M; k++) begin
			// Exit if the current 2-bit digit is 00
			if (((word >> first_bit) & 2'b11) == 2'b00) begin
				first_bit = first_bit + 2; // Include the 2 bits for '00'
				break;
			end

			// Extract index from next 8 bits
			index_bits = (word >> (first_bit + 2)) & 8'hFF;
			index = to_base_10(index_bits);
			index = (M*2 - 1 - (index * 2)); // Convert to bit index

			// Copy higher bits unchanged
			for (i = M*2-1; i >= 0; i--) begin
				if (i > index) begin
					temp_word[i] = word[i];
				end
			end

			// Zero out 4 bits at position index
			for (i = 0; i < 4; i++) begin
				if ((index >= i) && ((index - i) < M*2))
					temp_word[index - i] = 1'b0;
			end

			// Shift lower bits down by 4
			for (i = M*2-1; i >= 0; i--) begin
				if ((i <= index-4) && (i > first_bit+1)) begin
					temp_word[i] = (word >> (i+4)) & 1'b1;
				end
			end

			// Update working word and move to next block
			word = temp_word;
			first_bit = first_bit + 6; // Advance past current block
		end
	end

endmodule

