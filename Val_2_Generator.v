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

output [`REGISTER_FILE_LEN - 1 : 0] val_2;


endmodule