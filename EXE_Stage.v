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

    alu_res,
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

    output[`REGISTER_FILE_LEN - 1 : 0] alu_res;
    output[`STATUS_REG_LEN - 1 : 0] status_reg_in;
    output[`ADDRESS_LEN - 1 : 0] branch_addr;

    wire[`REGISTER_FILE_LEN - 1 : 0] val_2;
    wire is_mem_related;

    assign is_mem_related = mem_r_en_in | mem_w_en_in;

    ALU alu (
        .val_1(val_1),
        .val_2(val_2),
        .exec_cmd(exec_cmd),
        .carry_in(status_reg_out[2]),
        .res(alu_res),
        .status_reg(status_reg_in)
    );

    Val_2_Generator val_2_generator (
        .val_r_m(val_r_m_in),
        .shift_operand(shift_operand),
        .imm(imm),
        .is_mem_related(is_mem_related),
        .val_2(val_2)
    );

    Adder branch_adder (
        .inp1(pc_in),
        .inp2(signed_imm_24),
        .out(branch_addr)
    );

endmodule
