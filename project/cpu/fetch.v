`ifndef FETCH
`define FETCH

module fetch (
    input clk,                    // Clock signal
    input rst,                    // Reset signal
    input [31:0] branch_target,   // Branch address to jump to if needed
    input [31:0] rom_data,

    input PCSrc,

    output [31:0] rom_address,

    output reg [31:0] pc = 32'b0, // Register for the address of the next instruction (10-bit address for 1024 registers)
    output wire [31:0] instr      // Instruction fetched from memory
);

    reg [31:0] pc_next = 32'b0;

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc_next = 0;
        else if (PCSrc)
            pc_next = pc_next + branch_target - 7; // Use non-blocking assignment here
        else
            pc_next = pc + 1; // Increment PC by 4 to fetch the next sequential instruction (10-bit offset)

        // Use the PC to fetch the instruction from instr_memory
        pc = pc_next;
    end

    assign instr = rom_data;
    assign rom_address = pc;

endmodule

`endif