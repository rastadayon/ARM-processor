
`include "Constants.v"
`timescale 1ns/1ns

module EXE_Stage_Reg (
    clk,
    rst,
    freeze,
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
    input clk, rst, wb_en_in, mem_r_en_in, mem_w_en_in, freeze;
    input[`REGISTER_FILE_LEN - 1 : 0] val_r_m_in, alu_res_in;
    input[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest_in;

    output wb_en_out, mem_r_en_out, mem_w_en_out;
    output[`REGISTER_FILE_LEN - 1 : 0] val_r_m_out, alu_res_out;
    output[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest_out;

    Register #(`ONE) wb_en_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(), .inp(wb_en_in), .out(wb_en_out));
    Register #(`ONE) mem_r_en_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(), .inp(mem_r_en_in), .out(mem_r_en_out));
    Register #(`ONE) mem_w_en_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(), .inp(mem_w_en_in), .out(mem_w_en_out));
    Register #(`REGISTER_FILE_LEN) alu_res_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(), .inp(alu_res_in), .out(alu_res_out));
    Register #(`REGISTER_FILE_LEN) val_r_m_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(), .inp(val_r_m_in), .out(val_r_m_out));
    Register #(`REGISTER_FILE_ADDRESS_LEN) dest_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(), .inp(dest_in), .out(dest_out));


    
endmodule