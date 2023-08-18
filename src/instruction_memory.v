module InstructionMemory(clk, current_pc, next_instr,
                mem_addr, mem_w_data, mem_r_data, mem_w_enable, mem_r_enable );
    input clk;
    input [63:0] current_pc;
    output [31:0] next_instr;

    output [31:0] mem_addr;
    output [31:0] mem_w_data;
    input  [31:0] mem_r_data;
    output mem_w_enable;
    output mem_r_enable;

endmodule