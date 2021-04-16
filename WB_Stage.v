`include "Constants.v"

module WB_Stage (
    clk,
    rst,
    pc_in,
    pc_out
);

    input clk, rst;
    input [`ADDRESS_LEN - 1 : 0] pc_in;
    output[`ADDRESS_LEN - 1 : 0] pc_out;

    assign pc_out = pc_in;
    

endmodule
