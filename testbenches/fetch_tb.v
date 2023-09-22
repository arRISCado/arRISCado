`include "../../testbenches/utils/imports.v"

module test;

    // Inputs
    reg clk;
    reg pc_src;
    reg [31:0] branch_target;

    // Outputs
    wire [31:0] pc, instr, rom_data, rom_address;

    // Instantiate the fetch module
    fetch fetch_inst(
        .clk(clk),
        .pc_src(pc_src),
        .branch_target(branch_target),
        .pc(pc),
        .instr(instr),
        .rom_data(rom_data)
    );

    rom rom(
        .address(pc),
        .data(rom_data)
    );

    // Testbench procedure
    initial begin
        // Initialize inputs
        pc_src = 0;
        branch_target = 32'h5; // Example branch target

        #10;

        // Test case 1: Sequential fetch
        $display("Test Case 1: Sequential fetch");
        $display("PC: %h, Instruction: %h", pc, instr);

        clk = 0;
        #10;
        clk = 1;
        #10;
        clk = 0;
        #10;

        $display("PC: %h, Instruction: %h", pc, instr);

        clk = 1;
        #10;
        clk = 0;
        #10;

        $display("PC: %h, Instruction: %h", pc, instr);

        // Test case 2: Branch fetch
        $display("Test Case 2: Branch fetch");
        pc_src = 1;

        #10;
        clk = 1;
        #10;
        clk = 0;
        #10;

        $display("PC: %h, Instruction: %h", pc, instr);

        $finish;
    end

endmodule
