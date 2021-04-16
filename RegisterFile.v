`include "Constants.v"

module RegisterFile (
    clk,
    rst,
    src1,
    src2,
    dest_wb,
    result_wb,
    writeBackEn,
    reg1,
    reg2
);
    input clk, rst, writeBackEn;
    input [`REGISTER_FILE_ADDRESS_LEN - 1 : 0] src1, src2, dest_wb;
    input [`REGISTER_FILE_LEN - 1 : 0] result_wb;
    output [`REGISTER_FILE_LEN - 1 : 0] reg1, reg2;

    reg[`REGISTER_FILE_LEN - 1 : 0] registers [0 : `REGISTER_FILE_SIZE - 1];

    assign reg1 = registers[src1];
    assign reg2 = registers[src2];
    

    integer i;
    always @(negedge clk, posedge rst) begin
        if (rst) begin
            for(i=0; i<`REGISTER_FILE_SIZE; i=i+1)
                registers[i] <= i;
        end
        else if (writeBackEn)
            registers[dest_wb] <= result_wb;
    end
    
endmodule