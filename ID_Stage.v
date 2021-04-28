`include "Constants.v"

module ID_Stage (
	clk,
    rst,
	pc_in,
	instruction,
	wb_result,
	wb_en_in,
	wb_dest,
	hazard,
	sr,
	wb_en_out,
	mem_r_en,
	mem_w_en,
	b,
	s,
	exec_cmd,
	val_r_n,
	val_r_m,
	imm,
	shift_operand,
	signed_imm_24,
	dest,
	src_1,
	src_2,
	two_src,
    pc_out
);

    input clk, rst, wb_en_in, hazard;
    input [`ADDRESS_LEN - 1 : 0] pc_in;
    input [`INSTRUCTION_LEN - 1 : 0] instruction;
    input [`REGISTER_FILE_LEN - 1 : 0] wb_result;
    input [`REGISTER_FILE_ADDRESS_LEN - 1 : 0] wb_dest;
    input [`REGISTER_FILE_ADDRESS_LEN - 1 : 0] sr;

    output wb_en_out, mem_r_en, mem_w_en, b, s, imm, two_src;
    output[`EXEC_COMMAND_LEN - 1 : 0] exec_cmd;
    output[`REGISTER_FILE_LEN - 1 : 0] val_r_n, val_r_m;
    output[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] src_1, src_2, dest;
    output[`SHIFT_OPERAND_LEN - 1 : 0] shift_operand;
    output[`SIGNED_IMM_LEN - 1 : 0] signed_imm_24;
    output[`ADDRESS_LEN - 1 : 0] pc_out;

	// Wires :
	wire [`MODE_LEN - 1 : 0] inst_mode;
	wire [`OPCODE_LEN - 1 : 0] inst_opcode;
	wire inst_s, inst_i;
	wire [`REGISTER_FILE_ADDRESS_LEN - 1 : 0] inst_r_n, inst_r_d, reg_file_mux_out;
	wire [`COND_LEN - 1 : 0] inst_condition;
	wire[`SHIFT_OPERAND_LEN - 1 : 0] inst_shift;
	wire[`SIGNED_IMM_LEN - 1 : 0] inst_signed_imm;

	wire [`EXECUTE_COMMAND_LEN - 1 : 0] exec_cmd_cu_out; 
	wire mem_write_cu_out, mem_read_cu_out, wb_cu_out, branch_cu_out, status_update_cu_out, cond_check_out;
	wire [`REGISTER_FILE_LEN - 1 : 0] reg_file_out_1, reg_file_out_2;
	wire [`CONTROL_UNIT_OUT_LEN - 1 : 0] cu_mux_out;
	wire cu_mux_en;

	// Assigns :
	assign inst_condition = instruction[31 : 28];
	assign inst_mode = instruction[27 : 26];
	assign inst_i = instruction[25];
	assign inst_opcode = instruction[24 : 21];
	assign inst_r_n = instruction[19 : 16];
	assign inst_r_d = instruction[15 : 12];
	assign inst_shift = instruction[11 : 0];

	Control_Unit control_unit(
		.mode(inst_mode),
		.opcode(inst_opcode),
		.s(inst_s),
		.exec_command(exec_cmd_cu_out),
		.mem_read(mem_read_cu_out),
		.mem_write(mem_write_cu_out),
		.wb_en(wb_cu_out),
		.branch(branch_cu_out),
		.status_update_en(status_update_cu_out)
	);

	MUX_2 #(`REGISTER_FILE_LEN) reg_file_mux(
		.sel(mem_write_cu_out),
    	.inp1(instruction[3:0]),
    	.inp2(inst_r_d),
    	.out(reg_file_mux_out)
	);

	Condition_Check condition_check (
		.condition(inst_condition),
		.status_register(sr),
		.condition_state(cond_check_out)
	);

	Register_File register_file(
		.clk(clk),
		.rst(rst),
		.reg_addr_1(inst_r_n),
		.reg_addr_2(reg_file_mux_out),
		.wb_dest(wb_dest),
		.wb_value(wb_result),
		.wb_en(wb_en_in),
		.reg_1(reg_file_out_1),
		.reg_2(reg_file_out_2)
	);

	// Should add hazard
	assign cu_mux_en = ~cond_check_out | `ONE;

	MUX_2 #(`CONTROL_UNIT_OUT_LEN) cu_mux(
		.sel(mem_write_cu_out),
    	.inp1({exec_cmd_cu_out, mem_read_cu_out, mem_write_cu_out, wb_cu_out, branch_cu_out, status_update_cu_out}),
    	.inp2(`CONTROL_UNIT_OUT_LEN'b0),
    	.out(cu_mux_out)
	);

	assign {exec_cmd_cu_out, mem_read_cu_out, mem_write_cu_out, wb_cu_out, branch_cu_out, status_update_cu_out} = cu_mux_out;
	assign wb_en_out = wb_cu_out;
	assign mem_r_en = mem_write_cu_out;
	assign mem_w_en = mem_read_cu_out;
	assign b = branch_cu_out;
	assign s = status_update_cu_out;
    assign imm = inst_i;
	assign two_src = (~inst_i) | mem_write_cu_out;
	assign exec_cmd = exec_cmd_cu_out;
	assign val_r_n = reg_file_out_1;
	assign val_r_m = reg_file_out_2;
	assign src_1 = inst_r_n;
	assign src_2 = reg_file_mux_out;
	assign dest = inst_r_d;
	assign shift_operand = inst_shift;
	assign signed_imm_24 = inst_signed_imm;
	assign pc_out = pc_in;

endmodule
