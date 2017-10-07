/*
 * Title: PWM
 * File: pwm.v
 * Name: Javier Jimenez
 * Date: 05.10.2017
 * Desc: Program that generates a pwm signal.
 *
 */


module pwm(
	input 	clk,
	input		f_edge,
	output  R_pwm_out,
	output  G_pwm_out,
	output  B_pwm_out
);

	reg[12:0] r_cnt_pwm;
	reg[13:0] g_cnt_pwm;
	reg[14:0] b_cnt_pwm;

	reg[12:0] r_mod_pwm;
	reg[13:0] g_mod_pwm;
	reg[14:0] b_mod_pwm;
	
	wire r_pwm;
	wire g_pwm;
	wire b_pwm;
	
	wire r_flg;
	wire g_flg;
	wire b_flg;

	/* Give initial conditions */
	initial
	begin
		r_cnt_pwm = 0;
		g_cnt_pwm = 0;
		b_cnt_pwm = 0;

		r_mod_pwm = 0;
		g_mod_pwm = 0;
		b_mod_pwm = 0;
	end
	
	/*
		PWM counter
		[12:0] 13 bits --> 2^13 = 8192 max counts
		clk = 50 MHz / 8192 counts = 6,1 kHz <-- r_cnt_pwm
	*/
	always @(posedge clk)
	begin: red_pwm_counter
		if(1'b1 == f_edge)
			r_cnt_pwm = 0;/*
		else if(8191 <= r_cnt_pwm)
			r_cnt_pwm = 0;*/
		else
			r_cnt_pwm = r_cnt_pwm + 1;
	end
	
	/*
		PWM counter
		[13:0] 14 bits --> 2^14 = 16384 max counts
		clk = 50 MHz / 16384 counts = 3 kHz <-- g_cnt_pwm
	*/
	always @(posedge clk)
	begin: green_pwm_counter
		if(1'b1 == f_edge)
			g_cnt_pwm = 0;/*
		else if(16383 <= g_cnt_pwm)
			g_cnt_pwm = 0;*/
		else
			g_cnt_pwm = g_cnt_pwm + 1;
	end
	
	/*
		PWM counter
		[14:0] 15 bits --> 2^15 = 32768 max counts
		clk = 50 MHz / 32768 counts = 1,5 kHz <-- b_cnt_pwm
	*/
	always @(posedge clk)
	begin: blue_pwm_counter
		if(1'b1 == f_edge)
			b_cnt_pwm = 0;/*
		else if(32767 <= b_cnt_pwm)
			b_cnt_pwm = 0;*/
		else
			b_cnt_pwm = b_cnt_pwm + 1;
	end

	/* Red PWM comparator */
	always @(posedge clk)
	begin: red_pwm_comparator
		if(1'b1 == f_edge)
			r_mod_pwm = 0;
		else if(0 == r_cnt_pwm)
		begin
			if(1'b1 == r_flg)
				r_mod_pwm = r_mod_pwm + 1;
			else
				r_mod_pwm = r_mod_pwm - 1;
		end
	end	
	
	/* Green PWM comparator */
	always @(posedge clk)
	begin: green_pwm_comparator
		if(1'b1 == f_edge)
			g_mod_pwm = 0;
		else if(0 == g_cnt_pwm)
		begin
			if(1'b1 == g_flg)
				g_mod_pwm = g_mod_pwm + 1;
			else
				g_mod_pwm = g_mod_pwm - 1;
		end
	end
	
	/* Blue PWM comparator */
	always @(posedge clk)
	begin: blue_pwm_comparator
		if(1'b1 == f_edge)
			b_mod_pwm = 0;
		else if(0 == b_cnt_pwm)
		begin
			if(1'b1 == b_flg)
				b_mod_pwm = b_mod_pwm + 1;
			else
				b_mod_pwm = b_mod_pwm - 1;
		end
	end

	assign r_flg = (8191  == r_mod_pwm) ? (1'b0) : ((0 == r_mod_pwm) ? (1'b1) : (r_flg)); // If it rises 8191  counts flag = 0, else if it equals to zero flag = 1, else maintains its value
	assign g_flg = (16383 == g_mod_pwm) ? (1'b0) : ((0 == g_mod_pwm) ? (1'b1) : (g_flg)); // If it rises 16383 counts flag = 0, else if it equals to zero flag = 1, else maintains its value
	assign b_flg = (32767 == b_mod_pwm) ? (1'b0) : ((0 == b_mod_pwm) ? (1'b1) : (b_flg)); // If it rises 32767 counts flag = 0, else if it equals to zero flag = 1, else maintains its value
	
	assign r_pwm = (r_mod_pwm < r_cnt_pwm) ? (1'b1) : (1'b0); // If its less than counter pwm = 1, else pwm = 0
	assign g_pwm = (g_mod_pwm < g_cnt_pwm) ? (1'b1) : (1'b0); // If its less than counter pwm = 1, else pwm = 0
	assign b_pwm = (b_mod_pwm < b_cnt_pwm) ? (1'b1) : (1'b0); // If its less than counter pwm = 1, else pwm = 0

	assign R_pwm_out = r_pwm;
	assign G_pwm_out = g_pwm;
	assign B_pwm_out = b_pwm;

endmodule
