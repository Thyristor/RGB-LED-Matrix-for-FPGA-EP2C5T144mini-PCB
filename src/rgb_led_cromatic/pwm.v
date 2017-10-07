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
	output  	pwm_out,
	output  	up_down
);

	reg[12:0] cnt_pwm;
	reg[12:0] mod_pwm;
	wire pwm;
	wire flg;

	/* Give initial conditions */
	initial
	begin
		cnt_pwm = 0;
		mod_pwm = 0;
	end

	/*
		PWM counter
		clk = 50 MHz / 5000 counts = 10 kHz <-- cnt_pwm
	*/
	always @(posedge clk)
	begin: pwm_counter
		if(5000 <= cnt_pwm)
			cnt_pwm = 0;
		else
			cnt_pwm = cnt_pwm + 1;
	end

	/* PWM comparator */
	always @(posedge clk)
	begin: pwm_comparator
		if(0 == cnt_pwm)
		begin
			if(1 == flg)
				mod_pwm = mod_pwm + 1;
			else
				mod_pwm = mod_pwm - 1;
		end
	end

	assign flg = (mod_pwm > 4000) ? (1'b0) : ((mod_pwm < 1) ? (1'b1) : (flg));	// If it rises 4000 counts flag = 0 else if it equals to zero flag = 1 else, maintains its value
	assign pwm = (mod_pwm < cnt_pwm) ? (1'b1) : (1'b0); // If its less than counter pwm = 1 else pwm = 0

	assign pwm_out = pwm;
	assign up_down = flg;

endmodule
