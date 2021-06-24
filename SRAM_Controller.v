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

    inout[2*`SRAM_DATA_LEN-1:0] SRAM_DQ;

    output [2*`REGISTER_FILE_LEN-1:0] read_data;
    output [`SRAM_ADDR_LEN-1:0] SRAM_ADDR;
    output SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N;
    output SRAM_WE_N;
    output ready;

    reg [2:0] ps, ns;
    wire waiting_for_write;
    wire waiting_for_read;
    // reg[2*`SRAM_DATA_LEN-1:0] SRAM_DQ_reg;

    always @(posedge clk , posedge rst)begin
      if(rst) begin
          ps <= `IDLE_STATE;
          ns <= `IDLE_STATE;
      end
      else ps <= ns;
    end

    assign SRAM_UB_N = `LOW_ACTIVE;
    assign SRAM_LB_N = `LOW_ACTIVE;
    assign SRAM_CE_N = `LOW_ACTIVE;
    assign SRAM_OE_N = `LOW_ACTIVE;
    assign SRAM_DQ = waiting_for_write ? write_data: 64'bz;
    assign ready = ns == `IDLE_STATE ? `ONE : `ZERO;
    assign SRAM_WE_N = waiting_for_write ? `LOW_ACTIVE : ~`LOW_ACTIVE;
    assign read_data = SRAM_DQ;
    assign waiting_for_write = ps == `START_WRITE_STATE ? `ONE :
                            ps == `IDLE_STATE ? `ZERO: waiting_for_write;
    assign waiting_for_read = ps == `START_READ_STATE ? `ONE :
                            ps == `IDLE_STATE ? `ZERO: waiting_for_read;
    assign SRAM_ADDR = address[18:2];

    always @(ps, write_en, read_en)begin
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
                ns <= `WAITING_4;
            end
            `WAITING_4: begin
                ns <= `END_SRAM_STATE;
            end
            `END_SRAM_STATE: begin
                ns <= `IDLE_STATE;
            end
            default:ns <= ns;
        endcase
    end

endmodule
