/*
 * Title: DEBOUNCER/EDGE DETECTOR
 * File: debouncer.v
 * Name: Javier Jimenez
 * Date: 30.09.2017
 * Desc: Program that detects a pressing button
 * 		and avoids any bouncing on each key press.
 * 		Also can detect a rising or falling edges.
 *
 */

`define l 20

module debouncer(
	input 	clk,
	input		button,
	output	r_edge,
	output	f_edge
);

	reg[`l:0] cnt_40ms;
	reg[2:0]  dff_debouncer;
	reg[1:0]	dff_edge;
	wire 			ena_dff2_debouncer;
	wire 			ena_cnt_40ms;
	wire 			sclr;
	wire 			rising_edge;
	wire 			falling_edge;

	/* Initial statement, give initial values */
	initial
	begin
		cnt_40ms 			<= 0;
		dff_debouncer <= 3'b0;
		dff_edge		  <= 2'b0;
	end

	/* This block detects a pressing button and passes the value through D flipflops */
	always @(posedge clk)
	begin: debouncer
		dff_debouncer[0] <= button;
		dff_debouncer[1] <= dff_debouncer[0];
		if(1'b1 == ena_dff2_debouncer)
			dff_debouncer[2] <= dff_debouncer[1];
	end

	/*
	   This block is a counter that gives a ~40 ms delay
	   50 MHz clock source frequency = 20 ns period --> 40 ms delay / 20 ns period = 2.000.000 counts
	   2^n = 2.000.000 counts --> n = log(2.000.000) / log(2) = 20,9 bits = 21 bits aprox
	*/
	always @(posedge clk)
	begin: debouncer_counter
		if(1'b1 == sclr)
			cnt_40ms <= 0;
		else if(1'b1 == ena_cnt_40ms)
			cnt_40ms <= cnt_40ms + 1;
	end

	/* This block is a shift register made of D flipflops */
	always @(posedge clk)
	begin: edge_detector
		dff_edge[0] <= dff_debouncer[2];
		dff_edge[1] <= dff_edge[0];
	end

	assign sclr 		  		  	=  dff_debouncer[0] ^ dff_debouncer[1]; /* Any change on the input button from low to high or high to low produces a sync_clear in the counter */
	assign ena_dff2_debouncer =  cnt_40ms[`l]; 												/* The most significant bit of the counter is the enable of the D flipflop */
	assign ena_cnt_40ms 		  = ~cnt_40ms[`l]; 												/* The most significant bit of the counter, disables the counter */
	assign rising_edge  		  = ~dff_edge[1] &  dff_edge[0]; 					/* Rising edge detector */
	assign falling_edge 		  =  dff_edge[1] & ~dff_edge[0]; 					/* Falling edge detector */

	assign r_edge = rising_edge;
	assign f_edge = falling_edge;

endmodule
