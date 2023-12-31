module fetch (
    input clk,                    // Clock signal
    input rst,                    // Reset signal
    input stall,

    input [31:0] in_BranchTarget, // Branch address to jump to if needed
    input [31:0] rom_data,

    input PCSrc,

    output [7:0] rom_address,

    output reg [31:0] pc = 32'b0, // Register for the address of the next instruction (10-bit address for 1024 registers)
    output wire [31:0] instr      // Instruction fetched from memory
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 0;
        else if (~stall) begin
            $display("%h %h", pc, instr);
            if (PCSrc)
                pc <= in_BranchTarget;
            else if (instr[1:0] == 2'b11)
                pc <= pc + 4; // Increment PC by 4 to fetch the next sequential instruction (10-bit offset)
            else
                pc <= pc + 2;
        end
    end

    assign instr = rom_data;
    assign rom_address = pc;

endmodule
