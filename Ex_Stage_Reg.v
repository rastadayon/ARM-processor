
`include "Constants.v"

module EX_Stage_Reg (
    clk,
    rst,
    freeze,
    pc_in,
    pc_out
);
    input clk, rst, freeze;
    input[`ADDRESS_LEN - 1 : 0] pc_in;
    output[`ADDRESS_LEN - 1 : 0] pc_out;

    Register #(`ADDRESS_LEN) pc_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(flush), .inp(pc_in), .out(pc_out));
endmodule