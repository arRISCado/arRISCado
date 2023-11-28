

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
    input btn1,
    input btn2,

    output [31:0] data_out,
    output [5:0] debug_led,
    output pwm1_out //Output of PWM port 1
);

    //abcxxx...xxx
    //abc = peripheral (000 = none, 001 = per1, ..., 111 = per7)
    //xxx...xxx = addr

    //Peripherals
    ///001
    //0 (in): clk_on
    //1 (in): cycles in duty cycle
    pwm_port pwm_port1(
        .clk(clk), 
        .physical_clk(physical_clk),
        .mem_write(write_pwm1_1),
        .mem_write2(write_pwm1_2),
        .mem_data(data_in), 
        .mem_data2(data_in),
        .port_output(pwm1_out)
        //.debug_led(debug_led)
    );

    wire [31:0] buttons_output;
    wire read_btn1;
    wire read_btn2;

    //010
    //0 (out): btn1 counter
    //1 (out): btn2 counter
    buttons buttons1(
        .clk(clk),
        .btn1(btn1),
        .btn2(btn2),
        .read_btn1(read_btn1),
        .read_btn2(read_btn2),
        .buttons_output(buttons_output),
        .debug_led(debug_led)
    );

    assign write_pwm1_1 = (write_enable && addr[31:29] == 3'b001 && addr[0] == 0) ? 1 : 0;
    assign write_pwm1_2 = (write_enable && addr[31:29] == 3'b001 && addr[0] == 1) ? 1 : 0;

    assign read_btn1 = (addr[31:29] == 3'b010 && addr[0] == 1) ? 1 : 0;
    assign read_btn2 = (addr[31:29] == 3'b010 && addr[0] == 0) ? 1 : 0;

    assign data_out = (read_btn1) ? buttons_output : 
                        read_btn2 ? buttons_output :
                        32'd0;
endmodule
