`include "Constants.v"

module EXE_Stage (
    clk,
    rst,
    wb_en_in,
    mem_r_en_in,
    mem_w_en_in,
    exec_cmd,
    branch_taken_in,
    status_en_in,
    pc_in,
    val_r_n,
    val_r_m_in,
    shift_operand,
    imm,
    signed_imm_24,
    dest_in,
    status_reg_in,
    flush,

    wb_en_out,
    mem_r_en_out,
    mem_w_en_out,
    alu_res,
    val_r_m_out,
    dest_out,
    branch_taken_out,
    status_reg_out
);
    input clk, rst, wb_en_in, mem_r_en_in, mem_w_en_in, branch_taken_in, status_en_in, imm, flush;
    input[`EXEC_COMMAND_LEN - 1 : 0] exec_cmd;
    input[`ADDRESS_LEN - 1 : 0] pc_in;
    input[`REGISTER_FILE_LEN - 1 : 0] val_r_n, val_r_m_in;
    input[`SHIFT_OPERAND_LEN - 1 : 0] shift_operand;
    input[`SIGNED_IMM_LEN - 1 : 0] signed_imm_24;
    input[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest_in;
    input[`STATUS_REG_LEN - 1 : 0] status_reg_in;

    output wb_en_out, mem_r_en_out, mem_w_en_out, branch_taken_out;
    output[`REGISTER_FILE_LEN - 1 : 0] alu_res, val_r_m_out;
    output[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest_out;
    output[`STATUS_REG_LEN - 1 : 0] status_reg_out;



    

endmodule
