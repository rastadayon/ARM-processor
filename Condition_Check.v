`include "Constants.v"

module Condition_Check (
    condition,
    status_register,
    condition_state
);
    input [`COND_LEN - 1 : 0] condition;
    input [`REGISTER_FILE_ADDRESS_LEN - 1 : 0] status_register;

    output condition_state;

    wire z, c, n, v;

    assign {z, c, n, v} = status_register;

    always @(*) begin
        case(condition)
            `EQ : condition_state = z;
            `NE : condition_state = ~z;
            `CS_HS : condition_state = c;
            `CC_LO : condition_state = ~c;
            `MI : condition_state = n;
            `PL : condition_state = ~n;
            `VS : condition_state = v;
            `VC : condition_state = ~v;
            `HI : condition_state = c & ~z;
            `LS : condition_state = ~c | z;
            `GE : condition_state = (n & v) | (~n & ~v);
            `LT : condition_state = (n & ~v) | (~n & v);
            `GT : condition_state = ~z & (n & v) | (~n & ~v);
            `LE : condition_state = z | (n & ~v) | (~n & v);
            `AL : condition_state = `ONE;
    end


endmodule