`include "Constants.v"

module MEM_Stage_Reg (
    clk,
    rst,
    wb_en_in,
    mem_r_in,
    alu_res_in,
    mem_res_in,
    dest_in,

    wb_en_out,
    mem_r_out,
    alu_res_out,
    mem_res_out,
    dest_out
);
    input clk, rst, wb_en_in, mem_r_in;
    input[`REGISTER_FILE_LEN - 1 : 0] alu_res_in, mem_res_in;
    input[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest_in;

    output wb_en_out, mem_r_out;
    output[`REGISTER_FILE_LEN - 1 : 0] alu_res_out, mem_res_out;
    output[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest_out;
    
endmodule
