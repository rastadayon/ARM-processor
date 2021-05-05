`define ONE 1'b1
`define ZERO 1'b0

// IF Stage:
`define ADDRESS_LEN	32
`define INSTRUCTION_LEN	32
`define INSTRUCTION_MEM_WORD_LEN 8
`define INSTRUCTION_MEM_SIZE 256

// ID Stage:
`define SHIFT_OPERAND_LEN 12
`define SIGNED_IMM_LEN 24
// Register File
`define REGISTER_FILE_ADDRESS_LEN 4
`define REGISTER_FILE_SIZE 15
`define REGISTER_FILE_LEN 32
// Control Unit
`define MODE_LEN 2
`define OPCODE_LEN 4
`define EXECUTE_COMMAND_LEN 4
`define CONTROL_UNIT_OUT_LEN 9
// Architecture Specific Values
`define ARITHMETIC_MODE 2'b00
`define MEMORY_MODE 2'b01
`define BRANCH_MODE 2'b01
// Arithmetic commands
`define NOP 4'b0000 // No operation
`define MOV 4'b1101 // Move
`define MVN 4'b1111 // Move not
`define ADD 4'b0100 // Add
`define ADC 4'b0101 // Add with carry
`define SUB 4'b0010 // Subtraction
`define SBC 4'b0110 // Subtract with carry
`define AND 4'b0000 // And
`define ORR 4'b1100 // Or
`define EOR 4'b0001 // Exclusive or
`define CMP 4'b1010 // Compare
`define TST 4'b1000 // Test
// Memory commands
`define LDR 4'b0100 // Load register
`define STR 4'b0100 // Store register
// Execution codes
`define EXEC_COMMAND_LEN 4
`define EXEC_MOV 4'b0001
`define EXEC_MVN 4'b1001
`define EXEC_ADD 4'b0010
`define EXEC_ADC 4'b0011
`define EXEC_SUB 4'b0100
`define EXEC_SBC 4'b0101
`define EXEC_AND 4'b0110
`define EXEC_ORR 4'b0111
`define EXEC_EOR 4'b1000
`define EXEC_CMP 4'b1100
`define EXEC_TST 4'b1110
`define EXEC_MEM 4'b0010
`define EXEC_LDR 4'b0010
`define EXEC_STR 4'b0010
// Condition check
`define COND_LEN 4
`define EQ 4'b0000
`define NE 4'b0001
`define CS_HS 4'b0010
`define CC_LO 4'b0011
`define MI 4'b0100
`define PL 4'b0101
`define VS 4'b0110
`define VC 4'b0111
`define HI 4'b1000
`define LS 4'b1001
`define GE 4'b1010
`define LT 4'b1011
`define GT 4'b1100
`define LE 4'b1101
`define AL 4'b1110

// Exe Stage:
`define STATUS_REG_LEN 4
