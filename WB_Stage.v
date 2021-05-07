`include "Constants.v"

module WB_Stage (
    mem_r_en,
    alu_res,
    mem_res,

    wb_value
);

input mem_r_en;
input[`REGISTER_FILE_LEN - 1 : 0] alu_res, mem_res;

output[`REGISTER_FILE_LEN - 1 : 0] wb_value;
    
endmodule
