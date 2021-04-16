`include "Constants.v"

module ARM_Module(
	clk, 
	rst
);

input clk, rst;

wire freeze, branch_taken, flush;
wire[`ADDRESS_LEN - 1:0] branch_addr, if_stage_pc_out,
	if_stage_instruction_out, id_stage_pc_out, ex_stage_pc_out,
	mem_stage_pc_out, wb_stage_pc_out;

assign freeze = 1'b0;
assign flush = 1'b0;
assign branch_taken = 1'b0;
assign branch_addr = `ADDRESS_LEN'b0;

IF_Stage_Module if_stage_module(
	.clk(clk),
	.rst(rst),
	.freeze(freeze),
	.flush(flush),
	.branch_taken(branch_taken),
	.branch_addr(branch_addr),
	.pc(if_stage_pc_out),
	.instruction(if_stage_instruction_out)
);

ID_Stage_Module id_stage_module (
	.clk(clk),
    .rst(rst),
    .freeze(freeze),
    .flush(flush),
    .pc_in(if_stage_pc_out),
    .pc_out(id_stage_pc_out) 
);

EX_Stage_Module ex_stage_module (
    .clk(clk),
    .rst(rst),
    .freeze(freeze),
    .pc_in(id_stage_pc_out),
    .pc_out(ex_stage_pc_out) 
);

MEM_Stage_Module mem_stage_module (
    .clk(clk),
    .rst(rst),
    .freeze(freeze),
    .pc_in(ex_stage_pc_out),
    .pc_out(mem_stage_pc_out)
);

WB_Stage wb_stage (
    .clk(clk),
    .rst(rst),
    .pc_in(mem_stage_pc_out),
    .pc_out(wb_stage_pc_out)
);



endmodule;