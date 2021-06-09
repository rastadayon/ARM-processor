`include "Constants.v"
`timescale 1ns/1ns

module SRAM_Controller(
    clk, 
    rst,
    write_en, 
    read_en,
    address,
    write_data,
    read_data,
    ready,
    SRAM_DQ,
    SRAM_ADDR,
    SRAM_UB_N,              
    SRAM_LB_N,             
    SRAM_WE_N,      
    SRAM_CE_N,     
    SRAM_OE_N        
);
    input clk, rst, write_en, read_en;
    input[`ADDRESS_LEN-1:0] address;
    input [`REGISTER_FILE_LEN-1:0] write_data;

    inout[`SRAM_DATA_LEN-1:0] SRAM_DQ;

    output [`REGISTER_FILE_LEN-1:0] read_data;
    output [`SRAM_ADDR_LEN-1:0] SRAM_ADDR;
    output ready, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N;

    reg ready_reg, SRAM_WE_N_reg;
    reg [2:0] ps, ns;
    reg waiting_for_write;
    reg waiting_for_read;
    reg [`SRAM_ADDR_LEN-1:0] SRAM_ADDR_reg;
    reg [`SRAM_DATA_LEN-1:0] SRAM_DQ_reg;
    reg [`REGISTER_FILE_LEN-1:0] read_data_reg;

    assign SRAM_UB_N = `LOW_ACTIVE;
    assign SRAM_LB_N = `LOW_ACTIVE;
    assign SRAM_CE_N = `LOW_ACTIVE;
    assign SRAM_OE_N = `LOW_ACTIVE;

    assign ready = ready_reg;
    assign SRAM_WE_N = SRAM_WE_N_reg;
    assign SRAM_ADDR = SRAM_ADDR_reg;
    assign SRAM_DQ = SRAM_DQ_reg;
    assign read_data = read_data_reg;

    
    always @(posedge clk , posedge rst)begin
      if(rst) ps <= `IDLE_STATE;
      else ps <= ns;
    end

    always @(ps) begin
        ready_reg = `ZERO;
        SRAM_WE_N_reg = ~`LOW_ACTIVE;
        SRAM_DQ_reg = `SRAM_DATA_LEN'bz;
        
        case(ps)
            `IDLE_STATE: begin  
                ready_reg <= `ONE;
            end
            `START_WRITE_STATE: begin
                ready_reg <= `ZERO;
                SRAM_WE_N_reg <= `LOW_ACTIVE;
                SRAM_DQ_reg <= write_data;
                SRAM_ADDR_reg <= address;
            end
            `START_READ_STATE: begin
                ready_reg <= `ZERO;
                SRAM_ADDR_reg <= address;
            end
            `WAITING_1: begin
                ready_reg <= `ZERO;
            end
            `WAITING_2: begin
                ready_reg <= `ZERO;
                read_data_reg <= SRAM_DQ;
            end
            `WAITING_3: begin
               ready_reg <= `ZERO;
            end
            `END_WRITE_STATE: begin
                ready_reg <= `ONE;
            end
            `END_READ_STATE: begin
                ready_reg <= `ONE;
            end
            default:;
            
        endcase
    end

    always @(ps, write_en, read_en)begin
        case(ps)
            `IDLE_STATE: begin  
                ns <= read_en ? `START_READ_STATE :
                write_en ? `START_WRITE_STATE :`IDLE_STATE;
                waiting_for_write <= `ZERO;
                waiting_for_read <= `ZERO;
            end
            `START_WRITE_STATE: begin
                ns <= `WAITING_1;
                waiting_for_write <= `ONE;
            end
            `START_READ_STATE: begin
                ns <= `WAITING_1;
                waiting_for_read <= `ONE;
            end
            `WAITING_1: begin
                ns <= `WAITING_2;
            end
            `WAITING_2: begin
                ns <= `WAITING_3;
            end
            `WAITING_3: begin
                ns <= waiting_for_write ? `END_WRITE_STATE :
                waiting_for_read ? `END_READ_STATE :
                ns <= ns;
            end
            `END_WRITE_STATE:
                ns <= `IDLE_STATE;
            `END_READ_STATE:
                ns <= `IDLE_STATE;
            default:ns <= ns;
        endcase
    end

endmodule
