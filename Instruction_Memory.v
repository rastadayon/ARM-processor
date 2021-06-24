`include "Constants.v"
`timescale 1ns/1ns

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
// initial begin
// 	for (i = 0; i < mem_size; i = i + 4) begin
//             {memory[i], memory[i+1], memory[i+2], memory[i+3]} = NOP;
//         end
// end

initial begin 
	// {memory[0], memory[1], memory[2], memory[3]} = 32'b1110_01_0_0100_0_0000_0001_000000000000; //STR    R1 ,[R0],#0  //MEM[0] = 1
	// {memory[4], memory[5], memory[6], memory[7]} = 32'b1110_01_0_0100_1_0000_1011_000000000000; //LDR    R11,[R0],#0  //R11 = 1

    {memory[0], memory[1], memory[2], memory[3]} = 32'b1110_00_1_1101_0_0000_0000_000000010100; //MOV    R0 ,#20     //R0 = 20
	{memory[4], memory[5], memory[6], memory[7]} = 32'b1110_00_1_1101_0_0000_0001_101000000001; //MOV    R1 ,#4096    //R1 = 4096
	{memory[8], memory[9], memory[10], memory[11]} = 32'b1110_00_1_1101_0_0000_0010_000100000011; //MOV    R2 ,#0xC0000000  //R2 = -1073741824
	{memory[12], memory[13], memory[14], memory[15]} = 32'b1110_00_0_0100_1_0010_0011_000000000010; //ADDS    R3 ,R2,R2   //R3 = -2147483648
	{memory[16], memory[17], memory[18], memory[19]} = 32'b1110_00_0_0101_0_0000_0100_000000000000; //ADC    R4 ,R0,R0   //R4 = 41
	{memory[20], memory[21], memory[22], memory[23]} = 32'b1110_00_0_0010_0_0100_0101_000100000100; //SUB    R5 ,R4,R4,LSL #2  //R5 = -123
	{memory[24], memory[25], memory[26], memory[27]} = 32'b1110_00_0_0110_0_0000_0110_000010100000; //SBC    R6 ,R0,R0,LSR #1  //R6 = 9
	{memory[28], memory[29], memory[30], memory[31]} = 32'b1110_00_0_1100_0_0101_0111_000101000010; //ORR    R7 ,R5,R2,ASR #2  //R7 = -123
	{memory[32], memory[33], memory[34], memory[35]} = 32'b1110_00_0_0000_0_0111_1000_000000000011; //AND    R8 ,R7,R3   //R8 = -2147483648
	{memory[36], memory[37], memory[38], memory[39]} = 32'b1110_00_0_1111_0_0000_1001_000000000110; //MVN    R9 ,R6    //R9 = -10

	{memory[40], memory[41], memory[42], memory[43]} = 32'b1110_00_0_0001_0_0100_1010_000000000101; //EOR    R10,R4,R5  //R10 = -84
	{memory[44], memory[45], memory[46], memory[47]} = 32'b1110_00_0_1010_1_1000_0000_000000000110; //CMP    R8 ,R6 ?? how to make sure it is working correctly?
	{memory[48], memory[49], memory[50], memory[51]} = 32'b0001_00_0_0100_0_0001_0001_000000000001; //ADDNE    R1 ,R1,R1   //R1 = 8192
	{memory[52], memory[53], memory[54], memory[55]} = 32'b1110_00_0_1000_1_1001_0000_000000001000; //TST    R9 ,R8 ??
	{memory[56], memory[57], memory[58], memory[59]} = 32'b0000_00_0_0100_0_0010_0010_000000000010; //ADDEQ    R2 ,R2,R2     //R2 = -1073741824
	{memory[60], memory[61], memory[62], memory[63]} = 32'b1110_00_1_1101_0_0000_0000_101100000001; //MOV    R0 ,#1024    //R0 = 1024
	{memory[64], memory[65], memory[66], memory[67]} = 32'b1110_01_0_0100_0_0000_0001_000000000000; //STR    R1 ,[R0],#0  //MEM[1024] = 8192
	{memory[68], memory[69], memory[70], memory[71]} = 32'b1110_01_0_0100_1_0000_1011_000000000000; //LDR    R11,[R0],#0  //R11 = 8192
	{memory[72], memory[73], memory[74], memory[75]} = 32'b1110_01_0_0100_0_0000_0010_000000000100; //STR    R2 ,[R0],#4  //MEM[1028] = -1073741824
	{memory[76], memory[77], memory[78], memory[79]} = 32'b1110_01_0_0100_0_0000_0011_000000001000; //STR    R3 ,[R0],#8  //MEM[1032] = -2147483648

	{memory[80], memory[81], memory[82], memory[83]} = 32'b1110_01_0_0100_0_0000_0100_000000001101; //STR    R4 ,[R0],#13  //MEM[1036] = 41
	{memory[84], memory[85], memory[86], memory[87]} = 32'b1110_01_0_0100_0_0000_0101_000000010000; //STR    R5 ,[R0],#16  //MEM[1040] = -123
	{memory[88], memory[89], memory[90], memory[91]} = 32'b1110_01_0_0100_0_0000_0110_000000010100; //STR    R6 ,[R0],#20  //MEM[1044] = 9
	{memory[92], memory[93], memory[94], memory[95]} = 32'b1110_01_0_0100_1_0000_1010_000000000100; //LDR    R10,[R0],#4  //R10 = -1073741824 ?
	{memory[96], memory[97], memory[98], memory[99]} = 32'b1110_01_0_0100_0_0000_0111_000000011000; //STR    R7 ,[R0],#24  //MEM[1048] = -123
	{memory[100], memory[101], memory[102], memory[103]} = 32'b1110_00_1_1101_0_0000_0001_000000000100; //MOV    R1 ,#4    //R1 = 4 ->
	{memory[104], memory[105], memory[106], memory[107]} = 32'b1110_00_1_1101_0_0000_0010_000000000000; //MOV    R2 ,#0    //R2 = 0
	{memory[108], memory[109], memory[110], memory[111]} = 32'b1110_00_1_1101_0_0000_0011_000000000000; //MOV R3 ,#0 //R3 = 0
	{memory[112], memory[113], memory[114], memory[115]} = 32'b1110_00_0_0100_0_0000_0100_000100000011; //ADD R4 ,R0,R3,LSL #2
	{memory[116], memory[117], memory[118], memory[119]} = 32'b1110_01_0_0100_1_0100_0101_000000000000; //LDR R5 ,[R4],#0

	{memory[120], memory[121], memory[122], memory[123]} = 32'b1110_01_0_0100_1_0100_0110_000000000100; //LDR R6 ,[R4],#4
	{memory[124], memory[125], memory[126], memory[127]} = 32'b1110_00_0_1010_1_0101_0000_000000000110; //CMP R5 ,R6
	{memory[128], memory[129], memory[130], memory[131]} = 32'b1100_01_0_0100_0_0100_0110_000000000000; //STRGT R6 ,[R4],#0
	{memory[132], memory[133], memory[134], memory[135]} = 32'b1100_01_0_0100_0_0100_0101_000000000100; //STRGT R5 ,[R4],#4
	{memory[136], memory[137], memory[138], memory[139]} = 32'b1110_00_1_0100_0_0011_0011_000000000001; //ADD R3 ,R3,#1
	{memory[140], memory[141], memory[142], memory[143]} = 32'b1110_00_1_1010_1_0011_0000_000000000011; //CMP R3 ,#3 -> 1
	{memory[144], memory[145], memory[146], memory[147]} = 32'b1011_10_1_0_111111111111111111110111 ; //BLT #-9
	{memory[148], memory[149], memory[150], memory[151]} = 32'b1110_00_1_0100_0_0010_0010_000000000001; //ADD R2 ,R2,#1
	{memory[152], memory[153], memory[154], memory[155]} = 32'b1110_00_0_1010_1_0010_0000_000000000001; //CMP R2 ,R1
	{memory[156], memory[157], memory[158], memory[159]} = 32'b1011_10_1_0_111111111111111111110011 ; //BLT #-13

	{memory[160], memory[161], memory[162], memory[163]} = 32'b1110_01_0_0100_1_0000_0001_000000000000; //LDR R1 ,[R0],#0 //R1 = -2147483648
	{memory[164], memory[165], memory[166], memory[167]} = 32'b1110_01_0_0100_1_0000_0010_000000000100; //LDR R2 ,[R0],#4 //R2 = -1073741824
	{memory[168], memory[169], memory[170], memory[171]} = 32'b1110_01_0_0100_1_0000_0011_000000001000; //STR R3 ,[R0],#8 //R3 = 41
	{memory[172], memory[173], memory[174], memory[175]} = 32'b1110_01_0_0100_1_0000_0100_000000001100; //STR R4 ,[R0],#12 //R4 = 8192
	{memory[176], memory[177], memory[178], memory[179]} = 32'b1110_01_0_0100_1_0000_0101_000000010000; //STR R5 ,[R0],#16 //R5 = -123
	{memory[180], memory[181], memory[182], memory[183]} = 32'b1110_01_0_0100_1_0000_0110_000000010100; //STR R6 ,[R0],#20 //R6 = 9
	{memory[184], memory[185], memory[186], memory[187]} = 32'b1110_10_1_0_111111111111111111111111 ; //B #-1	
end

assign out = {memory[address], memory[address+1], memory[address+2], memory[address+3]};
endmodule
