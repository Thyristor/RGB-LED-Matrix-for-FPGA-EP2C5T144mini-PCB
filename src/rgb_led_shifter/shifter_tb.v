/*
 *
 *
 *
 */

`timescale 1ns/100ps

module shifter_tb;

reg clk;
reg button;
wire[24:0] R;
wire[24:0] G;
wire[24:0] B;
wire[1:0] led_out;

shifter shifter_1(.clk(clk), .button(button), .R(R), .G(G), .B(B), .led_out(led_out));

initial
begin
	$dumpfile("shifter.vcd");

	clk = 0;
	button = 0;
end

always
begin
	clk = ~clk; #10;
end

always
begin
	button = 0; #40;
	button = 1; #40;
	button = 0; #100;
	button = 1; #100;
	button = 0; #1000;
	button = 1; #1000;
	button = 0; #10000;
	button = 1; #10000;
	button = 0; #100000;
	button = 1; #100000;
	button = 0; #1000000;
	button = 1; #1000000;
	button = 0; #50000000;
	button = 1; #50000000;
end

endmodule