`define ROM_FILE "../testbenches/pwm_tb_rom.txt"

module test();

    wire pwm_out;
    reg clk;
    reg rst;

    integer on = 0;
    integer off = 0;


    cpu Cpu(
        .clock(clk), 
        .reset(rst),
        .enable(1'b1),
        .port_pwm1(pwm_out)
    );
    
    initial begin
        #10

        for (integer i = 0; i < 20; i = i + 1)
        begin
            $display("a0=x10 %0d", Cpu.RegisterBank.register[10]);
            $display("a1=x11 %0d", Cpu.RegisterBank.register[11]);
            $display("a2=x12 %0d", Cpu.RegisterBank.register[12]);
            $display("a3=x13 %0d", Cpu.RegisterBank.register[13]);
            $display("%b %0d", Cpu.Ram.address, Cpu.Ram.data_in);
            $display("%b %0d", Cpu.Peripheral_manager.addr, Cpu.Peripheral_manager.data_in);
            $display("%0d %0d", Cpu.Peripheral_manager.pwm_port1.mem_data, Cpu.Peripheral_manager.pwm_port1.mem_data2);
            clk = 0;
            #10;        
            clk = 1;
            #10;
        end

        $display("%0d %0d", Cpu.Peripheral_manager.pwm_port1.clk_per_cycle, Cpu.Peripheral_manager.pwm_port1.clk_on);

        for (integer i = 0; i < 15; i = i + 1)
        begin
            if(pwm_out == 1'b0) begin
                off += 1;
            end
            else begin
                on += 1;
            end

            clk = 0;
            #10;        
            clk = 1;
            #10;
        end

        $display("Off: %0d | On: %0d", off, on);

        $finish;
    end

endmodule