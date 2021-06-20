`include "Constants.v"

module Test_Bench ();

    parameter CLK = 100;
    reg clk = 0;
    reg rst = 0;
    ARM_Module arm(
        .clk(clk),
        .rst(rst),
        .forwarding_enable(`ZERO)
    );
    always #CLK clk = ~clk;
    initial begin 
        #(CLK) rst = 1;
        #(3*CLK) rst = 0;
        #(1000*CLK)
        $stop;
    end


endmodule
