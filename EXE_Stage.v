`include "Constants.v"
`timescale 1ns/1ns

module EXE_Stage (
    clk,
    rst,
    mem_r_en_in,
    mem_w_en_in,
    exec_cmd,
    pc_in,
    val_1,
    val_r_m_in,
    shift_operand,
    imm,
    signed_imm_24,
    status_reg_out,
    flush,

    alu_src1_mux_sel,
    alu_src2_mux_sel,
    mem_wb_val,
    wb_wb_val,

    alu_res,
    status_reg_in,
    branch_addr,
    val_r_m
);
    input clk, rst, mem_r_en_in, mem_w_en_in, imm, flush;
    input[`EXEC_COMMAND_LEN - 1 : 0] exec_cmd;
    input[`ADDRESS_LEN - 1 : 0] pc_in;
    input[`REGISTER_FILE_LEN - 1 : 0] val_1, val_r_m_in;
    input[`SHIFT_OPERAND_LEN - 1 : 0] shift_operand;
    input[`SIGNED_IMM_LEN - 1 : 0] signed_imm_24;
    input[`STATUS_REG_LEN - 1 : 0] status_reg_out;

    input[1 : 0] alu_src1_mux_sel, alu_src2_mux_sel;
    input[`REGISTER_FILE_LEN - 1 : 0] mem_wb_val, wb_wb_val;

    output[`REGISTER_FILE_LEN - 1 : 0] alu_res;
    output[`STATUS_REG_LEN - 1 : 0] status_reg_in;
    output[`ADDRESS_LEN - 1 : 0] branch_addr;
    output[`REGISTER_FILE_LEN - 1 : 0] val_r_m;

    wire [`ADDRESS_LEN - 1 : 0] test_branch;

    wire[`REGISTER_FILE_LEN - 1 : 0] val_2;
    wire is_mem_related;

    wire[`REGISTER_FILE_LEN - 1 : 0] alu_mux_src1, alu_mux_src2;

    assign is_mem_related = mem_r_en_in | mem_w_en_in;
    assign val_r_m = alu_mux_src2;

    MUX_3 #(`REGISTER_FILE_LEN) alu_src1_mux (
        .inp1(val_1),
        .inp2(mem_wb_val),
        .inp3(wb_wb_val),
        .sel(alu_src1_mux_sel),
        .out(alu_mux_src1)
    );

    MUX_3 #(`REGISTER_FILE_LEN) alu_src2_mux (
        .inp1(val_r_m_in),
        .inp2(mem_wb_val),
        .inp3(wb_wb_val),
        .sel(alu_src2_mux_sel),
        .out(alu_mux_src2)
    );

    ALU alu (
        .val_1(alu_mux_src1),
        .val_2(val_2),
        .exec_cmd(exec_cmd),
        .carry_in(status_reg_out[2]),
        .res(alu_res),
        .status_reg(status_reg_in)
    );

    Val_2_Generator val_2_generator (
        .val_r_m(alu_mux_src2),
        .shift_operand(shift_operand),
        .imm(imm),
        .is_mem_related(is_mem_related),
        .val_2(val_2)
    );

    Adder branch_adder (
        .inp1(pc_in),
        .inp2({{(6){signed_imm_24[`SIGNED_IMM_LEN-1]}}, signed_imm_24, 2'b0}),
        .out(branch_addr)
    );

    assign val_r_m = alu_mux_src2;

    // Adder branch_adder (
    //     .inp1(pc_in),
    //     .inp2({{(6){signed_imm_24[`SIGNED_IMM_LEN-1]}}, signed_imm_24, 2'b0}),
    //     .out(test_branch)
    // );

    // Adder test (
    //     .inp1(test_branch),
    //     .inp2(32'd4),
    //     .out(branch_addr)
    // );


endmodule
