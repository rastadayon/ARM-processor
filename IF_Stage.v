`include "Constants.v"

module IF_Stage (
	clk, 
	rst, 
	freeze, 
	branch_taken, 
	branch_addr,
	pc, 
	instruction
);
input clk, rst, freeze, branch_taken; 
input[`ADDRESS_LEN-1:0] branch_addr;
output[`ADDRESS_LEN-1:0] pc, instruction;

wire [`ADDRESS_LEN-1:0] mux_out, pc_reg_out, pc_adder_out, instruction_mem_out;

MUX_2 #(`ADDRESS_LEN) m1(
    .sel(branch_taken),
    .inp1(pc_adder_out),
    .inp2(branch_addr),
    .out(mux_out)
);

Register #(`ADDRESS_LEN) pc_register(
    .clk(clk),
    .rst(rst),
    .ld(~freeze),
    .clr(1'b0),
    .inp(mux_out),
    .out(pc_reg_out)
);

Adder #(`ADDRESS_LEN) pc_adder(
    .inp1(32'd4),
    .inp2(pc_reg_out),
    .out(pc_adder_out)
);

Instruction_Memory instruction_mem (
    .address(pc_reg_out),
    .out(instruction_mem_out)
);

assign instruction = instruction_mem_out;
assign pc = pc_adder_out;

endmodule
