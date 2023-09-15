module peripheral_manager(
    input clk,
    input [31:0] addr,
    input [31:0] data_in,
    input mewWrite,

    output pwm1_out
);

    wire write_pwm1_1 = 0;
    wire write_pwm1_2 = 0;
    pwm_port pwm_port1(
        .clk(clk), 
        .mem_write(write_pwm1_1),
        .mem_write2(write_pwm1_2),
        .mem_data(data_in), 
        .mem_data2(data_in),
        .port_output(pwm1_out)
    );

    //abcxxx...xxx
    //ab = peripheral (000 = none, 001 = per1, ..., 111 = per9)
    //xxx...xxx = addr

    always(posedge *) begin
        if(mewWrite) begin

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
