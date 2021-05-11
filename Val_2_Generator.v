`include "Constants.v"

module Val_2_Generator (
    val_r_m,
    shift_operand,
    imm,
    is_mem_related,

    val_2
);

    input imm, is_mem_related;
    input [`REGISTER_FILE_LEN - 1 : 0] val_r_m;
    input [`SHIFT_OPERAND_LEN - 1 : 0] shift_operand;

    output reg [`REGISTER_FILE_LEN - 1 : 0] val_2;

    reg [`REGISTER_FILE_LEN - 1 : 0] immediate_shifted;
    integer i, j;
    wire [`ROTATE_IMM_LEN - 1 : 0] rotate_imm;
    wire [`SHIFT_IMM_LEN - 1 : 0] shift_imm;
    wire [1 : 0] shift;

    assign rotate_imm = shift_operand[11 : 8];
    assign shift_imm = shift_operand[11 : 7];
    assign shift = shift_operand[6 : 5];

    always @(*) begin
        if(is_mem_related)
            val_2 = {20'b0, shift_operand};
        else if(imm) begin
            immediate_shifted = {24'b0, shift_operand [`IMMEDIATE_LEN - 1 : 0]};
            for (i = 0; i < {rotate_imm, `ZERO}; i = i + 1) begin
                immediate_shifted = {immediate_shifted[0], immediate_shifted[`REGISTER_FILE_LEN - 1 : 1]};
            end
            val_2 = immediate_shifted;
        end
        else begin // since we do not implement the register shift, we have not checked for 4th bit being 0 condition.
            case (shift)
                `LSL: val_2 = val_r_m << shift_imm;
                `LSR: val_2 = val_r_m >> shift_imm;
                `ASR: val_2 = val_r_m >>> shift_imm;
                `ROR: begin
                    val_2 = val_r_m;
                    for (j = 0; j < shift_imm ; j = j + 1) begin
                        val_2 = {val_2[0], val_2[`REGISTER_FILE_LEN - 1 : 1]};
                    end
                end
                default: val_2 = val_r_m << shift_imm;
            endcase
        end
    end


endmodule