`include "Constants.v"

module WB_Stage (
    mem_r_en,
    alu_res,
    mem_res,
    wb_enable,
    dest,

    wb_value,
    wb_enable_out,
    wb_dest_out
);

    input mem_r_en, wb_enable;
    input[`REGISTER_FILE_LEN - 1 : 0] alu_res, mem_res;
    input[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] dest;

    output[`REGISTER_FILE_LEN - 1 : 0] wb_value;
    output wb_enable_out;
    output[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] wb_dest_out;

    assign wb_enable_out = wb_enable;
    assign wb_dest_out = dest;

    MUX_2 #(`REGISTER_FILE_LEN) wb_mux (
        .sel(mem_r_en),
        .inp1(alu_res),
        .inp2(mem_res),
        .out(wb_value)
    );
    
endmodule
