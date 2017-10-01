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
	input 			clk,
	input				button,
	output[`n:0]	R,
	output[`n:0]	G,
	output[`n:0]	B,
	output[1:0]		cnt_leds
);

	reg[26:0] cnt;
	reg[12:0] cnt_pwm;
	reg[12:0] cmp_pwm;
	reg[2:0]  RGB_FSM;
	parameter RED = 0, GREEN = 1, BLUE = 2, CIAN = 3, MAGENTA = 4, YELLOW = 5, BLACK = 6;
	reg[`n:0] r;
	reg[`n:0] g;
	reg[`n:0] b;	
	reg[2:0] edge_detector;
	wire[`n:0] enable;
	wire flag;
	
	/* Give initial conditions */
	initial
	begin
		//r 	 = 'h1FFFFFE;
		//g 	 = 'h1FFFFFD;
		//b 	 = 'h1FFFFFB;
		r 		  = 'b1111111111111111111111110;
		g 		  = 'b1111111111111111111111111;
		b 		  = 'b1111111111111111111111111;
		cnt 	  = 0;
		cnt_pwm = 0;
		cmp_pwm = 0;
		edge_detector = 'b000;
		RGB_FSM = RED;
	end
	
	/* PWM counter */
	always @(posedge clk)
	begin: pwm_counter
		if(5000 <= cnt_pwm) // cnt_pwm --> 10 kHz
			cnt_pwm = 0;
		else
			cnt_pwm = cnt_pwm + 1;
	end
	
	/* PWM comparator */
	always @(posedge clk)
	begin: pwm_comparator
		if(0 == cnt_pwm)
		begin
			if(1 == flag)
				cmp_pwm = cmp_pwm + 1;
			else
				cmp_pwm = cmp_pwm - 1;
		end
	end
	
	/*
	always @(posedge cnt[24])
	begin: edge_detection
		cnt = cnt + 1;
		if('b1 == cnt[26])
		begin
			cnt = 0;
			r 	 = {r[`n-1:0], b[`n] ^ r[13] ^ g[15]};//r = {r[`n-1:0], b[`n] ^ r[13] ^ g[15]};
			g 	 = {g[`n-1:0], r[`n]};
			b 	 = {b[`n-1:0], g[`n]};
		end
		
		edge_detector[0] = ~button;
		edge_detector[1] =  edge_detector[0];
		edge_detector[2] = ~edge_detector[1] & edge_detector[0];
	end
	*/
	
	always @(posedge clk)
	begin: finite_state_machine
		if(button == 'b0)
		begin
			cnt = 0;
			r   = 'b1111111111111111111111110;
			g 	 = 'b1111111111111111111111111;
			b 	 = 'b1111111111111111111111111;
			RGB_FSM = RED;
//			r 	 = 'h1FFFFFE;
//			g 	 = 'h1FFFFFD;
//			b 	 = 'h1FFFFFB;
		end
		else if(cnt <= 'b11111111100000000000000000)
			cnt = cnt + 1;
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
	
	assign flag = (cmp_pwm >= 4000) ? ('b0) : ((cmp_pwm <= 0) ? ('b1) : (flag));
	assign enable = (cmp_pwm <= cnt_pwm) ? ('h1FFFFFF) : ('h0000000);
	
	assign R = r | enable;
	assign G = g | enable;
	assign B = b | enable;
	assign cnt_leds[0] = edge_detector[2];
	assign cnt_leds[1] = button;

//	assign R = sum[74:50];
//	assign G = sum[49:25];
//	assign B = sum[24:0];

endmodule
