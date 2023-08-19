// Top Level Target for Nano 9k
`include "../../project/cpu.v"

module nano9k (
    input clk,
);
    cpu cpu(clk);
    
endmodule
