`ifndef TESTBENCH
`define TESTBENCH 1
`endif

`include "../../project/ram.v"
`include "../../project/rom.v"
`include "../../project/cpu/register_bank.v"
`include "../../project/cpu/alu.v"
`include "../../project/cpu/fetch.v"
`include "../../project/cpu/decode.v"
`include "../../project/cpu/execute.v"
`include "../../project/cpu/memory.v"
`include "../../project/cpu/writeback.v"
`include "../../project/cpu.v"

module test;
  
  cpu cpu();

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
