module rll_restore #(
    parameter M = 20 // N0umber of digits in the word (default to 87)
)(
	input clk,
	input rst,
    input [M*2-1:0] word_in,  // Input word (M digits, 2 bits each), word after differential word
    output logic [M*2-1:0] word_out,  // Output sword after changes. The word shrinks
	output logic [6:0] output_len
);   
	logic [M*2-1:0] word; //working on this duplicate
	logic [M*2-1:0] temp_word; //temporary word to add the encrypted part
    logic [7:0] index;
	logic [6:0] first_bit;
    integer i;
	
	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin
			word_out=0; 
			output_len=0;
		end 
		else begin
			word_out=word>>first_bit; //remove unnecessary bits from output word
			output_len=(M*2-first_bit)/2; //output word length in digits
		end
	end
	
    always_comb begin
		first_bit = 0; // current length of the word	
		word=word_in; //initializing the word we work on
        while (word[first_bit +: 2] !== 2'b0) begin
			index=M*2-1-(to_base_10(word[first_bit+2 +: 8])*2);  //defining index. extract index from word -> decimal from base4-> bits instead of digits -> change to be index from beginning (from [0]) 
			for (i=M*2-1;i>index;i--)	begin
				temp_word[i]=word[i];
			end
			temp_word[index -: 8]=8'b0; //adding the zeros
			for (i=index-8;i>first_bit+1;i--) begin
				temp_word[i]=word[i+8];
			end
			word=temp_word;
			first_bit=first_bit+2;
		end
		first_bit=first_bit+2;
    end
	
endmodule

function int to_base_10 (input logic [7:0] word_in);
		
		return (word_in[7:6]<<6) + (word_in[5:4]<<4) + (word_in[3:2]<<2) + (word_in[1:0]);
	
endfunction
