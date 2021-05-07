`include "Constants.v"

module MEM_Stage (
    clk,
    rst,
    mem_r_en,
    mem_w_en,
    alu_res,
    val_r_m,

    mem_res
);

    input clk, rst, mem_r_en, mem_w_en;
    input[`REGISTER_FILE_LEN - 1 : 0] alu_res, val_r_m;

    output[`REGISTER_FILE_LEN - 1 : 0] mem_res;

endmodule
