`include "mux.v";
`include "register.v";

module Stage_mem(clk, step_clk, alu_zero, alu_result, read_data_2, m, read_data, pc_src);
    input clk, step_clk;
    input alu_zero;
    input [31:0] alu_result, read_data_2;
    input [2:0] m;

    output [31:0] read_data;
    output reg pc_src;

    DataMemory data_memory(alu_result, read_data_2, read_data, m[0], m[1]);

    always @(m[2], alu_zero) begin
        pc_src <= m[2] && alu_zero;
    end

endmodule