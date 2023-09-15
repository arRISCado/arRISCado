`define ROM_FILE "../testbenches/cpu_tb_rom.txt"

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

        // IF

        $display("00000000000000000000000000000000 | %b", cpu.RegisterBank.register[1][31:0]);

        $display("00100093 | %h", cpu.Fetch.instr);

        #10
        clk = 1;
        #10
        clk = 0;

        //Decode

        

        #10
        clk = 1;
        #10
        clk = 0;


        #10
        clk = 1;
        #10
        clk = 0;


        #10
        clk = 1;
        #10
        clk = 0;

        #10
        clk = 1;
        #10
        clk = 0;

        #10
        clk = 1;
        #10
        clk = 0;

        $display("00000000000000000000000000000001 | %b", cpu.RegisterBank.register[1][31:0]);


        $finish;
    end

endmodule
