`include "Constants.v"

module Hazard_Detection (
    two_src,
    r_n,
    mem_dest,
    mem_wb_en,
    exe_dest,
    exe_wb_en,

    hazard
);

input two_src, mem_wb_en, exe_wb_en;
input[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] r_n, mem_dest, exe_dest;

output hazard;

endmodule