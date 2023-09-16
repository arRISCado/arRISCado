`define ROM_FILE "../testbenches/instruction_tb_rom.txt"

`include "cpu.v"

module test();
    reg clk;
    reg rst;
    
    cpu cpu(clk, rst);

    // Testbench procedure
    initial begin
        #10

        for (integer i = 0; i < 100; i = i + 1)
        begin
            $display("%d", i);
        
            //$display("IF");
            //$display("instr: %h", cpu.Fetch.instr);

            $display("Decode");
            $display("IN");
            $display("_instruction: | %h", cpu.Decode._instruction);    
            $display("OUT");
            $display("RegDest: %d", cpu.Decode.RegDest);
            $display("rs1: %d", cpu.Decode.rs1);
            $display("imm: %d", cpu.Decode.imm);
            $display("RegWrite: %b", cpu.Decode.RegWrite);
            $display("AluSrc: %b", cpu.Decode.AluSrc);
            $display("AluOp: %b", cpu.Decode.AluOp);
            $display("AluControl: %b", cpu.Decode.AluControl);

            $display("a0 %d", cpu.RegisterBank.register[10]);

            clk = 0;
            #10;        
            clk = 1;
            #10;
        end

        for (integer i = 1; i < 32; i = i + 1)
        begin
            $display("%d %d", i, cpu.RegisterBank.register[i]);
        end

        $finish;
    end

endmodule