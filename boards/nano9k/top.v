`ifndef TESTBENCH

`define UART_FILE "../../project/init_uart.txt"
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
    wire [31:0] instruction_data, instruction_address;
    
    cpu Cpu(
        .clock(~btn2), 
        //.clock(clk),
        .reset(~btn1),
        //.led(led),
        .enable(cpu_enable),
        //.rom_address(instruction_address),
        //.rom_data(instruction_data)
    );

    uart Uart(
        .clk(clk), 
        .uart_rx(uart_rx), 
        .led(led), 
        .cpu_enable(cpu_enable),
        //.address(instruction_address),
        //.data(instruction_data)
    );

endmodule

`endif
