module fetch (
    input clk,                  // Application clock
    input pc_src,               // Signal to define if we jump branches or not
    input [31:0] branch_target, // Branch address to jump to if needed
    output reg [31:0] pc,        // Register for the address of the next instruction (10-bit address for 1024 registers)
    output reg [31:0] instr     // Instruction fetched from memory
);

    reg [9:0] pc_next;

    // Initial value for the program counter
    initial begin
        pc = 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Set initial PC value to the start of memory
    end

    always @(posedge clk) begin
        if (pc_src) begin
            pc_next <= branch_target; // Use non-blocking assignment here
        end else begin
            pc_next <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100; // Increment PC by 4 to fetch the next sequential instruction (10-bit offset)
        end
    end

    // Instruction memory as a 1024-register array of 32 bits each
    reg [31:0] instr_memory [0:1023];
    initial begin
        // Initialize instr_memory with example instructions
        instr_memory[0]  = 32'b0000000_00000_00001_000_00000_0110011; // ADDI x1, x0, 0
        instr_memory[1]  = 32'b0000000_00000_00010_010_00000_0110011; // SUB x2, x0, 0
        instr_memory[2]  = 32'b0000101_00010_00001_000_00000_0100011; // STORE x1, x2, 0
        instr_memory[3]  = 32'b0000000_00000_00011_001_00000_0000011; // LOAD x3, x0, 0
        instr_memory[4]  = 32'b0000000_00001_00010_000_00000_0110011; // ADD x2, x1, x0
        instr_memory[5]  = 32'b0000000_00010_00001_100_00000_0110011; // XOR x1, x2, x0
        instr_memory[6]  = 32'b0000000_00000_00010_010_00000_0010011; // ANDI x2, x0, 0
        instr_memory[7]  = 32'b0000101_00010_00011_000_00000_0100011; // STORE x3, x2, 0
        instr_memory[8]  = 32'b0000000_00000_00001_001_00000_0000011; // LOAD x1, x0, 0
        instr_memory[9]  = 32'b0000000_00001_00010_000_00000_0110011; // ADD x2, x1, x0
    end

    // Use the PC to fetch the instruction from instr_memory
    always @(posedge clk) begin
        pc <= pc_next;
        instr <= instr_memory[pc[9:0]];
    end
endmodule
