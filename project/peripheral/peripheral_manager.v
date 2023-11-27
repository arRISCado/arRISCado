

//Peripheral Manager
//
//Controls all peripherals of the processor
//It can read or write to them through addresses
//Not all addresses are read or write

//Address prefix map
//000 -> RAM (do nothing on this module)
//001 -> PWM port 1
//   001x...x0 -> Cycles on
//   001x...x1 -> Cycles off

module peripheral_manager(
    input clk, //Clock
    input physical_clk,  // Real FPGA clock
    input [31:0] addr, //Address
    input [31:0] data_in, //Data to write
    input write_enable, //Write if 1

    output [5:0] debug_led,
    output pwm1_out //Output of PWM port 1
);

    //abcxxx...xxx
    //abc = peripheral (000 = none, 001 = per1, ..., 111 = per7)
    //xxx...xxx = addr

    //Peripherals
    pwm_port pwm_port1(
        .clk(clk), 
        .physical_clk(physical_clk),
        .mem_write(write_pwm1_1),
        .mem_write2(write_pwm1_2),
        .mem_data(data_in), 
        .mem_data2(data_in),
        .port_output(pwm1_out),
        .debug_led(debug_led)
    );

    wire [1:0] buttons_out;

    buttons buttons(
        .clk(clk),
        .buttons_output(buttons_out)
    );

    assign write_pwm1_1 = (write_enable && addr[31:29] == 3'b001 && addr[0] == 0) ? 1 : 0;
    assign write_pwm1_2 = (write_enable && addr[31:29] == 3'b001 && addr[0] == 1) ? 1 : 0;


endmodule
