`include "Constants.v"
`timescale 1ns/1ns

module Adder (
	inp1,
	inp2,
	out
);
	parameter n = `ADDRESS_LEN;
	input signed [n-1:0]inp1,inp2;
	output signed [n-1:0]out;

	assign out = inp1+inp2;
    
endmodule
