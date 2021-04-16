
`include "Constants.v"

module EX_Stage_Module (
    clk,
    rst,
    freeze,
    pc_in,
    pc_out 
);
    input clk, rst, freeze;
    input[`ADDRESS_LEN - 1 : 0] pc_in;
    output[`ADDRESS_LEN - 1 : 0] pc_out;

    wire[`ADDRESS_LEN - 1 : 0] ex_stage_pc_out;

    EX_Stage ex_stage (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .pc_in(pc_in),
        .pc_out(ex_stage_pc_out)
    );

    EX_Stage_Reg ex_stage_reg (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .pc_in(ex_stage_pc_out),
        .pc_out(pc_out)
    );

endmodule
