module handle_prefix #(
	parameter N=100;
)(
	input clk,
	input rst,
    input  [2*N-1:0] word_in,  // Input word (N digits, 2 bits each)
    output logic reverse_needed, // Indicates if reversal is needed
    output logic in_prefix,       // Indicates if deletion occurred in suffix
	output logic [2*(N-2)-1:0] word_out
);
	logic in_prefix0,reverse_needed0;
	logic word [2*(N-2)-1:0];
		
	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin 
			reverse_needed=0;
			in_prefix=0;
			word_out=0;
		end
		else begin 
			reverse_needed=reverse_needed0;
			in_prefix=in_prefix0;
			word_out=word;
		end
	end

    always_comb begin       
        // Check for suffix '14' (01 00 in binary)
        if (word_in[2*N-1 -: 4] == 4'b0100) begin  
			reverse_needed0 = 0;
            in_prefix0 = 0;
			word=word_in[2*(N-2)-1:0];
        
        // Check for corrupted prefix  '1' or '4' (01 or 00 in binary)
        end else if (word_in[2*N-1 -: 2] == 2'b01 || word_in[2*N-1 -: 2] == 2'b00) begin
            reverse_needed0 = 0;
            in_prefix0 = 1;
			word=word_in[2*(N-1)-1:2];
		
        // Check for prefix '23' (1011 in binary)
        end else if (word_in[2*N-1 -: 4] == 4'b1011) begin  
            reverse_needed0 = 1;
	        in_prefix0 = 0;
			word=word_in[2*(N-2)-1:0];
        
        // Prefix corrupted and reverse needed
        end else begin
            in_prefix0 = 1;
            reverse_needed0 = 1;
			word=word_in[2*(N-1)-1:2];
        end
    end

endmodule
