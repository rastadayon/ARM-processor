`include "Constants.v"

module Hazard_Detection (
    two_src,
    r_n, //src1
    r_d, //src2
    mem_dest,
    mem_wb_en,
    exe_dest,
    exe_wb_en,

    hazard
);

    input two_src, mem_wb_en, exe_wb_en;
    input[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] r_n, r_d, mem_dest, exe_dest;

    output hazard;
    
    assign hazard = ((r_n == exe_dest) && (exe_wb_en == 1'b1)) ? 1'b1
            : ((r_n == mem_dest) && (mem_wb_en == 1'b1)) ? 1'b1
            : ((r_d == exe_dest) && (exe_wb_en == 1'b1) && (two_src == 1'b1)) ? 1'b1
            : ((r_d == mem_dest) && (mem_wb_en == 1'b1) && (two_src == 1'b1)) ? 1'b1
            : 1'b0;

endmodule