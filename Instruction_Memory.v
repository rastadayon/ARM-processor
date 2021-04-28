`include "Constants.v"

module Instruction_Memory (	
	address,
	out
);

parameter word_len = `INSTRUCTION_MEM_WORD_LEN,  mem_size = `INSTRUCTION_MEM_SIZE, inst_len = `INSTRUCTION_LEN;
input [inst_len-1:0]address;
output [inst_len-1:0]out;
reg [word_len-1:0]memory[mem_size-1:0];
parameter NOP = 32'b11100000000000000000000000000000;
integer i;
initial begin
	for (i = 0; i < mem_size; i = i + 4) begin
            {memory[i], memory[i+1], memory[i+2], memory[i+3]} = NOP;
        end
end

initial begin 
    {memory[4], memory[5], memory[6], memory[7]} = 32'b000000_00001_00010_00000_00000000000;
	{memory[8], memory[9], memory[10], memory[11]} = 32'b000000_00011_00100_00000_00000000000;
	{memory[12], memory[13], memory[14], memory[15]} = 32'b000000_00101_00110_00000_00000000000;
	{memory[16], memory[17], memory[18], memory[19]} = 32'b000000_00111_01000_00010_00000000000;
	{memory[20], memory[21], memory[22], memory[23]} = 32'b000000_01001_01010_00011_00000000000;
	{memory[24], memory[25], memory[26], memory[27]} = 32'b000000_01011_01100_00000_00000000000;
	{memory[28], memory[29], memory[30], memory[31]} = 32'b000000_01101_01110_00000_00000000000;
end

assign out = {memory[address], memory[address+1], memory[address+2], memory[address+3]};
endmodule
