/*
 *
 */

`define number_of_bits 16
`define n `number_of_bits-1
`define matrix 25
`define m `matrix-1

module rgb_led_matrix(
	input 		 clk,
	input	     rst_n,
	output[`m:0] r,
	output[`m:0] g,
	output[`m:0] b,
	output[2:0]	 leds
);

	reg[`m:0] cnt;
	reg[1:0]  dff;
	wire 	  rising_edge;
	reg[2:0]  RGB_FSM;
	parameter R=0, G=1, B=2;
	reg[`m:0] red;
	reg[`m:0] green;
	reg[`m:0] blue;

	initial
	begin
		cnt 		= 0;
		rising_edge = 0;
	end

	always @(posedge clk)
	begin: counter
		if(rst_n == 'b0)
		begin
			cnt = 0;
			dff = 0;
		end
		else
		begin
			cnt    = cnt + 1;
			dff[1] = dff[0];
			dff[0] = cnt[`n];
		end
	end
	assign rising_edge = ((dff[1]) & ~(dff[0]));	// detect the rising edge of the 16th bit of the counter

	always @(posdege clk)
	begin: rgb_colors
		if(rst_n == 'b0)
		begin
			red 	= 0;
			green   = 0;
			blue 	= 0;
			RGB_FSM = R;
		end
		else if(rising_edge)
		begin
			case(state)
				R:
					red = red + 1;
					if(cnt == 'b1111111111111111111111111)
					begin
						red 	= 0;
						state = G;
					end
				G:
					green = green + 1;
					if(cnt == 'b1111111111111111111111111)
					begin
						green = 0;
						state = B;
					end
				B:
					blue = blue + 1;
					if(cnt == 'b1111111111111111111111111)
					begin
						blue  = 0;
						state = R;
					end
			endcase
		end
	end

	assign leds[2:0] = cnt[`m:`m-2];
	assign r = red;
	assign g = green;
	assign b = blue;

endmodule
