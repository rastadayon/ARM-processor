`include "Constants.v"

module ID_Stage_Reg (
    clk,
    rst,
    freeze,
    flush,
    pc_in,
    pc_out
);
    input clk, rst, freeze, flush;
    input[`ADDRESS_LEN - 1 : 0] pc_in;
    output[`ADDRESS_LEN - 1 : 0] pc_out;

    Register #(`ADDRESS_LEN) pc_reg(.clk(clk), .rst(rst), .ld(~freeze), .clr(flush), .inp(pc_in), .out(pc_out));
endmodule