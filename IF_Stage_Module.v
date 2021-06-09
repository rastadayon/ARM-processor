`include "Constants.v"
`timescale 1ns/1ns

module IF_Stage_Module (
	clk, 
	rst, 
	freeze,
	flush, 
	branch_taken, 
	branch_addr,
	pc, 
	instruction
);
input clk, rst, freeze, branch_taken, flush; 
input[`ADDRESS_LEN - 1 : 0] branch_addr;

output[`ADDRESS_LEN - 1 : 0] pc;
output[`INSTRUCTION_LEN - 1 : 0] instruction;

wire [`ADDRESS_LEN - 1 : 0] if_stage_pc_out;
wire [`INSTRUCTION_LEN - 1 : 0] if_stage_instruction_out;

IF_Stage if_stage(
	.clk(clk),
	.rst(rst),
	.freeze(freeze),
	.branch_taken(branch_taken),
	.branch_addr(branch_addr),
	.pc(if_stage_pc_out),
	.instruction(if_stage_instruction_out)
);
IF_Stage_Reg IF_stage_reg(
	.clk(clk),
	.rst(rst),
	.freeze(freeze),
	.flush(flush),
	.pc_in(if_stage_pc_out),
	.instruction_in(if_stage_instruction_out),
	.pc_out(pc),
	.instruction_out(instruction)
);
endmodule
