`include "Constants.v"

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

    mem_r_en_out,
    mem_w_en_out,
    alu_res,
    val_r_m_out,
    status_reg_in,
    branch_addr
);
    input clk, rst, mem_r_en_in, mem_w_en_in, imm, flush;
    input[`EXEC_COMMAND_LEN - 1 : 0] exec_cmd;
    input[`ADDRESS_LEN - 1 : 0] pc_in;
    input[`REGISTER_FILE_LEN - 1 : 0] val_1, val_r_m_in;
    input[`SHIFT_OPERAND_LEN - 1 : 0] shift_operand;
    input[`SIGNED_IMM_LEN - 1 : 0] signed_imm_24;
    input[`STATUS_REG_LEN - 1 : 0] status_reg_out;

    output mem_r_en_out, mem_w_en_out;
    output[`REGISTER_FILE_LEN - 1 : 0] alu_res, val_r_m_out;
    output[`STATUS_REG_LEN - 1 : 0] status_reg_in;
    output[`ADDRESS_LEN - 1 : 0] branch_addr;

endmodule
