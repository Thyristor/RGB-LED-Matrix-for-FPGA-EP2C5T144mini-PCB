/*
 * Title: SHIFT REGISTER
 * File: shift.v
 * Name: Javier Jimenez
 * Date: 30.09.2017
 * Desc: Program that shift a series of registers
 *			putting the result into an LED
 *
 */
 
`define k 			75

module shift(
	input 			clk,
	input				f_edge,
	input				r_edge,
	output[24:0]	R,
	output[24:0]	G,
	output[24:0]	B,
	output[1:0]		led_out
);

	reg[`k-1:0] cnt;
	wire rising_edge;
	wire falling_edge;
	
	initial
	begin
		cnt = 0;
		cnt = ~cnt;
		cnt =  cnt - 1;
	end

	always @(posedge clk)
	begin: counter
		if(1'b1 == falling_edge)
		begin
			cnt 	 <= cnt << 1;
			cnt[0] <= cnt[`k-1];
		end
	end
	
	assign R = cnt[24:0];
	assign G = cnt[49:25];
	assign B = cnt[`k-1:50];
	assign led_out[0] = ~rising_edge;
	assign led_out[1] = ~falling_edge;
	
	assign rising_edge  = r_edge;
	assign falling_edge = f_edge;
	
endmodule