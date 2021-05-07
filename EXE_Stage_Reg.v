
`include "Constants.v"

module EXE_Stage_Reg (
    clk,
    rst,
    flush,
    wb_en_in,
    mem_r_en_in,
    mem_w_en_in,
    alu_res_in,
    val_r_m_in,
    dest_in,

    wb_en_out,
    mem_r_en_out,
    mem_w_en_out,
    alu_res_out,
    val_r_m_out,
    dest_out
);
    input clk, rst, flush, wb_en_in, mem_r_en_in, mem_w_en_in;
    input[`REGISTER_FILE_LEN - 1 : 0] val_r_m_in, alu_res_in;
    input[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest_in;

    output wb_en_out, mem_r_en_out, mem_w_en_out;
    output[`REGISTER_FILE_LEN - 1 : 0] val_r_m_out, alu_res_out;
    output[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest_out;

    
endmodule