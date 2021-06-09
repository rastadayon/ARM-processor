
`include "Constants.v"
`timescale 1ns/1ns

module MEM_Stage_Module (
    clk,
    rst,
    freeze,
    wb_en_in,
    mem_r_en_in,
    mem_w_en,
    alu_res_in,
    val_r_m,
    dest_in,

    wb_en_out,
    mem_r_en_out,
    alu_res_out,
    mem_res,
    dest_out,

    ready,
    SRAM_DQ,
    SRAM_ADDR,
    SRAM_UB_N,              
    SRAM_LB_N,             
    SRAM_WE_N,      
    SRAM_CE_N,     
    SRAM_OE_N    
);
    input clk, rst, wb_en_in, mem_r_en_in, mem_w_en, freeze;
    input[`REGISTER_FILE_LEN - 1 : 0] alu_res_in, val_r_m;
    input[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest_in;

    output wb_en_out, mem_r_en_out;
    output[`REGISTER_FILE_LEN - 1 : 0] alu_res_out, mem_res;
    output[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest_out;
    output ready, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N;
    output [`SRAM_ADDR_LEN-1:0] SRAM_ADDR;
    
    inout[`SRAM_DATA_LEN-1:0] SRAM_DQ;

    wire[`REGISTER_FILE_LEN - 1 : 0] mem_stage_mem_res;

    MEM_Stage mem_stage (
        .clk(clk),
        .rst(rst),
        .mem_r_en(mem_r_en_in),
        .mem_w_en(mem_w_en),
        .alu_res(alu_res_in),
        .val_r_m(val_r_m),

        .mem_res(mem_stage_mem_res),
        .ready(ready),
        .SRAM_DQ(SRAM_DQ),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_UB_N(SRAM_UB_N),              
        .SRAM_LB_N(SRAM_LB_N),             
        .SRAM_WE_N(SRAM_WE_N),      
        .SRAM_CE_N(SRAM_CE_N),     
        .SRAM_OE_N(SRAM_OE_N)   
    );

    MEM_Stage_Reg mem_stage_reg (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .wb_en_in(wb_en_in),
        .mem_r_in(mem_r_en_in),
        .alu_res_in(alu_res_in),
        .mem_res_in(mem_stage_mem_res),
        .dest_in(dest_in),

        .wb_en_out(wb_en_out),
        .mem_r_out(mem_r_en_out),
        .alu_res_out(alu_res_out),
        .mem_res_out(mem_res),
        .dest_out(dest_out)
    );

endmodule
