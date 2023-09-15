// Top Level Target for Nano 9k
`include "../../project/cpu.v"

module nano9k (
    input clk,
    input btn1,
    output pwm1
);
    cpu cpu(clk, btn1, pwm1);
    
endmodule
