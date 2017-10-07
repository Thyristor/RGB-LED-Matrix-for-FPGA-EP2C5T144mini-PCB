/*
 * Title: CHROMATIC RGB LED
 * File: chromatic.v
 * Name: Javier Jimenez
 * Date: 05.10.2017
 * Desc: Program that generates different combination
 * 			 of colors in the RGB led matrix pcb.
 *			 You can see the whole chromatic palette.
 */

`define n 25

module chromatic(
	input 					R_pwm_input,
	input 					G_pwm_input,
	input 					B_pwm_input,
	output[`n-1:0]	R,
	output[`n-1:0]	G,
	output[`n-1:0]	B
);

	wire[`n-1:0] r_pwm;
	wire[`n-1:0] g_pwm;
	wire[`n-1:0] b_pwm;

	assign r_pwm[`n-1:0] = {`n{R_pwm_input}};
	assign g_pwm[`n-1:0] = {`n{G_pwm_input}};
	assign b_pwm[`n-1:0] = {`n{B_pwm_input}};

	assign R = r_pwm;
	assign G = g_pwm;
	assign B = b_pwm;

endmodule
