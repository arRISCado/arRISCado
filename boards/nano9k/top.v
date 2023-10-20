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
    output [5:0] led,
    output pwm1
);
    wire cpu_enable;
    wire [31:0] instruction_data, instruction_address;
    
    localparam WAIT_TIME = 5000000;
    wire effClk;
    reg [23:0] clockCounter = 0;
    always @(posedge clk) begin
        clockCounter <= clockCounter + 1;
        if (clockCounter == WAIT_TIME) begin
            clockCounter <= 0;
            effClk <= ~effClk;
        end
    end

    cpu Cpu(
        .clock(effClk),
        .reset(~btn1),
        .led(led),
        .enable(cpu_enable),    
        .rom_address(instruction_address),
        .rom_data(instruction_data)
    );

    uart Uart(
        .clk(clk), 
        .uart_rx(uart_rx), 
        //.led(led), 
        .cpu_enable(cpu_enable),
        .address(instruction_address),
        .data(instruction_data)
    );

endmodule

`endif
