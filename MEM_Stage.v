`include "Constants.v"
`timescale 1ns/1ns

module MEM_Stage (
    clk,
    rst,
    mem_r_en,
    mem_w_en,
    alu_res,
    val_r_m,

    mem_res,
    ready,
    SRAM_DQ,
    SRAM_ADDR,
    SRAM_UB_N,              
    SRAM_LB_N,             
    SRAM_WE_N,      
    SRAM_CE_N,     
    SRAM_OE_N    
);

    input clk, rst, mem_r_en, mem_w_en;
    input[`REGISTER_FILE_LEN - 1 : 0] alu_res, val_r_m;

    output[`REGISTER_FILE_LEN - 1 : 0] mem_res;
    output ready, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N;
    output [`SRAM_ADDR_LEN-1:0] SRAM_ADDR;
    inout[`SRAM_DATA_LEN-1:0] SRAM_DQ;

    SRAM_Controller SRAM_CU(
        .clk(clk), 
        .rst(rst),
        .write_en(mem_w_en), 
        .read_en(mem_r_en),
        .address(alu_res),
        .write_data(val_r_m),
        .read_data(mem_res),
        .ready(ready),
        .SRAM_DQ(SRAM_DQ),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_UB_N(SRAM_UB_N),              
        .SRAM_LB_N(SRAM_LB_N),             
        .SRAM_WE_N(SRAM_WE_N),      
        .SRAM_CE_N(SRAM_CE_N),     
        .SRAM_OE_N(SRAM_OE_N)        
    );

    // Memory memory (
    //     .clk(clk), 
    //     .rst(rst),
    //     .alu_res(alu_res),
    //     .val_r_m(val_r_m),
    //     .mem_w_en(mem_w_en),
    //     .mem_r_en(mem_r_en),
    //     .mem_out(mem_res)
    // );

endmodule
