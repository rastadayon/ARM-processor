`include "Constants.v"
`timescale 1ns/1ns

module Register (
	clk,
	rst,
	ld, //load and freeze are opposites in action
	clr,
	inp,
	out
);
parameter n = `ADDRESS_LEN;
input clk,
rst,
ld,
clr;
input [n-1:0]inp;
output reg [n-1:0]out;

always @(posedge clk, posedge rst) begin
	if (rst) out <= {(n){1'b0}};
        else begin
            if(clr) out <= {(n){1'b0}};
            else if(ld) out <= inp;
            else out <= out;
        end
end
endmodule
