// Writeback Stage
`include "utils/mux.v"
`include "utils/register.v"

module writeback(clk, step_clk, read_data, alu_result, wb, write_data);
    input clk, step_clk;
    input [31:0] read_data;
    input [31:0] alu_result;
    input [1:0] wb;

    output [31:0] write_data;


    Mux mux(wb[0], alu_result, read_data, write_data);
    defparam mux.n = 32;

endmodule