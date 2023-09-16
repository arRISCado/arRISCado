`ifndef TESTBENCH

`ifdef ROM_FILE
`define ROM_FILE  "../../project/init_rom.txt"
`endif

// Top Level Target for Nano 9k
`include "../../project/cpu.v"

module nano9k (
    input clk,
    input btn1
);
    cpu cpu(clk, btn1);
    
endmodule

`endif
