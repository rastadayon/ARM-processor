`include "Constants.v"
`timescale 1ns/1ns

module Cache (
    clk, 
    rst,
    write_en, 
    read_en,
    address,
    write_data,
    invalidation,

    read_data,
    hit
);

input clk, rst, write_en, read_en, invalidation;
input[`CACHE_ADDR_LEN-1:0] address;
input[`CACHE_BLOCK_DATA_LEN-1:0] write_data;

output[`CACHE_DATA_LEN-1:0] read_data;
output hit;

reg[`CACHE_DATA_LEN-1:0] way_0_data [`CACHE_OFFSET_LEN:0][`CACHE_SIZE-1:0];
reg[`CACHE_DATA_LEN-1:0] way_1_data [`CACHE_OFFSET_LEN:0][`CACHE_SIZE-1:0];

reg[`CACHE_TAG_LEN-1:0] way_0_tag [`CACHE_SIZE-1:0];
reg[`CACHE_TAG_LEN-1:0] way_1_tag [`CACHE_SIZE-1:0];

reg way_0_valid [`CACHE_SIZE-1:0];
reg way_1_valid [`CACHE_SIZE-1:0];

reg recent_way_used [`CACHE_SIZE-1:0];

wire way_0_hit;
wire way_1_hit;
wire hit_way;

wire[`CACHE_TAG_LEN-1:0] tag;
wire[`CACHE_INDEX_LEN-1:0] index;
wire[`CACHE_OFFSET_LEN-1:0] offset;

integer i;
initial begin
	for (i = 0; i < `CACHE_SIZE; i = i + 1) begin
        way_0_tag[i] = `CACHE_TAG_LEN'b0; 
        way_1_tag[i] = `CACHE_TAG_LEN'b0; 
        way_0_valid[i] = `ZERO; 
        way_1_valid[i] = `ZERO; 
        recent_way_used[i] = `ONE; 
    end
end

assign tag = address[16:7];
assign index = address[6:1];
assign offset = address[0];

assign way_0_hit = way_0_valid[index] && (way_0_tag[index] == tag);
assign way_1_hit = way_1_valid[index] && (way_1_tag[index] == tag);
assign hit = way_0_hit || way_1_hit;
assign hit_way = way_0_hit ? `ZERO:
                 way_1_hit ? `ONE:
                 1'bz;

assign read_data = way_0_hit ? way_0_data[offset][index] :
                way_1_hit ? way_1_data[offset][index] :
                `CACHE_DATA_LEN'bz;

always @(posedge clk) begin
    if (hit && read_en) begin
        recent_way_used[index] <= hit_way;
    end
end

always @(posedge clk) begin
    if (write_en) begin
        if (recent_way_used[index] == `ONE) begin
            {way_0_data[1][index], way_0_data[0][index]} <= write_data;
            way_0_tag[index] <= tag;
            way_0_valid[index] <= `ONE;
            recent_way_used[index] <= `ZERO;
        end
        else if (recent_way_used[index] == `ZERO) begin
            {way_1_data[1][index], way_1_data[0][index]} <= write_data;
            way_1_tag[index] <= tag;
            way_1_valid[index] <= `ONE;
            recent_way_used[index] <= `ONE;
        end
    end
end

always @(posedge clk) begin
    if (invalidation) begin
        if (hit_way == `ZERO) begin
            way_0_valid[index] <= `ZERO;
        end
        else if (hit_way == `ONE) begin
            way_1_valid[index] <= `ZERO;
        end
    end
end
    
endmodule