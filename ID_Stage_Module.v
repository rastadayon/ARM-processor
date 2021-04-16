
`include "Constants.v"

module ID_Stage_Module (
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

    wire[`ADDRESS_LEN - 1 : 0] id_stage_pc_out;

    ID_Stage id_stage (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .flush(flush),
        .pc_in(pc_in),
        .pc_out(id_stage_pc_out)
    );

    ID_Stage_Reg id_stage_reg (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .flush(flush),
        .pc_in(id_stage_pc_out),
        .pc_out(pc_out)
    );

endmodule