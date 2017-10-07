/*
 * Title: CROMATIC RGB LED
 * File: rgb_led_cromatic.v
 * Name: Javier Jimenez
 * Date: 05.10.2017
 * Desc: Program that generates different combination
 * 			 of colors in the RGB led matrix pcb.
 *
 */

module rgb_led_cromatic(
	input 				clk,
	input					reset_n,
	output[24:0]	R,
	output[24:0]	G,
	output[24:0]	B
);

	wire r_edg;
	wire f_edg;
  wire r_pwm;
	wire g_pwm;
	wire b_pwm;

	debouncer debouncer_1(
		.clk(clk),
		.reset_n(reset_n),
		.r_edge(r_edg),
		.f_edge(f_edg)
	);

	pwm pwm_1(
		.clk(clk),
		.f_edge(f_edg),
		.R_pwm_out(r_pwm),
		.G_pwm_out(g_pwm),
		.B_pwm_out(b_pwm),
	);

	cromatic cromatic_1(
		.R_pwm_input(r_pwm),
		.G_pwm_input(g_pwm),
		.B_pwm_input(b_pwm),
		.R(R),
		.G(G),
		.B(B)
	);

endmodule
