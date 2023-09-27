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
    input btn2,
    input uart_rx,
    output [5:0] led
);
    wire cpu_enable;
    
    cpu Cpu(
        .clock(~btn2), 
        .reset(~btn1),
        .led(led),
        .enable('b1)
    );

    // uart Uart(
    //     .clk(clk), 
    //     .uart_rx(uart_rx), 
    //     // .led(led), 
    //     .cpu_enable(cpu_enable)
    // );
    
    // assign Cpu.Rom.memory = Uart.memory;

endmodule

`endif
