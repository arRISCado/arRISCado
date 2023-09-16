`define ROM_FILE "../testbenches/cpu_tb_rom.txt"

`include "cpu.v"

module test();
    reg clk;
    reg rst;
    
    cpu cpu(clk, rst);

    // Testbench procedure
    initial begin
        //$display("STARTING");
        //$display("addi x1, x0, 1");
        
        #10

        //$display("IF");
        //$display("00100093 | %h", cpu.Fetch.instr);

        clk = 0;
        #10
        clk = 1;
        #10

        //$display("Decode");
        //$display("IN");
        //$display("00100093 | %h", cpu.Decode._instruction);
        
        //$display("OUT");
        //$display("0001 | %b", cpu.Decode.RegDest);
        //$display("0000 | %b", cpu.Decode.rs1);
        //$display("00000001 | %h", cpu.Decode.imm);
        //$display("1 | %b", cpu.Decode.RegWrite);
        //$display("1 | %b", cpu.Decode.AluSrc);
        //$display("010 | %b", cpu.Decode.AluOp);
        //$display("0010 | %b", cpu.Decode.AluControl);

        clk = 0;
        #10        
        clk = 1;
        #10
        //$display("Execute");

        //$display("IN");
        //$display("00000001 | %h", cpu.Execute._rd);
        //$display("00000000 | %h", cpu.Execute._rs1_value);
        //$display("00000001 | %h", cpu.Execute._imm);
        //$display("1 | %b", cpu.Execute._AluSrc);

        //$display("OUT");
        //$display("0001 | %b", cpu.Execute.out_RegDest);
        //$display("00000001 | %h", cpu.Execute.result);

        clk = 0;
        #10        
        clk = 1;
        #10
        //$display("Memory");

        clk = 0;
        #10        
        clk = 1;
        #10
        //$display("WB");
    

        $display("00000000000000000000000000000001 | %b", cpu.RegisterBank.register[1]);

        for (integer i = 0; i < 15; i = i + 1)
        begin
            clk = 0;
            #10;        
            clk = 1;
            #10;
        end

        $display("00000000000000000000000000000001 | %b", cpu.RegisterBank.register[1]);

        $finish;
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
