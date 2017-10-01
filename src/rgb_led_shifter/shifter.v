/*
 *
 *
 */
 
module shifter(
	input 			clk,
	input				button,
	output[24:0]	R,
	output[24:0]	G,
	output[24:0]	B,
	output[1:0]		led_out
);

	wire r_edg;
	wire f_edg;

	debouncer debouncer_1(
		.clk(clk),
		.button(button),
		.r_edge(r_edg),
		.f_edge(f_edg)
	);

	shift shift_1(
		.clk(clk),
		.f_edge(f_edg),
		.r_edge(r_edg),
		.R(R),
		.G(G),
		.B(B),
		.led_out(led_out)
	);

endmodule