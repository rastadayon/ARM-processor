`include "Constants.v"

module ID_Stage_Reg (
    clk,
    rst,
    flush,
    wb_en_in,
    mem_r_en_in,
    mem_w_en_in,
    b_in,
    s_in,
    exec_cmd_in,
    pc_in,
    val_r_n_in,
    val_r_m_in,
    imm_in,
    shift_operand_in,
    signed_imm_24_in,
    dest_in,
    status_reg_in,

    wb_en_out,
    mem_r_en_out,
    mem_w_en_out,
    b_out,
    s_out,
    exec_cmd_out,
    pc_out,
    val_r_n_out,
    val_r_m_out,
    imm_out,
    shift_operand_out,
    signed_imm_24_out,
    dest_out,
    status_reg_out
);
    input clk, rst, flush, wb_en_in, mem_r_en_in, mem_w_en_in, b_in, s_in, imm_in;
    input[`ADDRESS_LEN - 1 : 0] pc_in;
    input[`EXEC_COMMAND_LEN - 1 : 0] exec_cmd_in;
    input[`REGISTER_FILE_LEN - 1 : 0] val_r_n_in, val_r_m_in;
    input[`SHIFT_OPERAND_LEN - 1 : 0] shift_operand_in;
    input[`SIGNED_IMM_LEN - 1 : 0] signed_imm_24_in;
    input[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest_in;
    input[`STATUS_REG_LEN - 1 : 0] status_reg_in;

    output wb_en_out, mem_r_en_out, mem_w_en_out, b_out, s_out, imm_out;
    output[`ADDRESS_LEN - 1 : 0] pc_out;
    output[`EXEC_COMMAND_LEN - 1 : 0] exec_cmd_out;
    output[`REGISTER_FILE_LEN - 1 : 0] val_r_n_out, val_r_m_out;
    output[`SHIFT_OPERAND_LEN - 1 : 0] shift_operand_out;
    output[`SIGNED_IMM_LEN - 1 : 0] signed_imm_24_out;
    output[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest_out;
    output[`STATUS_REG_LEN - 1 : 0] status_reg_out;

    Register #(`ONE) wb_en_reg(.clk(clk), .rst(rst), .ld(`ONE), .clr(flush), .inp(wb_en_in), .out(wb_en_out));
    Register #(`ONE) mem_r_en_reg(.clk(clk), .rst(rst), .ld(`ONE), .clr(flush), .inp(mem_r_en_in), .out(mem_r_en_out));
    Register #(`ONE) mem_w_en_reg(.clk(clk), .rst(rst), .ld(`ONE), .clr(flush), .inp(mem_w_en_in), .out(mem_w_en_out));
    Register #(`ONE) b_reg(.clk(clk), .rst(rst), .ld(`ONE), .clr(flush), .inp(b_in), .out(b_out));
    Register #(`ONE) s_reg(.clk(clk), .rst(rst), .ld(`ONE), .clr(flush), .inp(s_in), .out(s_out));
    Register #(`ONE) imm_reg(.clk(clk), .rst(rst), .ld(`ONE), .clr(flush), .inp(imm_in), .out(imm_out));
    Register #(`ADDRESS_LEN) pc_reg(.clk(clk), .rst(rst), .ld(`ONE), .clr(flush), .inp(pc_in), .out(pc_out));
    Register #(`EXEC_COMMAND_LEN) exec_cmd_reg(.clk(clk), .rst(rst), .ld(`ONE), .clr(flush), .inp(exec_cmd_in), .out(exec_cmd_out));
    Register #(`REGISTER_FILE_LEN) val_r_n_reg(.clk(clk), .rst(rst), .ld(`ONE), .clr(flush), .inp(val_r_n_in), .out(val_r_n_out));
    Register #(`REGISTER_FILE_LEN) val_r_m_reg(.clk(clk), .rst(rst), .ld(`ONE), .clr(flush), .inp(val_r_m_in), .out(val_r_m_out));
    Register #(`SHIFT_OPERAND_LEN) shift_operand_reg(.clk(clk), .rst(rst), .ld(`ONE), .clr(flush), .inp(shift_operand_in), .out(shift_operand_out));
    Register #(`SIGNED_IMM_LEN) signed_imm_24_reg(.clk(clk), .rst(rst), .ld(`ONE), .clr(flush), .inp(signed_imm_24_in), .out(signed_imm_24_out));
    Register #(`REGISTER_FILE_ADDRESS_LEN) dest_reg(.clk(clk), .rst(rst), .ld(`ONE), .clr(flush), .inp(dest_in), .out(dest_out));
    Register #(`STATUS_REG_LEN) status_reg_value_reg(.clk(clk), .rst(rst), .ld(`ONE), .clr(flush), .inp(status_reg_in), .out(status_reg_out));
endmodule