module fetch (
    input clk,                  // Application clock
    input pc_src,               // Signal to define if we jump branches or not
    input [31:0] branch_target, // Branch address to jump to if needed
    input [31:0] rom_data,
    output reg [31:0] pc,        // Register for the address of the next instruction (10-bit address for 1024 registers)
    output wire [31:0] instr      // Instruction fetched from memory
);

    reg [31:0] pc_next = 32'b0;

    // Initial value for the program counter
    initial begin
        pc = 32'b0; // Set initial PC value to the start of memory
        pc_next = 32'b0;
    end

    always @(posedge clk) begin
        if (pc_src) begin
            pc_next = branch_target; // Use non-blocking assignment here
        end else begin
            pc_next = pc + 32'b0001; // Increment PC by 4 to fetch the next sequential instruction (10-bit offset)
        end

        // Use the PC to fetch the instruction from instr_memory
        pc = pc_next;
    end

    assign instr = rom_data;

endmodule
