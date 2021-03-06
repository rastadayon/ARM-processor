
`include "Constants.v"
`timescale 1ns/1ns

module EXE_Stage_Module (
    clk,
    rst,
    freeze,
    wb_en_in,
    mem_r_en_in,
    mem_w_en_in,
    exec_cmd,
    pc_in,
    val_r_n,
    val_r_m_in,
    shift_operand,
    imm,
    signed_imm_24,
    dest_in,
    status_reg_out,

    sel_src1,
    sel_src2,
    mem_wb_val,
    wb_wb_val,

    wb_en_out,
    mem_r_en_out,
    mem_w_en_out,
    alu_res,
    val_r_m_out,
    dest_out,
    status_reg_in,
    branch_addr
);
    input clk, rst, wb_en_in, mem_r_en_in, mem_w_en_in, imm, freeze;
    input[`EXEC_COMMAND_LEN - 1 : 0] exec_cmd;
    input[`ADDRESS_LEN - 1 : 0] pc_in;
    input[`REGISTER_FILE_LEN - 1 : 0] val_r_n, val_r_m_in, mem_wb_val, wb_wb_val;
    input[`SHIFT_OPERAND_LEN - 1 : 0] shift_operand;
    input[`SIGNED_IMM_LEN - 1 : 0] signed_imm_24;
    input[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest_in;
    input[`STATUS_REG_LEN - 1 : 0] status_reg_out;
    input[1 : 0] sel_src1, sel_src2;

    output wb_en_out, mem_r_en_out, mem_w_en_out;
    output[`REGISTER_FILE_LEN - 1 : 0] alu_res, val_r_m_out;
    output[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest_out;
    output[`STATUS_REG_LEN - 1 : 0] status_reg_in;
    output[`ADDRESS_LEN - 1 : 0] branch_addr;

    wire[`REGISTER_FILE_LEN - 1 : 0] exe_alu_res_out;
    wire[`REGISTER_FILE_LEN - 1 : 0] val_r_m;

    EXE_Stage exe_stage (
        .clk(clk),
        .rst(rst),
        .mem_r_en_in(mem_r_en_in),
        .mem_w_en_in(mem_w_en_in),
        .exec_cmd(exec_cmd),
        .pc_in(pc_in),
        .val_1(val_r_n),
        .val_r_m_in(val_r_m_in),
        .shift_operand(shift_operand),
        .imm(imm),
        .signed_imm_24(signed_imm_24),
        .status_reg_out(status_reg_out),
        .flush(flush),

        .alu_src1_mux_sel(sel_src1),
        .alu_src2_mux_sel(sel_src2),
        .mem_wb_val(mem_wb_val),
        .wb_wb_val(wb_wb_val),

        .alu_res(exe_alu_res_out),
        .status_reg_in(status_reg_in),
        .branch_addr(branch_addr),
        .val_r_m(val_r_m)
    );

    EXE_Stage_Reg exe_stage_reg (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .wb_en_in(wb_en_in),
        .mem_r_en_in(mem_r_en_in),
        .mem_w_en_in(mem_w_en_in),
        .alu_res_in(exe_alu_res_out),
        .val_r_m_in(val_r_m),
        .dest_in(dest_in),

        .wb_en_out(wb_en_out),
        .mem_r_en_out(mem_r_en_out),
        .mem_w_en_out(mem_w_en_out),
        .alu_res_out(alu_res),
        .val_r_m_out(val_r_m_out),
        .dest_out(dest_out)
    );

endmodule
