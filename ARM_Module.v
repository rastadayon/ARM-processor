`include "Constants.v"

module ARM_Module(
	clk, 
	rst,
    forwarding_enable
);

    input clk, rst, forwarding_enable;

    // IF Stage out wires :
    wire flush, freeze;
    wire[`ADDRESS_LEN - 1:0] if_stage_pc_out, if_stage_instruction_out;
    wire[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] if_stage_r_n;

    // ID Stage out wires :
    wire id_stage_wb_en_out, id_stage_mem_r_en_out, id_stage_mem_w_en_out, id_stage_b_out, id_stage_s_out, id_stage_imm_out, id_stage_two_src_out, hazard;
    wire[`ADDRESS_LEN - 1 : 0] id_stage_pc_out;
    wire[`EXEC_COMMAND_LEN - 1 : 0] id_stage_exec_cmd_out;
    wire[`REGISTER_FILE_LEN - 1 : 0] id_stage_val_r_n_out, id_stage_val_r_m_out;
    wire[`SHIFT_OPERAND_LEN - 1 : 0] id_stage_shift_operand_out;
    wire[`SIGNED_IMM_LEN - 1 : 0] id_stage_signed_imm_24_out;
    wire[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] id_stage_dest_out, id_stage_src_1_out, id_stage_src_2_out, id_stage_src_2_before_reg_out;
    wire[`STATUS_REG_LEN - 1 : 0] id_stage_status_reg_out;

    // EXE Stage out wires :
    wire exe_stage_wb_en_out, exe_stage_mem_r_en_out, exe_stage_mem_w_en_out;
    wire[`REGISTER_FILE_LEN - 1 : 0] exe_stage_val_r_m_out, exe_alu_res_out;
    wire[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] exe_stage_dest_out;
    wire[`STATUS_REG_LEN - 1 : 0] exe_status_reg_out;
    wire[`ADDRESS_LEN - 1 : 0] exe_branch_addr_out;
    wire[`STATUS_REG_LEN - 1 : 0] status_register_out;

    // MEM Stage out wires :
    wire mem_stage_mem_r_en_out, mem_stage_wb_en_out;
    wire[`REGISTER_FILE_LEN - 1 : 0] mem_stage_alu_res_out, mem_stage_mem_res_out;
    wire[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] mem_stage_dest_out;

    assign flush = id_stage_b_out;
    assign if_stage_r_n = if_stage_instruction_out[19 : 16];
    assign freeze = hazard;

    // Forwarding out wires :
    wire[1 : 0] src1_select, src2_select;

    // WB Stage out wires :
    wire[`REGISTER_FILE_LEN - 1 : 0] wb_value;
    wire wb_stage_wb_en_out;
    wire[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] wb_stage_dest_out;

    IF_Stage_Module if_stage_module(
	    .clk(clk),
	    .rst(rst),
	    .freeze(freeze),
	    .flush(flush),
	    .branch_taken(id_stage_b_out),
	    .branch_addr(exe_branch_addr_out),
	    .pc(if_stage_pc_out),
	    .instruction(if_stage_instruction_out)
    );

    ID_Stage_Module id_stage_module (
        .clk(clk),
        .rst(rst),
        .flush(flush),
        .pc_in(if_stage_pc_out),
        .instruction(if_stage_instruction_out),
        .wb_result(wb_value),
        .wb_en_in(mem_stage_wb_en_out),
        .wb_dest(mem_stage_dest_out),
        .status_reg_in(status_register_out),
        .hazard(hazard),
        
        .wb_en_out(id_stage_wb_en_out),
        .mem_r_en(id_stage_mem_r_en_out),
        .mem_w_en(id_stage_mem_w_en_out),
        .branch_taken(id_stage_b_out),
        .status_reg_en(id_stage_s_out),
        .exec_cmd(id_stage_exec_cmd_out),
        .pc_out(id_stage_pc_out),
        .val_r_n(id_stage_val_r_n_out),
        .val_r_m(id_stage_val_r_m_out),
        .imm(id_stage_imm_out),
        .shift_operand(id_stage_shift_operand_out),
        .signed_imm_24(id_stage_signed_imm_24_out),
        .dest(id_stage_dest_out),
        .two_src(id_stage_two_src_out),
        .reg_file_src_1(id_stage_src_1_out),
        .reg_file_src_2(id_stage_src_2_out),
        .reg_file_src_2_before_reg(id_stage_src_2_before_reg_out),
        .status_reg_out(id_stage_status_reg_out)
    );

    Hazard_Detection hazard_detection_unit (
        .forwarding_enable(forwarding_enable),
        .two_src(id_stage_two_src_out),
        .r_n(if_stage_r_n),
        .r_d(id_stage_src_2_before_reg_out),
        .mem_dest(exe_stage_dest_out),
        .mem_wb_en(exe_stage_wb_en_out),
        .exe_dest(id_stage_dest_out),
        .exe_wb_en(id_stage_wb_en_out),
        .exe_mem_r_en(id_stage_mem_r_en_out),

        .hazard(hazard)
    );

    Forwarding_Unit forwarding_unit (
        .forwarding_enable(forwarding_enable),
        .src1(id_stage_src_1_out),
        .src2(id_stage_src_2_out),
        .mem_dest(exe_stage_dest_out),
        .wb_dest(wb_stage_dest_out),
        .mem_wb_en(exe_stage_wb_en_out),
        .wb_wb_en(mem_stage_wb_en_out),
        .src1_select(src1_select),
        .src2_select(src2_select)
    );

    EXE_Stage_Module ex_stage_module (
        .clk(clk),
        .rst(rst),
        .wb_en_in(id_stage_wb_en_out),
        .mem_r_en_in(id_stage_mem_r_en_out),
        .mem_w_en_in(id_stage_mem_w_en_out),
        .exec_cmd(id_stage_exec_cmd_out),
        .pc_in(id_stage_pc_out),
        .val_r_n(id_stage_val_r_n_out),
        .val_r_m_in(id_stage_val_r_m_out),
        .shift_operand(id_stage_shift_operand_out),
        .imm(id_stage_imm_out),
        .signed_imm_24(id_stage_signed_imm_24_out),
        .dest_in(id_stage_dest_out),
        .status_reg_out(id_stage_status_reg_out),

        .sel_src1(src1_select),
        .sel_src2(src2_select),
        .mem_wb_val(exe_alu_res_out),
        .wb_wb_val(wb_value),


        .wb_en_out(exe_stage_wb_en_out),
        .mem_r_en_out(exe_stage_mem_r_en_out),
        .mem_w_en_out(exe_stage_mem_w_en_out),
        .alu_res(exe_alu_res_out),
        .val_r_m_out(exe_stage_val_r_m_out),
        .dest_out(exe_stage_dest_out),
        .status_reg_in(exe_status_reg_out),
        .branch_addr(exe_branch_addr_out)
    );

    Register #(`STATUS_REG_LEN) status_register (
        .clk(~clk), 
        .rst(rst), 
        .ld(id_stage_s_out), 
        .clr(), 
        .inp(exe_status_reg_out), 

        .out(status_register_out)
    );

    MEM_Stage_Module mem_stage_module (
        .clk(clk),
        .rst(rst),
        .wb_en_in(exe_stage_wb_en_out),
        .mem_r_en_in(exe_stage_mem_r_en_out),
        .mem_w_en(exe_stage_mem_w_en_out),
        .alu_res_in(exe_alu_res_out),
        .val_r_m(exe_stage_val_r_m_out),
        .dest_in(exe_stage_dest_out),

        .wb_en_out(mem_stage_wb_en_out),
        .mem_r_en_out(mem_stage_mem_r_en_out),
        .alu_res_out(mem_stage_alu_res_out),
        .mem_res(mem_stage_mem_res_out),
        .dest_out(mem_stage_dest_out)
    );

    WB_Stage wb_stage (
        .mem_r_en(mem_stage_mem_r_en_out),
        .alu_res(mem_stage_alu_res_out),
        .mem_res(mem_stage_mem_res_out),
        .wb_enable(mem_stage_wb_en_out),
        .dest(mem_stage_dest_out),

        .wb_value(wb_value),
        .wb_enable_out(wb_stage_wb_en_out),
        .wb_dest_out(wb_stage_dest_out)
    );

endmodule