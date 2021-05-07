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

MUX_2 #(`REGISTER_FILE_LEN) wb_mux (
    .sel(mem_r_en),
    .inp1(alu_res),
    .inp2(mem_res),
    .out(wb_value)
);
    
endmodule
