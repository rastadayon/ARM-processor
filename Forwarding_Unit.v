`include "Constants.v"
`timescale 1ns/1ns

module Forwarding_Unit (
    forwarding_enable,
    src1,
    src2,
    mem_dest,
    wb_dest,
    mem_wb_en,
    wb_wb_en,
    src1_select,
    src2_select
);

    input forwarding_enable, mem_wb_en, wb_wb_en;
    input [`REGISTER_FILE_ADDRESS_LEN - 1 : 0] src1, src2, mem_dest, wb_dest;

    output reg [1 : 0] src1_select, src2_select;

    always @(*) begin
        if(forwarding_enable) begin
            if(mem_wb_en && (mem_dest == src1))
                src1_select = `FORWARDING_MEM_SELECT;
            else if(wb_wb_en && (wb_dest == src1))
                src1_select = `FORWARDING_WB_SELECT;
            else src1_select = `FORWARDING_NON_SELECT;
            if(mem_wb_en && (mem_dest == src2))
                src2_select = `FORWARDING_MEM_SELECT;
            else if(wb_wb_en && (wb_dest == src2))
                src2_select = `FORWARDING_WB_SELECT;
            else src2_select = `FORWARDING_NON_SELECT;
        end
        else begin
            src1_select = `FORWARDING_NON_SELECT;
            src2_select = `FORWARDING_NON_SELECT;
        end
    end
    
endmodule