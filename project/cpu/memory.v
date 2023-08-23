`include "utils/mux.v"
`include "utils/register.v"
`include "utils/data_memory.v"

// Memory Stage
module Stage_mem(clk, step_clk, alu_zero, alu_result, read_data_2, m, read_data, pc_src,
        mem_addr, mem_w_data, mem_r_data, mem_w_enable, mem_r_enable);
    
    input clk, step_clk;
    input alu_zero;
    input [31:0] alu_result, read_data_2;
    input [2:0] m;

    output [31:0] read_data;
    output reg pc_src;

    output [31:0] mem_addr;
    output [31:0] mem_w_data;
    input  [31:0] mem_r_data;
    output mem_w_enable;
    output mem_r_enable;

    DataMemory data_memory(alu_result, read_data_2, read_data, m[0], m[1],
        mem_addr, mem_w_data, mem_r_data, mem_w_enable, mem_r_enable);

    always @(m[2], alu_zero) begin
        pc_src <= m[2] && alu_zero;
    end

endmodule
