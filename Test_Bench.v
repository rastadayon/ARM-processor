`include "Constants.v"
`timescale 1ns/1ns

module Test_Bench ();

    wire SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N;
    wire [`SRAM_ADDR_LEN-1:0] SRAM_ADDR;
    wire[`SRAM_DATA_LEN-1:0] SRAM_DQ;

    parameter CLK = 20;
    parameter SRAM_CLK = 40;
    reg clk = 0;
    reg rst = 0;

    ARM_Module arm(
        .clk(clk),
        .rst(rst),
        .SRAM_DQ(SRAM_DQ),            
        .SRAM_ADDR(SRAM_ADDR),             
        .SRAM_UB_N(SRAM_UB_N),              
        .SRAM_LB_N(SRAM_LB_N),             
        .SRAM_WE_N(SRAM_WE_N),      
        .SRAM_CE_N(SRAM_CE_N),     
        .SRAM_OE_N(SRAM_OE_N) 
    );
    SRAM sram(
        .clk(SRAM_CLK),
        .rst(rst),
        .sram_dq(SRAM_DQ),            
        .sram_addr(SRAM_ADDR),                         
        .sram_we_en(SRAM_WE_N)         
    );
    always #CLK clk = ~clk;
    initial begin 
        #(CLK) rst = 1;
        #(3*CLK) rst = 0;
        #(1000*CLK)
        $stop;
    end


endmodule
