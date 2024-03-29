/*
 * Title: CROMATIC RGB LED
 * File: rgb_led_cromatic.v
 * Name: Javier Jimenez
 * Date: 05.10.2017
 * Desc: Program that generates different combination
 * 		of colors in the RGB led matrix pcb.
 *
 */

module rgb_led_matrix(
	input 				clk,
	input					button,
	output[24:0]	R,
	output[24:0]	G,
	output[24:0]	B
);

	wire r_edg;
	wire f_edg;
  wire pwm;
  wire up_dwn;

	debouncer debouncer_1(
		.clk(clk),
		.button(button),
		.r_edge(r_edg),
		.f_edge(f_edg)
	);

	pwm pwm_1(
		.clk(clk),
		.pwm_out(pwm),
		.up_down(up_dwn)
	);

	chromatic chromatic_1(
		.clk(clk),
		.f_edge(f_edg),
		.pwm_input(pwm),
		.up_down(up_dwn),
		.R(R),
		.G(G),
		.B(B)
	);

endmodule
