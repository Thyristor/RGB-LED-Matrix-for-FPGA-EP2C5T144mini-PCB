/*
 * Title: CROMATIC RGB LED
 * File: cromatic.v
 * Name: Javier Jimenez
 * Date: 05.10.2017
 * Desc: Program that generates different combination
 * 		of colors in the RGB led matrix pcb.
 *			It has an input button that makes the RGB leds
 * 		to change the color.
 */

`define n 25

module cromatic(
	input 			clk,
	input				f_edge,
	input 			pwm_input,
	input 			up_down,
	output[`n-1:0]	R,
	output[`n-1:0]	G,
	output[`n-1:0]	B
);

	reg[2:0]  RGB_FSM;
	parameter RED 	 	= 0, 
				 GREEN 	= 1, 
				 BLUE  	= 2, 
				 CIAN  	= 3, 
				 MAGENTA = 4, 
				 YELLOW  = 5, 
				 BLACK   = 6;

	reg[`n-1:0] r;
	reg[`n-1:0] g;
	reg[`n-1:0] b;

	wire[`n-1:0] pwm;

	/* Give initial conditions */
	initial
	begin
		RGB_FSM = RED;
	end

	always @(posedge clk)
	begin: finite_state_machine
		if(1'b1 == f_edge)
		begin
			RGB_FSM = RGB_FSM + 1;
			if(7 == RGB_FSM)
				RGB_FSM = RED;
		end
		else
		begin
			case(RGB_FSM)
				RED: begin
					r = 0;				// ON
					g = 'h1FFFFFF;		// OFF
					b = 'h1FFFFFF;		// OFF
				end
				GREEN: begin
					r = 'h1FFFFFF;		// OFF
					g = 0;				// ON
					b = 'h1FFFFFF;		// OFF
				end
				BLUE: begin
					r = 'h1FFFFFF;		// OFF
					g = 'h1FFFFFF;		// OFF
					b = 0;				// ON
				end
				CIAN: begin
					r = 'h1FFFFFF;		// OFF
					g = 0;				// ON
					b = 0;				// ON
				end
				MAGENTA: begin
					r = 0;				// ON
					g = 'h1FFFFFF;		// OFF
					b = 0;				// ON
				end
				YELLOW: begin
					r = 0;				// ON
					g = 0;				// ON
					b = 'h1FFFFFF;		// OFF
				end
				default: begin
					r = 'h1FFFFFF;		// OFF
					g = 'h1FFFFFF;		// OFF
					b = 'h1FFFFFF;		// OFF
				end
			endcase
		end
	end

	assign pwm[`n-1:0] = {`n{pwm_input}};

	assign R = r | pwm;
	assign G = g | pwm;
	assign B = b | pwm;

endmodule
