`include "mux.v";
`include "register.v";

module Stage_if(clk, step_clk, branch_target, pc_src, pc, instr);
    input clk, step_clk, pc_src;
    input [63:0] branch_target;

    output reg [63:0] pc;
    output reg [31:0] instr;

    wire [63:0] next_pc_usual;
    wire [63:0] next_pc;
    wire [63:0] current_pc;

    wire [63:0] static_4;    

    Mux mux(pc_src, next_pc_usual, branch_target, next_pc);
    defparam mux.n = 64;

    Register pc_reg(clk, next_pc, 1, current_pc);
    defparam pc_reg.n = 64;

    Adder add(clk, current_pc, static_4, next_pc_usual);
    defparam add.n = 64;

    InstructionMemory instrMem(clk, current_pc, next_instr);

    initial begin
        static_4 = 64'b0000_0000_0000_0000_0000_0000_0000_0100;
    end

    always @(current_pc) begin
        pc = current_pc;
    end
    
    always @(next_instr) begin
        instr = next_instr;
    end

endmodule