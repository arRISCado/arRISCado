`define ROM_FILE "../../testbenches/cpu_tb_rom.txt"

`include "cpu.v"


// Comando aqui Elton
module test();
    reg clk;
    reg rst;
    
    cpu cpu(clk, rst);

    // Testbench procedure
    initial begin
        $display("STARTING");

        //Reset
        rst = 1;
        clk = 0;
        #10
        clk = 1;
        #10
        clk = 0;
        rst = 0;
        
        $display("HERE");
        $display("HERE %h", cpu.RegisterBank.register[1]);

        $finish;
    end

endmodule
