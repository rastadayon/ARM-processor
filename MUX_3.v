`include "Constants.v"

module MUX_3 (
    inp1,
    inp2,
    inp3,
    sel,
    out
);
    parameter n;
    input [1 : 0] sel;
    input [n - 1 : 0] inp1, inp2, inp3;

    output [n - 1 : 0] out;

    assign out = (sel == `FORWARDING_NON_SELECT) ? inp1
            : ((sel == `FORWARDING_MEM_SELECT) ? inp2 
            : ((sel == `FORWARDING_WB_SELECT) ? inp3 : out));
endmodule