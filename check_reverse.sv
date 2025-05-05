module check_reverse #(
    parameter N = 4  // Number of digits in the word (including suffix, default 6)
)(
    input  [N-1:N-4] word_in,  // Input word (N digits, 2 bits each)
    output reg reverse_needed, // Indicates if reversal is needed
    output reg in_prefix       // Indicates if deletion occurred in suffix
);

    always @(*) begin
        
        
        // Check for suffix '14' (01 00 in binary)
        if (word_in == 4'b0100) begin  
	    reverse_needed = 0;
            in_prefix = 0;
        
        // Check for prefix corruption '1' or '4' (01 or 00 in binary)
        end else if (word_in[3:2] == 2'b01 || word_in[3:2] == 2'b00) begin
            reverse_needed = 0;
            in_prefix = 1;
        
        // Check for suffix '23' (10 11 in binary)
        end else if (word_in == 4'b1011) begin  
            reverse_needed = 1;
	        in_prefix = 0;
        
        // Prefix corruption and reverse needed
        end else begin
            in_prefix = 1;
            reverse_needed = 1;
        end
    end

endmodule
