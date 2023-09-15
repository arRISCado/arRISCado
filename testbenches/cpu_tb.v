`define ROM_FILE "../../testbenches/cpu_tb_rom.txt"
`include "../../project/cpu.v"

module test;
    reg clk;
    reg rst;
    
    cpu cpu(clk, rst);

    // Testbench procedure
    initial begin
        //Reset
        rst = 1;
        clk = 0;
        #10
        clk = 1;
        #10
        clk = 0;
        rst = 0;

        $display("%h", cpu.RegisterBank.register[0]);

    end

endmodule
