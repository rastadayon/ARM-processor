`include "Constants.v"

module Register_File (
	clk,
    rst,
    reg_addr_1,
    reg_addr_2,
    wb_dest,
    wb_value,
    wb_en,
   	reg_1,
    reg_2
);
    input clk, rst, wb_en;
    input [`REGISTER_FILE_ADDRESS_LEN - 1 : 0] reg_addr_1, reg_addr_2, wb_dest;
    input [`REGISTER_FILE_LEN - 1 : 0] wb_value;
    output [`REGISTER_FILE_LEN - 1 : 0] reg_1, reg_2;

    reg[`REGISTER_FILE_LEN - 1 : 0] registers [0 : `REGISTER_FILE_SIZE - 1];

    assign reg_1 = registers[reg_addr_1];
    assign reg_2 = registers[reg_addr_2];
    

    integer i;
    always @(negedge clk, posedge rst) begin
        if (rst) begin
            for(i=0; i<`REGISTER_FILE_SIZE; i=i+1)
                registers[i] <= i;
        end
        else if (wb_en)
            registers[wb_dest] <= wb_value;
    end
    
endmodule