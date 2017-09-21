/*
 *
 *
 *
 */

`define n 25
`define k 75

module shifter(
	input 			clk,
	input				button,
	output[`n-1:0]	R,
	output[`n-1:0]	G,
	output[`n-1:0]	B,
	output[1:0]		cnt_leds
);

	reg[26:0] 	 cnt;
	reg[`k-1:0]	 sum;

	/* Give initial conditions */
	initial
	begin
		cnt = 0;
		sum = {`k{1'b1}};
		sum[0] = 'b0;
	end

	always @(posedge clk)
	begin: shifter
		if(cnt <= 'b1000000000000000000000)
		begin
			cnt = cnt + 1;
		end
		else
		begin
			cnt = 0;
			sum[`k-1:1] = sum[`k-2:0];
			sum[0] = button;
		end
	end

	assign cnt_leds[0] =  button;
	assign cnt_leds[1] = ~button;

	assign B = sum[74:50];
	assign G = sum[49:25];
	assign R = sum[24:0];

endmodule
