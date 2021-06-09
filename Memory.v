`include "Constants.v"
`timescale 1ns/1ns

module Memory (
    clk, rst,
    alu_res,
    val_r_m,
    mem_w_en,
    mem_r_en,
    mem_out
);

    input clk, rst, mem_w_en, mem_r_en;
    input [`REGISTER_FILE_LEN - 1 : 0] alu_res;
    input [`ADDRESS_LEN - 1 : 0] val_r_m;

    output [`REGISTER_FILE_LEN - 1 : 0] mem_out;


    reg[`MEM_WORD_LEN - 1 : 0] data [`MEM_SIZE - 1 : 0];

    wire [`ADDRESS_LEN - 1 : 0] aligned_address = {alu_res[`ADDRESS_LEN - 1 : 2], 2'b00} - `ADDRESS_LEN'd1024;

    assign mem_out = mem_r_en ? data[aligned_address] : `REGISTER_FILE_LEN'd0;

    integer i;
	always @(posedge clk, posedge rst) begin
		if (rst) begin
			for (i = 0; i < `MEM_SIZE ; i = i + 1) begin
                data [i] <= i;
            end
		end
		else if (mem_w_en) begin
			data[aligned_address] <= val_r_m;
		end
	end

endmodule