`include "Constants.v"

module ARM_Module(
	clk, 
	rst
);

    input clk, rst;

    wire freeze, branch_taken, flush;

    wire[`ADDRESS_LEN - 1:0] branch_addr, if_stage_pc_out,
	    if_stage_instruction_out, ex_stage_pc_out,
	    mem_stage_pc_out, wb_stage_pc_out;

    wire id_stage_wb_en_out, id_stage_mem_r_en, id_stage_mem_w_en, id_stage_b, id_stage_s, id_stage_imm;
    wire[`ADDRESS_LEN - 1 : 0] id_stage_pc_out;
    wire[`EXEC_COMMAND_LEN - 1 : 0] id_stage_exec_cmd;
    wire[`REGISTER_FILE_LEN - 1 : 0] id_stage_val_r_n, id_stage_val_r_m;
    wire[`SHIFT_OPERAND_LEN - 1 : 0] id_stage_shift_operand;
    wire[`SIGNED_IMM_LEN - 1 : 0] id_stage_signed_imm_24;
    wire[`REGISTER_FILE_ADDRESS_LEN - 1 : 0] id_stage_dest;

    assign freeze = 1'b0;
    assign flush = 1'b0;
    assign branch_taken = 1'b0;
    assign branch_addr = `ADDRESS_LEN'b0;

    IF_Stage_Module if_stage_module(
	    .clk(clk),
	    .rst(rst),
	    .freeze(freeze),
	    .flush(flush),
	    .branch_taken(branch_taken),
	    .branch_addr(branch_addr),
	    .pc(if_stage_pc_out),
	    .instruction(if_stage_instruction_out)
    );

    // ToDo: Fill empty in/outputs
    ID_Stage_Module id_stage_module (
        .clk(clk),
        .rst(rst),
        .flush(flush),
        .pc_in(if_stage_pc_out),
        .instruction(if_stage_instruction_out),
        .wb_result(),
        .wb_en_in(),
        .wb_dest(),
        .sr(),
        
        .wb_en_out(id_stage_wb_en_out),
        .mem_r_en(id_stage_mem_r_en),
        .mem_w_en(id_stage_mem_w_en),
        .b(id_stage_b),
        .s(id_stage_s),
        .exec_cmd(id_stage_exec_cmd),
        .pc_out(id_stage_pc_out),
        .val_r_n(id_stage_val_r_n),
        .val_r_m(id_stage_val_r_m),
        .imm(id_stage_imm),
        .shift_operand(id_stage_shift_operand),
        .signed_imm_24(id_stage_signed_imm_24),
        .dest(id_stage_dest) 
    );

    EXE_Stage_Module ex_stage_module (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .pc_in(id_stage_pc_out),
        .pc_out(ex_stage_pc_out) 
    );

    MEM_Stage_Module mem_stage_module (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .pc_in(ex_stage_pc_out),
        .pc_out(mem_stage_pc_out)
    );

    WB_Stage wb_stage (
        .clk(clk),
        .rst(rst),
        .pc_in(mem_stage_pc_out),
        .pc_out(wb_stage_pc_out)
    );

endmodule;