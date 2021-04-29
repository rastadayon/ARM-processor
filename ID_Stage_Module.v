
`include "Constants.v"

module ID_Stage_Module (
    clk,
    rst,
    flush,
    pc_in,
    instruction,
    wb_result,
	wb_en_in,
	wb_dest,
    sr,
    
    wb_en_out,
    mem_r_en,
    mem_w_en,
    b,
    s,
    exec_cmd,
    pc_out,
    val_r_n,
    val_r_m,
    imm,
    shift_operand,
    signed_imm_24,
    dest
);
    input clk, rst, flush, wb_en_in;
    input [`ADDRESS_LEN - 1 : 0] pc_in;
    input [`INSTRUCTION_LEN - 1 : 0] instruction;
    input [`REGISTER_FILE_LEN - 1 : 0] wb_result;
    input [`REGISTER_FILE_ADDRESS_LEN - 1 : 0] wb_dest;
    input [`REGISTER_FILE_ADDRESS_LEN - 1 : 0] sr;

    output wb_en_out, mem_r_en, mem_w_en, b, s, imm;
    output[`ADDRESS_LEN - 1 : 0] pc_out;
    output[`EXEC_COMMAND_LEN - 1 : 0] exec_cmd;
    output[`REGISTER_FILE_LEN - 1 : 0] val_r_n, val_r_m;
    output[`SHIFT_OPERAND_LEN - 1 : 0] shift_operand;
    output[`SIGNED_IMM_LEN - 1 : 0] signed_imm_24;
    output[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest;

    wire id_stage_wb_en_out, id_stage_mem_r_en, id_stage_mem_w_en, id_stage_b, id_stage_s, id_stage_imm, id_stage_two_src;
    wire[`EXEC_COMMAND_LEN - 1 : 0] id_stage_exec_cmd;
    wire[`REGISTER_FILE_LEN - 1 : 0] id_stage_val_r_n, id_stage_val_r_m;
    wire[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] id_stage_src_1, id_stage_src_2, id_stage_dest;
    wire[`SHIFT_OPERAND_LEN - 1 : 0] id_stage_shift_operand;
    wire[`SIGNED_IMM_LEN - 1 : 0] id_stage_signed_imm_24;
    wire[`ADDRESS_LEN - 1 : 0] id_stage_pc_out;

    // ToDo: Should add hazard
    ID_Stage id_stage (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_in),
        .instruction(instruction),
        .wb_result(wb_result),
        .wb_en_in(wb_en_in),
        .wb_dest(wb_dest),
        .hazard(`ONE),
        .sr(sr),
        .wb_en_out(id_stage_wb_en_out),
        .mem_r_en(id_stage_mem_r_en),
        .mem_w_en(id_stage_mem_w_en),
        .b(id_stage_b),
        .s(id_stage_s),
        .exec_cmd(id_stage_exec_cmd),
        .val_r_n(id_stage_val_r_n),
        .val_r_m(id_stage_val_r_m),
        .imm(id_stage_imm),
        .shift_operand(id_stage_shift_operand),
        .signed_imm_24(id_stage_signed_imm_24),
        .dest(id_stage_dest),
        .src_1(id_stage_src_1),
        .src_2(id_stage_src_2),
        .two_src(id_stage_two_src),
        .pc_out(id_stage_pc_out)
    );

    ID_Stage_Reg id_stage_reg (
        .rst(rst),
        .clk(clk),
        .flush(flush),
        .wb_en_in(id_stage_wb_en_out),
        .mem_r_en_in(id_stage_mem_r_en),
        .mem_w_en_in(id_stage_mem_w_en),
        .b_in(id_stage_b),
        .s_in(id_stage_s),
        .exec_cmd_in(id_stage_exec_cmd),
        .pc_in(id_stage_pc_out),
        .val_r_n_in(id_stage_val_r_n),
        .val_r_m_in(id_stage_val_r_m),
        .imm_in(id_stage_imm),
        .shift_operand_in(id_stage_shift_operand),
        .signed_imm_24_in(id_stage_signed_imm_24),
        .dest_in(id_stage_dest),

        .wb_en_out(wb_en_out),
        .mem_r_en_out(mem_r_en),
        .mem_w_en_out(mem_w_en),
        .b_out(b),
        .s_out(s),
        .exec_cmd_out(exec_cmd),
        .pc_out(pc_out),
        .val_r_n_out(val_r_n),
        .val_r_m_out(val_r_m),
        .imm_out(imm),
        .shift_operand_out(shift_operand),
        .signed_imm_24_out(signed_imm_24),
        .dest_out(dest)       
    );

endmodule