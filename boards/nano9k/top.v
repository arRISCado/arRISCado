`ifndef TESTBENCH

`ifndef ROM_FILE
`define ROM_FILE  "../../project/init_rom.txt"
`endif

// Top Level Target for Nano 9k
`include "../../project/cpu.v"
`include "../../project/uart.v"

module nano9k (
    input clk,
    input btn1,
    input uart_rx,
    output reg [5:0] led,
    output pwm1
);
    wire cpu_enable;
    
    cpu Cpu(clk, btn1, cpu_enable);
    uart Uart(clk, uart_rx, led, cpu_enable);
    
    assign Cpu.Rom.memory = Uart.memory;

endmodule

`endif
