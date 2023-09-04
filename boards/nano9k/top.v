// Top Level Target for Nano 9k
`include "../../project/cpu.v"
`include "../../project/uart.v"

module nano9k (
    input clk,
    input btn1,
    input uart_rx,
    output reg [5:0] led
);
    cpu cpu(clk, btn1);
    uart uart(clk, uart_rx, led);
    
endmodule
