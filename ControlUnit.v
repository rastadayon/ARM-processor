`include "Constants.v"

module ControlUnit (
    mode,
    opcode,
    s,
    exec_command,
    mem_read,
    mem_write,
    wb_enable,
    branch,
    status_write_enable
);
    input [`MODE_LEN - 1 : 0] mode;
    input [`OPCODE_LEN - 1 : 0] opcode;
    input s;
    output reg [`EXECUTE_COMMAND_LEN - 1 : 0] exec_command;
    output reg mem_read, mem_write, wb_enable, branch, status_write_enable;

    always @(mode, opcode, s) begin
        
    end

endmodule