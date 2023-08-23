`include "register.v"

module Bar_if_id(step_clk, pc_in, pc_out, instr_in, instr_out);
    input step_clk;
    input [63:0] pc_in;
    output[63:0] pc_out;
    input [31:0] instr_in;
    output [31:0] instr_out;
    
    Register pc(step_clk, pc_in, 1, pc_out);
    defparam pc.n = 64;

    Register instr(step_clk, instr_in, 1, instr_out);
    defparam instr.n = 32;

    

endmodule