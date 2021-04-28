`include "Constants.v"

module Control_Unit (
    mode,
    opcode,
    s,
    exec_command,
    mem_read,
    mem_write,
    wb_en,
    branch,
    status_update_en
);
    input [`MODE_LEN - 1 : 0] mode;
    input [`OPCODE_LEN - 1 : 0] opcode;
    input s;
    output reg [`EXECUTE_COMMAND_LEN - 1 : 0] exec_command;
    output reg mem_read, mem_write, wb_en, branch, status_update_en;

  //  assign status_write_enable = s; // not sure about this
    always @(mode, opcode, s) begin
        mem_read = `ZERO;
        mem_write = `ZERO;
        wb_en = `ZERO;
        branch = `ZERO;

        case (mode)
            `ARITHMETIC_MODE : begin
		status_update_en = s;
                case (opcode)
                    `MOV : begin
                        exec_command = `EXEC_MOV;
                        wb_en = `ONE;
                    end
                    
                    `MVN : begin
                        exec_command = `EXEC_MVN;
                        wb_en = `ONE;
                    end

                    `ADD : begin
                        exec_command = `EXEC_ADD;
                        wb_en = `ONE;
                    end

                    `ADC : begin
                        exec_command = `EXEC_ADC;
                        wb_en = `ONE;
                    end

                    `SUB : begin
                        exec_command = `EXEC_SUB;
                        wb_en = `ONE;
                    end

                    `SBC : begin
                        exec_command = `EXEC_SBC;
                        wb_en = `ONE;
                    end

                    `AND : begin
                        exec_command = `EXEC_AND;
                        wb_en = `ONE;
                    end

                    `ORR : begin
                        exec_command = `EXEC_ORR;
                        wb_en = `ONE;
                    end

                    `EOR : begin
                        exec_command = `EXEC_EOR;
                        wb_en = `ONE;
                    end

                    `CMP : begin
                        exec_command = `EXEC_CMP;
                    end

                    `TST : begin
                        exec_command = `EXEC_TST;
                    end

                    `LDR : begin
                        exec_command = `EXEC_LDR;
                        wb_en = `ONE;
                    end

                    `STR : begin
                        exec_command = `EXEC_STR;
                    end
                endcase
            end  

            `MEMORY_MODE : begin
                exec_command = `EXEC_MEM;
                if(s == `ONE) begin //LDR
                    mem_read = `ONE;
                    wb_en = `ONE;
                end
                else if(s == `ZERO) begin //STR
                    mem_write = `ONE;
                end
            end

            `BRANCH_MODE : begin
                branch = `ONE;
            end 
        endcase
    end

endmodule