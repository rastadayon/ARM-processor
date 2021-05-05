`include "Constants.v"

module ALU (
    val_1,
    val_2,
    exec_cmd,
    carry_in,

    res,
    status_reg
);

input[`REGISTER_FILE_LEN - 1 : 0] val_1, val_2;
input[`EXEC_COMMAND_LEN - 1 : 0] exec_cmd;
input carry_in;

output[`REGISTER_FILE_LEN - 1 : 0] res;
output[`STATUS_REG_LEN - 1 : 0] status_reg;

reg [`REGISTER_FILE_LEN - 1 : 0] res_tmp;
reg carry_out, over_flow;

wire is_negative, is_zero, val_1_sign, val_2_sign, res_sign;

assign res_sign = res_tmp[`REGISTER_FILE_LEN - 1];
assign is_negative = res_sign;
assign is_zero = (res_tmp == `REGISTER_FILE_LEN'b0 ? 1 : 0);
assign res = res_tmp;
assign status_reg = {is_zero, carry_out, is_negative, over_flow};
assign val_1_sign = val_1[`REGISTER_FILE_LEN - 1];
assign val_2_sign = val_2[`REGISTER_FILE_LEN - 1];

always @(*) begin
    carry_out = `ZERO;
    over_flow = `ZERO;

    case (exec_cmd)
        `EXEC_MOV: res_tmp = val_2;
        `EXEC_MVN: res_tmp = ~val_2;
        `EXEC_ADD: 
            begin 
                {carry_out, res_tmp} = val_1 + val_2;
                if (val_1_sign == val_2_sign & val_1_sign != res_sign) begin
                    over_flow = `ONE;
                end
            end
        `EXEC_ADC: 
            begin 
                {carry_out, res_tmp} = val_1 + val_2 + carry_in;
                if (val_1_sign == val_2_sign & val_1_sign != res_sign) begin
                    over_flow = `ONE;
                end
            end
        `EXEC_SUB: 
            begin 
                {carry_out, res_tmp} = {val_1_sign, val_1} - {val_2_sign, val_2};
                if (val_1_sign != val_2_sign & val_1_sign != res_sign) begin
                    over_flow = `ONE;
                end
            end
        // ToDo: What is the functionality?
        `EXEC_SBC:;
        `EXEC_AND: res_tmp = val_1 & val_2;
        `EXEC_ORR: res_tmp = val_1 | val_2;
        `EXEC_EOR: res_tmp = val_1 ^ val_2;
        // ToDo: What is the functionality?
        `EXEC_CMP:;
        // ToDo: What is the functionality?
        `EXEC_TST:;
        // ToDo: What is the functionality?
        `EXEC_LDR:;
        // ToDo: What is the functionality?
        `EXEC_STR:;
        // ToDo: What is the functionality?
        default:; 
    endcase
    
end

endmodule