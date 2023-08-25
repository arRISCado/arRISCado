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
    wire [31:0] rom_data;
    wire [31:0] pc;
    wire [31:0] instr;

    fetch fetch(
        .clk(clk),
        .pc_src(pc_src),
        .branch_target(0),
        .rom_data(rom_data),
        .pc(pc),
        .instr(instr)
    );

    wire [20:0] imm;
    wire [6:0] opcode;
    wire [1:0] aluOp;

    decode decode(
        .instruction(instr),
        
        .imm(imm),
        //.rd(),
        .opcode(opcode),
        .AluOp(aluOp)
        // .rs1(rb_read_address1),
        // .rs2(rb_read_address2)
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
        $display("Instr: %h, Opcode: %b", instr, opcode);

        clk = 1;
        #10;
        clk = 0;
        #10;

        $display("Instr: %h, Opcode: %b", instr, opcode);

        clk = 1;
        #10;
        clk = 0;
        #10;

        $display("Instr: %h, Opcode: %b", instr, opcode);

        clk = 1;
        #10;
        clk = 0;
        #10;

        $display("Instr: %h, Opcode: %b", instr, opcode);

        $finish;
    end

endmodule
