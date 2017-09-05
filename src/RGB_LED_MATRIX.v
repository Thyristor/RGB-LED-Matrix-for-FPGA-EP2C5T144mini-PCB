/*
 *
 *
 *
 */

`define n_number_of_leds 25
`define n 					 `n_number_of_leds-1
`define m_number_of_bits 26
`define m 					 `m_number_of_bits-1
`define k 					 75-1

module RGB_LED_MATRIX(
	input 			main_clk,
	input				reset,
	output[`n:0]	R,
	output[`n:0]	G,
	output[`n:0]	B,
	output[1:0]		cnt_leds
);

	reg[`m:0] cnt;
	reg[`m:0] cnt2;
	reg[`k:0] sum;
	reg[2:0]  RGB_FSM;
	parameter RED = 0, GREEN = 1, BLUE = 2, CIAN = 3, MAGENTA = 4, YELLOW = 5, BLACK = 6;
	reg[`n:0] r;
	reg[`n:0] g;
	reg[`n:0] b;	
	
	initial
	begin
		cnt  = 0;
		cnt2 = 0;
		sum  = 0;
		//r 	 = 'h1FFFFFE;
		//g 	 = 'h1FFFFFD;
		//b 	 = 'h1FFFFFB;
		r = 'b1111111111111111111111110;
		g = 'b1111111111111111111111111;
		b = 'b1111111111111111111111111;		
		RGB_FSM = RED;
	end
	
	always @(posedge main_clk)
	begin: contador2
		if(reset == 'b0)
			cnt2 = 0;
		else
			cnt2 = cnt2 - 1;
	end
	
	always @(posedge main_clk)
	begin: contador
		if(reset == 'b0)
		begin
			cnt = 0;
			sum = 0;
			r   = 'b1111111111111111111111110;
			g 	 = 'b1111111111111111111111111;
			b 	 = 'b1111111111111111111111111;
			RGB_FSM = RED;
//			r 	 = 'h1FFFFFE;
//			g 	 = 'h1FFFFFD;
//			b 	 = 'h1FFFFFB;
		end
		else if(cnt <= 'b10010000000000000000000000)
		begin 
			cnt = cnt + 1;
		end
		else
		begin
			cnt = 0;
			case(RGB_FSM)
				RED: begin
					r = 0;				// ON
					g = 'h1FFFFFF;		// OFF
					b = 'h1FFFFFF;		// OFF
					RGB_FSM = RGB_FSM + 1;
				end
				GREEN: begin
					r = 'h1FFFFFF;		// OFF
					g = 0;				// ON
					b = 'h1FFFFFF;		// OFF
					RGB_FSM = RGB_FSM + 1;
				end
				BLUE: begin
					r = 'h1FFFFFF;		// OFF
					g = 'h1FFFFFF;		// OFF
					b = 0;				// ON
					RGB_FSM = RGB_FSM + 1;
				end
				CIAN: begin
					r = 'h1FFFFFF;		// OFF
					g = 0;				// ON
					b = 0;				// ON
					RGB_FSM = RGB_FSM + 1;
				end
				MAGENTA: begin
					r = 0;				// ON
					g = 'h1FFFFFF;		// OFF
					b = 0;				// ON
					RGB_FSM = RGB_FSM + 1;
				end
				YELLOW: begin
					r = 0;				// ON
					g = 0;				// ON
					b = 'h1FFFFFF;		// OFF
					RGB_FSM = RGB_FSM + 1;
				end
				default: begin
					r = 'h1FFFFFF;		// OFF
					g = 'h1FFFFFF;		// OFF
					b = 'h1FFFFFF;		// OFF
					RGB_FSM = RED;
				end
			endcase
//			r = {r[`n-1:0], b[`n]};//r = {r[`n-1:0], b[`n] ^ r[13] ^ g[15]};
//			g = {g[`n-1:0], r[`n]};
//			b = {b[`n-1:0], g[`n]};
		end
	end
	
	assign R = r;
	assign G = g;
	assign B = b;
	assign cnt_leds[0] = cnt2[`m];
	assign cnt_leds[1] = cnt2[`m-1];

//	assign R = sum[74:50];
//	assign G = sum[49:25];
//	assign B = sum[24:0];

endmodule
