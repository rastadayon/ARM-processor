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
    input[`REGISTER_FILE_LEN-1:0] write_data;

    inout[`SRAM_DATA_LEN-1:0] SRAM_DQ;

    output reg[`REGISTER_FILE_LEN-1:0] read_data;
    output reg[`SRAM_ADDR_LEN-1:0] SRAM_ADDR;
    output SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N;
    output reg SRAM_WE_N;
    output ready;

    reg [2:0] ps, ns;
    reg waiting_for_write;
    reg waiting_for_read;
    reg[`SRAM_DATA_LEN-1:0] SRAM_DQ_reg;

    assign SRAM_UB_N = `LOW_ACTIVE;
    assign SRAM_LB_N = `LOW_ACTIVE;
    assign SRAM_CE_N = `LOW_ACTIVE;
    assign SRAM_OE_N = `LOW_ACTIVE;
    assign SRAM_DQ = waiting_for_write ? SRAM_DQ_reg: `SRAM_DATA_LEN'bz;
    assign ready = (rst == `ONE)? `ONE: 
        (
            ((ps == `IDLE_STATE) && (read_en == `ONE || write_en == `ONE)) ? `ZERO
            :(ps == `IDLE_STATE) ? `ONE 
            :(ps == `START_WRITE_STATE) ? `ZERO
            :(ps == `START_READ_STATE) ? `ZERO
            :(ps == `WAITING_1) ? `ZERO
            :(ps == `WAITING_2) ? `ZERO
            :(ps == `WAITING_3) ? `ZERO
            :(ps == `END_WRITE_STATE) ? `ONE 
            :(ps == `END_READ_STATE) ? `ONE 
            :ready
        );
    
    always @(posedge clk , posedge rst)begin
      if(rst) ps <= `IDLE_STATE;
      else ps <= ns;
    end

    always @(ps) begin
        case(ps)
            `IDLE_STATE: begin  
                SRAM_WE_N <= ~`LOW_ACTIVE;
                waiting_for_write <= `ZERO;
                waiting_for_read <= `ZERO;
            end
            `START_WRITE_STATE: begin
                waiting_for_read <= `ZERO;
                SRAM_WE_N <= ~`LOW_ACTIVE;
                SRAM_DQ_reg <= write_data;
                SRAM_ADDR <= address[18:2];
                waiting_for_write <= `ONE;
            end
            `START_READ_STATE: begin
                waiting_for_write <= `ZERO;
                SRAM_WE_N <= ~`LOW_ACTIVE;
                SRAM_DQ_reg <= write_data;
                SRAM_ADDR <= address[18:2];
                waiting_for_read <= `ONE;
            end
            `WAITING_1: begin
                SRAM_WE_N <= ~`LOW_ACTIVE;
                SRAM_ADDR <= SRAM_ADDR;
                SRAM_DQ_reg <= write_data;
            end
            `WAITING_2: begin
                SRAM_WE_N <= waiting_for_write ? `LOW_ACTIVE: ~`LOW_ACTIVE;
                SRAM_ADDR <= SRAM_ADDR;
                SRAM_DQ_reg <= write_data;
            end
            `WAITING_3: begin
               SRAM_DQ_reg <= write_data;
               read_data <= SRAM_DQ;
            end
            `END_WRITE_STATE: begin
                SRAM_DQ_reg <= write_data;
            end
            `END_READ_STATE: begin
                read_data <= SRAM_DQ;
            end
            default:;
            
        endcase
    end

    always @(ps, posedge write_en, posedge read_en)begin
        case(ps)
            `IDLE_STATE: begin  
                ns <= read_en ? `START_READ_STATE :
                write_en ? `START_WRITE_STATE :`IDLE_STATE;
            end
            `START_WRITE_STATE: begin
                ns <= `WAITING_1;
            end
            `START_READ_STATE: begin
                ns <= `WAITING_1;
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
                ns;
            end
            `END_WRITE_STATE: begin
                ns <= `IDLE_STATE;
            end
                
            `END_READ_STATE:begin
                ns <= `IDLE_STATE;
            end
            default:ns <= ns;
        endcase
    end

endmodule
