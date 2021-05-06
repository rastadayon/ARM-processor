`include "Constants.v"

module IF_Stage_Reg (
	clk, 
	rst, 
	freeze, 
	flush,
	pc_in, 
	instruction_in,
	pc_out, 
	instruction_out
);
input clk, rst, freeze, flush;
input[`ADDRESS_LEN - 1:0] pc_in, instruction_in;
output[`ADDRESS_LEN - 1:0] pc_out, instruction_out;

Register #(`ADDRESS_LEN) pc_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(flush), .inp(pc_in), .out(pc_out));
Register #(`ADDRESS_LEN) instruction_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(flush), .inp(instruction_in), .out(instruction_out));

endmodule

