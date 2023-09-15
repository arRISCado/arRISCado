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

    reg clock;
    reg reset;

      cpu cpu(
        .clock(clock),
        .reset(reset)
    );

    reg [31:0] if_de_instr = 32'h00100513;
    reg [2:0] de_ex_aluOp = 3'b010;
    reg de_ex_aluSrc = 1;
    reg [4:0] rb_read_address1 = 0;
    reg [31:0] rb_value1 = 2'b10;
    reg [31:0] a = 2'b10;
    reg [31:0] imm = 1;
    reg [31:0] b = 1; 




    initial begin
    // Initialize inputs
    clock = 0;
    #10;

    // Test case 1: Sequential fetch
    $display("Test Case 1");

    for (integer i = 0; i < 15; i = i + 1)
    begin
        $display("Instr: %h, AluOp: %b, AluSrc: %b", if_de_instr, de_ex_aluOp, de_ex_aluSrc);
        $display("1: Addr: %h, Value: %h, a: %h", rb_read_address1, rb_value1, a);
        $display("2: Addr: %h, b: %h", imm, b);

        clock = 1;
        #10;
        clock = 0;
        #10;
    end

    $finish;
    end

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
