
`include "Constants.v"

module MEM_Stage_Module (
    clk,
    rst,
    freeze,
    pc_in,
    pc_out 
);
    input clk, rst, freeze;
    input[`ADDRESS_LEN - 1 : 0] pc_in;
    output[`ADDRESS_LEN - 1 : 0] pc_out;

    wire[`ADDRESS_LEN - 1 : 0] mem_stage_pc_out;

    MEM_Stage mem_stage (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_in),
        .pc_out(mem_stage_pc_out)
    );

    MEM_Stage_Reg mem_stage_reg (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .pc_in(mem_stage_pc_out),
        .pc_out(pc_out)
    );

endmodule
