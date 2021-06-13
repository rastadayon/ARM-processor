`include "Constants.v"
`timescale 1ns/1ns

module SRAM (
    clk,
    rst,
    sram_we_en,
    sram_addr,
    sram_dq
);

    input clk, rst, sram_we_en;
    input[`SRAM_ADDR_LEN-1:0] sram_addr;
    inout[`SRAM_DATA_LEN-1:0] sram_dq;

    reg [`SRAM_DATA_LEN-1:0] memory[0:`SRAM_SIZE-1];

    assign #30 sram_dq = sram_we_en ? memory[sram_addr]: `SRAM_DATA_LEN'bz;

    always @(posedge clk) begin
        if (~sram_we_en) begin
            memory[sram_addr] <= sram_dq;
        end
    end

endmodule