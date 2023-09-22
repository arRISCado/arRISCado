`define ROM_FILE "../testbenches/instruction_tb_rom.txt"

module test();
    reg clk;
    reg rst;
    
    cpu cpu(clk, rst);

    // Testbench procedure
    initial begin
        #10

        for (integer i = 0; i < 100; i = i + 1)
        begin
            $display("#STEP_START");
            $display("Step %0d", i);
        
            $display("IF %0d", i);
            $display("instr: %h", cpu.Fetch.instr);

            $display("");

            $display("Decode %0d", i-1);
            $display("IN");
            $display("_instruction: | %h", cpu.Decode._instruction);    
            $display("OUT");
            $display("RegWrite: %b", cpu.Decode.RegWrite);
            $display("RegDest: %0d", cpu.Decode.RegDest);
            //$display("rs1: %0d", cpu.Decode.rs1);
            //$display("imm: %0d", cpu.Decode.imm);
            //$display("AluSrc: %b", cpu.Decode.AluSrc);
            //$display("AluOp: %b", cpu.Decode.AluOp);
            //$display("AluControl: %b", cpu.Decode.AluControl);

            $display("");
            
            $display("Execute %0d", i-2);
            $display("in_RegWrite %b", cpu.Execute.in_RegWrite);
            $display("in_RegDest %0d", cpu.Execute.in_RegDest);
            $display("out_RegWrite %b", cpu.Execute.out_RegWrite);
            $display("out_RegDest %0d", cpu.Execute.out_RegDest);
            
            $display("");
            
            $display("Memory %0d", i-3);
            $display("in_RegWrite %b", cpu.Memory.in_RegWrite);
            $display("in_RegDest %0d", cpu.Memory.in_RegDest);
            $display("out_RegWrite %b", cpu.Memory.out_RegWrite);
            $display("out_RegDest %0d", cpu.Memory.out_RegDest);

            $display("");

            $display("WB %0d", i-4);
            $display("in_RegWrite %b", cpu.Writeback.in_RegWrite);
            $display("in_RegDest %0d", cpu.Writeback.in_RegDest);
            $display("out_RegWrite %b", cpu.Writeback.out_RegWrite);
            $display("out_RegDest %0d", cpu.Writeback.out_RegDest);

            $display("");

            $display("Register bank");
            $display("Write enable %0d", cpu.RegisterBank.write_enable);
            $display("Write address %0d", cpu.RegisterBank.write_address);
            $display("Write value %0d", cpu.RegisterBank.write_value);
            $display("a0=x10 %0d", cpu.RegisterBank.register[10]);
            
            $display("");
            $display("#STEP_END");
            $display("\n\n");

            clk = 0;
            #10;        
            clk = 1;
            #10;
        end

        $display("#RESULT");
        for (integer i = 1; i < 32; i = i + 1)
        begin
            $display("%0d %0d", i, cpu.RegisterBank.register[i]);
        end

        $finish;
    end

endmodule