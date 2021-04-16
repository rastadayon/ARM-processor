`include "Constants.v"

module ID_Stage (
    clk,
    rst,
    flush,
    freeze,
    pc_in,
    pc_out
);

    input clk, rst, flush, freeze;
    input [`ADDRESS_LEN - 1 : 0] pc_in;
    output[`ADDRESS_LEN - 1 : 0] pc_out;

    assign pc_out = pc_in;
    

endmodule
