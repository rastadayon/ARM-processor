`include "Constants.v"
`timescale 1ns/1ns

module MEM_Stage_Reg (
    clk,
    rst,
    freeze,
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
    input clk, rst, wb_en_in, mem_r_in, freeze;
    input[`REGISTER_FILE_LEN - 1 : 0] alu_res_in, mem_res_in;
    input[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest_in;

    output wb_en_out, mem_r_out;
    output[`REGISTER_FILE_LEN - 1 : 0] alu_res_out, mem_res_out;
    output[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest_out;

    Register #(`ONE) wb_en_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(), .inp(wb_en_in), .out(wb_en_out));
    Register #(`ONE) mem_r_en_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(), .inp(mem_r_in), .out(mem_r_out));
    Register #(`REGISTER_FILE_LEN) alu_res_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(), .inp(alu_res_in), .out(alu_res_out));
    Register #(`REGISTER_FILE_LEN) mem_res_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(), .inp(mem_res_in), .out(mem_res_out));
    Register #(`REGISTER_FILE_ADDRESS_LEN) dest_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(), .inp(dest_in), .out(dest_out));
    
endmodule
