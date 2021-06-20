`include "Constants.v"
`timescale 1ns/1ns

module Hazard_Detection (
    forwarding_enable,
    two_src,
    r_n, //src1
    r_d, //src2
    mem_dest,
    mem_wb_en,
    exe_dest,
    exe_wb_en,
    exe_mem_r_en,

    hazard
);

    input two_src, mem_wb_en, exe_wb_en, forwarding_enable, exe_mem_r_en;
    input[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] r_n, r_d, mem_dest, exe_dest;

    output reg hazard;
    
    // assign hazard = ((r_n == exe_dest) && (exe_wb_en == 1'b1)) ? 1'b1
    //         : ((r_n == mem_dest) && (mem_wb_en == 1'b1)) ? 1'b1
    //         : ((r_d == exe_dest) && (exe_wb_en == 1'b1) && (two_src == 1'b1)) ? 1'b1
    //         : ((r_d == mem_dest) && (mem_wb_en == 1'b1) && (two_src == 1'b1)) ? 1'b1
    //         : 1'b0;

    always @(*) begin
        hazard = `ZERO;
        if(forwarding_enable) begin
            if((r_n == exe_dest) && exe_mem_r_en)
                hazard = `ONE;
            else if ((r_d == exe_dest) && exe_mem_r_en && two_src)
                hazard = `ONE;
        end
        else begin
            if((r_n == exe_dest) && exe_wb_en)
                hazard = `ONE; 
            else if ((r_n == mem_dest) && mem_wb_en)
                hazard = `ONE;
            else if ((r_d == exe_dest) && exe_wb_en && two_src)
                hazard = `ONE;
            else if ((r_d == mem_dest) && mem_wb_en && two_src)
                hazard = `ONE;
        end
    end

endmodule