`define ROM_FILE "../../testbenches/cpu_tb.txt"
`include "../../testbenches/utils/imports.v"

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
        .PCSrc(pc_src),
        .in_BranchTarget(0),
        .pc(pc),
        .instr(instr),
        .rom_data(rom_data)
    );

    wire [31:0] imm;
    wire [6:0] opcode;
    wire [5:0] shamt;
    wire [2:0] func3;
    wire [6:0] func7;
    wire [2:0] aluOp;
    wire [4:0] aluControl;

    decode decode(
        .clk(clk),
        .next_instruction(instr),
        
        .imm(imm),
        .AluOp(aluOp),
        .AluControl(aluControl)
    );

    integer i;
    assign opcode = instr[6:0];
    assign shamt = instr[24:20];
    assign func3 = instr[14:12];
    assign func7 = instr[31:25];

    // Testbench procedure
    initial begin
        // Initialize inputs
        clk = 0;
        pc_src = 0;
        branch_target = 32'hAABBCCDD; // Example branch target

        #10;

        // Test case 1: Sequential fetch
        $display("Test Case 1: Sequential fetch");

        for (i = 0; i < 50; i = i + 1)
        begin
            $display("Instr: %h, imm: %h, Opcode: %b, shamt: %b, func3: %b, func7: %b, AluOp: %b, AluControl: %b",
            instr, imm, opcode, shamt, func3, func7, aluOp, aluControl);

            clk = 1;
            #10;
            clk = 0;
            #10;
        end

        $finish;
    end

endmodule
