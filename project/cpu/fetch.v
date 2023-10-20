`ifndef FETCH
`define FETCH

module fetch (
    input clk,                    // Clock signal
    input rst,                    // Reset signal
    input signed [31:0] BranchOffset,    // Branch address to jump to if needed
    input [31:0] rom_data,

    input PCSrc,

    output [31:0] rom_address,

    output reg [31:0] pc = 32'b0, // Register for the address of the next instruction (10-bit address for 1024 registers)
    output wire [31:0] instr      // Instruction fetched from memory
);

    reg [31:0] pc_next = 32'b0;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
            pc_next <= 0;
        else
            pc_next <= PCSrc ? (pc + BranchOffset) : (pc+4); // Use non-blocking assignment here

        // Use the PC to fetch the instruction from instr_memory
    end

    assign pc = pc_next;
    assign instr = rom_data;
    assign rom_address = pc;

endmodule

`endif