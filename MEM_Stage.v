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
    inout[2*`SRAM_DATA_LEN-1:0] SRAM_DQ;

    wire sram_ready;
    wire cache_hit;
    wire[`CACHE_DATA_LEN-1:0] cache_data_out;
    wire[`ADDRESS_LEN-1:0] cache_cu_sram_addr;
    wire cache_cu_cache_write_en, cache_cu_cache_read_en, cache_cu_cache_invalid;
    wire cache_cu_sram_write_en, cache_cu_sram_read_en;
    wire[`CACHE_ADDR_LEN-1:0] cache_cu_cache_addr;
    wire[`CACHE_BLOCK_DATA_LEN-1:0] cache_cu_cache_in_data;
    wire[`SRAM_DATA_LEN-1:0] cache_cu_sram_in_data;
    wire[2*`REGISTER_FILE_LEN - 1 : 0] sram_cu_read_data;

    SRAM_Controller SRAM_CU(
        .clk(clk), 
        .rst(rst),
        .write_en(cache_cu_sram_write_en), 
        .read_en(cache_cu_sram_read_en),
        .address(cache_cu_sram_addr),
        .write_data(cache_cu_sram_in_data),
        .read_data(sram_cu_read_data),
        .ready(sram_ready),
        .SRAM_DQ(SRAM_DQ),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_UB_N(SRAM_UB_N),              
        .SRAM_LB_N(SRAM_LB_N),             
        .SRAM_WE_N(SRAM_WE_N),      
        .SRAM_CE_N(SRAM_CE_N),     
        .SRAM_OE_N(SRAM_OE_N)        
    );

    Cache_Controller Cache_CU(
        .clk(clk), 
        .rst(rst),
        .write_en(mem_w_en), 
        .read_en(mem_r_en),
        .address(alu_res),
        .write_data(val_r_m),

        .sram_read_data(sram_cu_read_data),
        .sram_ready(sram_ready), 

        .cache_hit(cache_hit),
        .cache_read_data(cache_data_out),

        .read_data(mem_res),
        .ready(ready),

        .sram_address(cache_cu_sram_addr),
        .sram_write_data(cache_cu_sram_in_data),
        .sram_write_en(cache_cu_sram_write_en), 
        .sram_read_en(cache_cu_sram_read_en),

        .cache_address(cache_cu_cache_addr), 
        .cache_write_data(cache_cu_cache_in_data),
        .cache_write_en(cache_cu_cache_write_en),
        .cache_read_en(cache_cu_cache_read_en),
        .cache_invalidation(cache_cu_cache_invalid)
    );

    Cache cache(
        .clk(clk), 
        .rst(rst),
        .write_en(cache_cu_cache_write_en), 
        .read_en(cache_cu_cache_read_en),
        .address(cache_cu_cache_addr),
        .write_data(cache_cu_cache_in_data),
        .invalidation(cache_cu_cache_invalid),

        .read_data(cache_data_out),
        .hit(cache_hit)
    );

endmodule
