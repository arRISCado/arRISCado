`ifndef UART_FILE
`define UART_FILE "init_uart.txt"
`endif
`ifndef ROM_FILE
`define ROM_FILE  "init_rom.txt"
`endif

// Top Level Target for Nano 9k
module nano9k (
    input clk,
    input btn1,
    input btn2,
    input uart_rx,
    output [5:0] led,
    output pwm1
);
    wire cpu_enable;
    wire [31:0] instruction_data;
    wire [7:0] instruction_address;
    
    localparam WAIT_TIME = 5000000;
    reg effClk;
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
        .physical_clk(clk),
        .reset(1'd0),
        .led(led),
        .enable(1'd1),//cpu_enable),   
        .btn1(~btn1),
        .btn2(~btn2), 
        .rom_address(instruction_address),
        .rom_data(instruction_data),
        .port_pwm1(pwm1)
    );

    /*rom rom(
        .address(instruction_address),
        .data(instruction_data)
    );*/

    uart Uart(
         .clk(clk), 
         .uart_rx(uart_rx), 
         //.led(led), 
         .cpu_enable(cpu_enable),
         .address(instruction_address),
         .data(instruction_data)
    );

endmodule
