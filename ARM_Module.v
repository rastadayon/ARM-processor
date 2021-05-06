`include "Constants.v"

module ARM_Module(
	clk, 
	rst
);

    input clk, rst;

    // IF Stage out wires :
    wire[`ADDRESS_LEN - 1:0] if_stage_pc_out, if_stage_instruction_out;

    // ID Stage out wires :
    wire id_stage_wb_en_out, id_stage_mem_r_en, id_stage_mem_w_en, id_stage_b, id_stage_s, id_stage_imm, id_stage_two_src;
    wire[`ADDRESS_LEN - 1 : 0] id_stage_pc_out;
    wire[`EXEC_COMMAND_LEN - 1 : 0] id_stage_exec_cmd;
    wire[`REGISTER_FILE_LEN - 1 : 0] id_stage_val_r_n, id_stage_val_r_m;
    wire[`SHIFT_OPERAND_LEN - 1 : 0] id_stage_shift_operand;
    wire[`SIGNED_IMM_LEN - 1 : 0] id_stage_signed_imm_24;
    wire[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] id_stage_dest, id_stage_src_1, id_stage_src_2;
    wire[`STATUS_REG_LEN - 1 : 0] id_stage_status_reg;

    // EXE Stage out wires :
    wire exe_stage_wb_en_out, exe_stage_mem_r_en, exe_stage_mem_w_en;
    wire[`REGISTER_FILE_LEN - 1 : 0] exe_stage_val_r_m, exe_alu_res;
    wire[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] exe_stage_dest;
    wire[`STATUS_REG_LEN - 1 : 0] exe_status_reg;
    wire[`ADDRESS_LEN - 1 : 0] exe_branch_addr;

    // ToDo: Fill empty in/outputs
    IF_Stage_Module if_stage_module(
	    .clk(clk),
	    .rst(rst),
	    .freeze(),
	    .flush(),
	    .branch_taken(),
	    .branch_addr(),
	    .pc(if_stage_pc_out),
	    .instruction(if_stage_instruction_out)
    );

    // ToDo: Fill empty in/outputs
    ID_Stage_Module id_stage_module (
        .clk(clk),
        .rst(rst),
        .flush(flush),
        .pc_in(if_stage_pc_out),
        .instruction(if_stage_instruction_out),
        .wb_result(),
        .wb_en_in(),
        .wb_dest(),
        .status_reg_in(),
        
        .wb_en_out(id_stage_wb_en_out),
        .mem_r_en(id_stage_mem_r_en),
        .mem_w_en(id_stage_mem_w_en),
        .branch_taken(id_stage_b),
        .status_reg_en(id_stage_s),
        .exec_cmd(id_stage_exec_cmd),
        .pc_out(id_stage_pc_out),
        .val_r_n(id_stage_val_r_n),
        .val_r_m(id_stage_val_r_m),
        .imm(id_stage_imm),
        .shift_operand(id_stage_shift_operand),
        .signed_imm_24(id_stage_signed_imm_24),
        .dest(id_stage_dest),
        .two_src(id_stage_two_src),
        .reg_file_src_1(id_stage_src_1),
        .reg_file_src_2(id_stage_src_2),
        .status_reg_out(id_stage_status_reg)
    );

    // ToDo: Fill empty in/outputs
    // ToDo: pc_out? flush?
    EXE_Stage_Module ex_stage_module (
        .clk(clk),
        .rst(rst),
        .wb_en_in(id_stage_wb_en_out),
        .mem_r_en_in(id_stage_mem_r_en),
        .mem_w_en_in(id_stage_mem_w_en),
        .exec_cmd(id_stage_exec_cmd),
        .pc_in(id_stage_pc_out),
        .val_r_n(id_stage_val_r_n),
        .val_r_m_in(id_stage_val_r_m),
        .shift_operand(id_stage_shift_operand),
        .imm(id_stage_imm),
        .signed_imm_24(id_stage_signed_imm_24),
        .dest_in(id_stage_dest),
        .status_reg_out(id_stage_status_reg),
        .flush(flush),

        .wb_en_out(exe_stage_wb_en_out),
        .mem_r_en_out(exe_stage_mem_r_en),
        .mem_w_en_out(exe_stage_mem_w_en),
        .alu_res(exe_alu_res),
        .val_r_m_out(exe_stage_val_r_m),
        .dest_out(exe_stage_dest),
        .status_reg_in(exe_status_reg),
        .branch_addr(exe_branch_addr),
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