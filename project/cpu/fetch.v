`include "utils/mux.v"
`include "utils/register.v"
`include "utils/instruction_memory.v"

// Fetch Stage
module fetch (
    clk, // aplication clock
    branch_target, // brach address to jump to if needed
    pc_src, // signal to define if we jump branches or not
    pc, // register if the adress if the next instruction
    instr, // instruction recovered from the memory
);

    input clk, pc_src;
    input [31:0] branch_target;

    output reg [31:0] pc;
    output reg [31:0] instr;

    wire [31:0] normal_pc;
    wire [31:0] current_pc;
    wire [31:0] next_pc;
    wire [31:0] next_instr;

    wire [31:0] static_4 = 32'b0000_0000_0000_0000_0000_0000_0000_0100

    // multiplexer to define if we use normal_pc or the target_brnch jump address
    // if pc_src signal high we jump
    Mux mux(pc_src, normal_pc, branch_target, current_pc);
    defparam mux.n = 32;

    // recover the instruction in current_pc address from memory
    InstructionMemory instrMem(clk, current_pc, next_instr);

    // add 4 to the current_pc and sends to the output next_pc
    // adds current_pc and static_4 and saves in next_pc_usual
    Adder add(current_pc, static_4, 0, next_pc_usual);
    defparam add.n = 64;


    always @(next_pc_usual) begin
        pc = next_pc_usual
    end

    always @(next_instr) begin
        instr = next_instr
    end
    
endmodule
