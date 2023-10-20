`define TEST
`define ROM_FILE "../testbenches/instruction_tb_rom.txt"

module test();
    reg clk;
    reg rst;

    wire [5:0] led;
    wire [31:0] rom_data;
    
    cpu cpu(
        .clock(clk), 
        .reset(rst), 
        .enable(1'b1),
        .led(led));

    // Testbench procedure
    initial begin
        //#10
        //rst = 1'b1;
        //#10
        //rst = 1'b0;
        //#10

        clk = 0;
        #10;        
        clk = 1;
        #10;

        for (integer i = 0; i < 100; i = i + 1)
        begin
            $display("#STEP_START");
            $display("Step %0d", i);
            $display("");

            //$display("ROM");
            //$display("address: %0d", cpu.Rom.address);
            //$display("data: %h", cpu.Rom.data);
            //$display("memory[addr]: %h", cpu.Rom.memory[cpu.Rom.address]);
        
            $display("IF %0d", i);
            $display("instr: %h", cpu.Fetch.instr);
            $display("pc: %0d", cpu.Fetch.pc);

            $display("");

            $display("Decode %0d", i-1);
            $display("IN--------------");
            $display("_instruction: %h", cpu.Decode._instruction);
            $display("OUT-------------");
            $display("imm: %0d", cpu.Decode.imm);
            $display("rs1: %0d", cpu.Decode.rs1);
            $display("rs2: %0d", cpu.Decode.rs2);
            $display("shamt: %0d", cpu.Decode.shamt);
            $display("func3: %0d", cpu.Decode.func3);
            $display("func7: %0d", cpu.Decode.func7);
            $display("opcode: %0d", cpu.Decode.opcode);
            $display("MemWrite: %0d", cpu.Decode.MemWrite);
            $display("MemRead: %0d", cpu.Decode.MemRead);
            $display("RegWrite: %0d", cpu.Decode.RegWrite);
            $display("RegDest: %0d", cpu.Decode.RegDest);
            $display("AluSrc: %0d", cpu.Decode.AluSrc);
            $display("AluOp: %0d", cpu.Decode.AluOp);
            $display("AluControl: %0d", cpu.Decode.AluControl);
            $display("Branch: %0d", cpu.Decode.Branch);
            $display("MemToReg: %0d", cpu.Decode.MemToReg);
            $display("RegDataSrc: %0d", cpu.Decode.RegDataSrc);
            $display("PCSrc: %0d", cpu.Decode.PCSrc);
            $display("PC_out: %0d", cpu.Decode.PC_out);

            $display("");
            
            $display("EXECUTE %0d", i-2);
            $display("");
            $display("EXECUTE.IN----------------");
            $display("rs1_value: %0d", cpu.Execute.rs1_value);
            $display("rs2_value: %0d", cpu.Execute.rs2_value);
            $display("imm: %0d", cpu.Execute.imm);
            $display("PC: %0d", cpu.Execute.PC);
            $display("AluSrc: %0d", cpu.Execute.AluSrc);
            $display("AluOp: %0d", cpu.Execute.AluOp);
            $display("AluControl: %0d", cpu.Execute.AluControl);
            $display("in_MemWrite: %0d", cpu.Execute.in_MemWrite);
            $display("Branch: %0d", cpu.Execute.Branch);
            $display("in_MemRead: %0d", cpu.Execute.in_MemRead);
            $display("in_RegWrite: %0d", cpu.Execute.in_RegWrite);
            $display("in_RegDest: %0d", cpu.Execute.in_RegDest);
            $display("in_MemToReg: %0d", cpu.Execute.in_MemToReg);
            $display("in_RegDataSrc: %0d", cpu.Execute.in_RegDataSrc);
            $display("in_PCSrc: %0d", cpu.Execute.in_PCSrc);
            $display("");
            $display("EXECUTE.INTERNAL----------");
            $display("_rs1_value: %0d", cpu.Execute._rs1_value);
            $display("_imm: %0d", cpu.Execute._imm);
            $display("_PC: %0d", cpu.Execute._PC);
            $display("_AluOp: %0d", cpu.Execute._AluOp);
            $display("_AluSrc: %0d", cpu.Execute._AluSrc);
            $display("_AluControl: %0d", cpu.Execute._AluControl);
            $display("_RegDest: %0d", cpu.Execute._RegDest);
            $display("_MemWrite: %0d", cpu.Execute._MemWrite);
            $display("_MemRead: %0d", cpu.Execute._MemRead);
            $display("_RegWrite: %0d", cpu.Execute._RegWrite);
            $display("_MemToReg: %0d", cpu.Execute._MemToReg);
            $display("_RegDataSrc: %0d", cpu.Execute._RegDataSrc);
            $display("_PCSrc: %0d", cpu.Execute._PCSrc);
            //$display("zero: %0d", cpu.Execute.zero);
            $display("_rs2_value: %0d", cpu.Execute._rs2_value);
            $display("");
            $display("EXECUTE.ALU---------------");
            $display("alu.AluControl %b", cpu.Execute.alu.AluControl);
            $display("alu.a %0d", cpu.Execute.alu.a);
            $display("alu.b %0d", cpu.Execute.alu.b);
            $display("alu.result %0d", cpu.Execute.alu.result);
            $display("");
            $display("EXECUTE.OUT---------------");
            $display("out_MemWrite: %0d", cpu.Execute.out_MemWrite);
            $display("out_MemRead: %0d", cpu.Execute.out_MemRead);
            $display("out_RegWrite: %0d", cpu.Execute.out_RegWrite);
            $display("out_RegDest: %0d", cpu.Execute.out_RegDest);
            $display("out_MemToReg: %0d", cpu.Execute.out_MemToReg);
            $display("out_RegDataSrc: %0d", cpu.Execute.out_RegDataSrc);
            $display("out_PCSrc: %0d", cpu.Execute.out_PCSrc);
            $display("_rs2_value: %0d", cpu.Execute._rs2_value);
            $display("result: %0d", cpu.Execute.result);
            $display("a: %0d", cpu.Execute.a);
            $display("b: %0d", cpu.Execute.b);

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
            $display("RegisterBank.IN-----------");
            $display("write_enable: %0d", cpu.RegisterBank.write_enable);
            $display("write_address: %0d", cpu.RegisterBank.write_address);
            $display("write_value: %0d", cpu.RegisterBank.write_value);
            $display("read_address1: %0d", cpu.RegisterBank.read_address1);
            $display("read_address2: %0d", cpu.RegisterBank.read_address2);
            $display("RegisterBank.OUT----------");
            $display("value1: %0d", cpu.RegisterBank.value1);
            $display("value2: %0d", cpu.RegisterBank.value2);
            $display("RegisterBank.REGS---------");
            for (integer j = 10; j < 18; j = j + 1)
            begin
                $display("a%0d=x%0d %0d", j-10,j, cpu.RegisterBank.register[j]);
            end

            for (integer j = 18; j < 28; j = j + 1)
            begin
                $display("s%0d=x%0d %0d", j-16, j, cpu.RegisterBank.register[j]);
            end

            //$display("a0=x10 %0d", cpu.RegisterBank.register[10]);
            //$display("a4=x14 %0d", cpu.RegisterBank.register[14]);
            //$display("a6=x16 %0d", cpu.RegisterBank.register[16]);
            //$display("a7=x17 %0d", cpu.RegisterBank.register[17]);
            
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