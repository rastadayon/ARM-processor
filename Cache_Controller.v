`include "Constants.v"
`timescale 1ns/1ns

module Cache_Controller(
    clk, 
    rst,
    write_en, 
    read_en,
    address,
    write_data,
    sram_read_data,
    sram_ready, 
    cache_hit,
    cache_read_data,

    read_data,
    ready,
    sram_address,
    sram_write_data,
    sram_write_en, 
    sram_read_en,
    cache_address, 
    cache_write_data,
    cache_write_en,
    cache_read_en,
    cache_invalidation
);

input clk, rst, write_en, read_en, sram_ready, cache_hit;
input[`ADDRESS_LEN-1:0] address;
input[`CACHE_DATA_LEN-1:0] write_data;
input[`CACHE_BLOCK_DATA_LEN-1:0] sram_read_data;
input[`CACHE_DATA_LEN-1:0] cache_read_data;

output[`CACHE_DATA_LEN-1:0] read_data;
output ready; 
output sram_write_en, cache_read_en, sram_read_en, cache_write_en, cache_invalidation;
output[`ADDRESS_LEN-1:0] sram_address;
output[`SRAM_DATA_LEN-1:0] sram_write_data;
output[`CACHE_ADDR_LEN-1:0] cache_address;
output[`CACHE_BLOCK_DATA_LEN-1:0] cache_write_data;

reg [2:0] ps, ns;
reg hit;
reg[`ADDRESS_LEN-1:0] address_reg;

assign sram_address = address;
assign cache_address = address[18:2];

always @(posedge clk , posedge rst)begin
    if(rst) ps <= `IDLE_STATE;
    else ps <= ns;
    end

assign ready = ns == `IDLE_STATE ? `ONE : `ZERO;

assign offset = sram_address[2];

// assign ready = (ps == `IDLE_STATE && (read_en && cache_hit)) ? `ONE :
//                 (ps == `IDLE_STATE && (read_en || write_en)) ? `ZERO :
//                 // (ps == `END_STATE) ? `ONE:
//                 (ns == `IDLE_STATE) ? `ONE:
//                 (ps == `IDLE_STATE) ? `ONE: ready;

assign read_data = (ps == `IDLE_STATE && read_en && cache_hit) ? cache_read_data : 
                   (ps == `MEM_READ_STATE && sram_ready) ? (offset ? sram_read_data[63:32] : sram_read_data[31:0]) :
                    read_data;
                    // (ps == `CACHE_WRITE_STATE) ? read_data :
                    // `CACHE_DATA_LEN'bz;

assign sram_write_data = write_data;

assign sram_write_en = (ps == `IDLE_STATE) && write_en ? `ONE : `ZERO;
// assign sram_write_en = (ps == `MEM_WRITE_STATE) ? `ONE : `ZERO;

assign cache_read_en = (ps == `IDLE_STATE) && read_en ? `ONE : `ZERO;

assign sram_read_en = (ps == `MEM_READ_STATE) ? `ONE: `ZERO;
// assign sram_read_en = (ps == `IDLE_STATE) && read_en && ~cache_hit ? `ONE: `ZERO;

assign cache_write_data = sram_read_data;

assign cache_write_en = (ps == `MEM_READ_STATE && sram_ready == `ONE) ? `ONE: `ZERO;

assign cache_invalidation = (ps == `MEM_WRITE_STATE) ? `ONE: `ZERO;

always @(ps, write_en, read_en, cache_hit, sram_ready) begin
    case(ps)
        `IDLE_STATE: begin  
            ns <= read_en && cache_hit ? `IDLE_STATE :
                  read_en && ~cache_hit? `MEM_READ_STATE:
                  write_en ? `MEM_WRITE_STATE :
                  `IDLE_STATE;
            address_reg <= address;
        end
        `MEM_READ_STATE: begin
            ns <= sram_ready ? `IDLE_STATE : `MEM_READ_STATE;
        end
        // `CACHE_WRITE_STATE: begin
        //     ns <= `IDLE_STATE;
        // end
        `MEM_WRITE_STATE: begin
            ns <= sram_ready ? `CACHE_INVALID_STATE : `MEM_WRITE_STATE;
        end
        `CACHE_INVALID_STATE: begin
            ns <= `IDLE_STATE;
        end
        // `END_STATE: begin
        //     ns <= `IDLE_STATE;
        // end
        default:;  
    endcase
end


endmodule