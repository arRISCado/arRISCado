`include "../../project/rom.v"
`include "../../project/cpu/fetch.v"
`include "../../project/cpu/decode.v"

module test;

    // Inputs
    reg clk;
    rom rom(
        .address(pc),
        .data(rom_data)
    );

    reg pc_src;
    reg [31:0] branch_target;
    wire [31:0] rom_data, pc, instr;

    fetch fetch(
        .clk(clk),
        .pc_src(pc_src),
        .branch_target(0),
        .pc(pc),
        .instr(instr),
        .rom_data(rom_data)
    );

    wire [20:0] imm;
    wire [6:0] opcode;
    wire [2:0] aluOp;

    decode decode(
        .clk(clk),
        .next_instruction(instr),
        
        .imm(imm),
        .opcode(opcode),
        .AluOp(aluOp)
    );

    // Testbench procedure
    initial begin
        // Initialize inputs
        clk = 0;
        pc_src = 0;
        branch_target = 32'hAABBCCDD; // Example branch target

        #10;

        // Test case 1: Sequential fetch
        $display("Test Case 1: Sequential fetch");
        $display("Instr: %h, Opcode: %b, AluOp: %b", instr, opcode, aluOp);

        clk = 1;
        #10;
        clk = 0;
        #10;

        $display("Instr: %h, Opcode: %b, AluOp: %b", instr, opcode, aluOp);

        clk = 1;
        #10;
        clk = 0;
        #10;

        $display("Instr: %h, Opcode: %b, AluOp: %b", instr, opcode, aluOp);

        clk = 1;
        #10;
        clk = 0;
        #10;

        $display("Instr: %h, Opcode: %b, AluOp: %b", instr, opcode, aluOp);

        $finish;
    end

endmodule
