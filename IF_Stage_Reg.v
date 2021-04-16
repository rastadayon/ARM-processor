`include "Constants.v"

module IF_Stage_Reg (
	clk, 
	rst, 
	freeze, 
	flush,
	pc_in, 
	instruction_in,
	pc, 
	instruction
);

input clk, rst, freeze, flush;
input[`ADDRESS_LEN - 1:0] pc_in, instruction_in;
output wire[`ADDRESS_LEN - 1:0] pc, instruction;

Register #(`ADDRESS_LEN) pc_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(flush), .inp(pc_in), .out(pc));
Register #(`ADDRESS_LEN) instruction_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(flush), .inp(instruction_in), .out(instruction));

endmodule

