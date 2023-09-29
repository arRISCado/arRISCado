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
/*
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

*/
`include "../../project/cpu/register_bank.v"
    register_bank RegisterBank(
        .clk(effClk),
        .reset(~btn1),
        .write_enable(rb_write_enable),
        .write_address(rb_write_address),
        .write_value(rb_write_value),
        .read_address1(rb_read_address1),
        .read_address2(rb_read_address2),
        .led(led[5:3]),
        .value1(rb_value1),
        .value2(rb_value2)
    );

  wire rb_write_enable = 0;
  wire [4:0] rb_write_address;
  wire [31:0] rb_write_value;
  wire [4:0] rb_read_address1;
  wire [4:0] rb_read_address2;

reg writeEnables[0:32];
reg [4:0] writeAdresses[0:32];
reg [31:0] writeValues[0:32];
reg [7:0] counter = 0;


always @(posedge effClk) begin
    rb_write_address = writeAdresses[counter];
    rb_write_value = writeValues[counter];
    rb_write_enable = writeEnables[counter];
    led[0] <= ~rb_write_enable;
    counter = counter + 1;
end

integer i;
initial begin
    for(i = 0; i < 32; i++) begin
        writeAdresses[i] = 0;
        writeValues[i] = 0;
        writeEnables[i] = 1;
    end
    writeAdresses[5] = 2;
    writeValues[5] = 5;
    writeEnables[5] = 1;
    writeEnables[6] = 1;
    led[2:0] <= ~0;
end


endmodule

`endif
