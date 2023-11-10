

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
    input [31:0] addr, //Address
    input [31:0] data_in, //Data to write
    input write_enable, //Write if 1

    output pwm1_out //Output of PWM port 1
);

    //abcxxx...xxx
    //abc = peripheral (000 = none, 001 = per1, ..., 111 = per7)
    //xxx...xxx = addr

    //Peripherals
    reg write_pwm1_1 = 0;
    reg write_pwm1_2 = 0;
    pwm_port pwm_port1(
        .clk(clk), 
        .mem_write(write_pwm1_1),
        .mem_write2(write_pwm1_2),
        .mem_data(data_in), 
        .mem_data2(data_in),
        .port_output(pwm1_out)
    );

    //Write/read peripheral
    always @(*) begin
        if(write_enable) begin

            if(addr[31:29] == 3'b001) begin //pwm_port1
                if(addr[0] == 0) begin
                    write_pwm1_1 = 1;
                end
                else begin
                    write_pwm1_2 = 1;
                end

                write_pwm1_1 = 0;
                write_pwm1_2 = 0;
            end


        end
    
    end

endmodule
