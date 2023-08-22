`include "ram.v"
`include "rom.v"
`include "cpu/register_bank.v"
`include "cpu/fetch.v"
`include "cpu/decode.v"
`include "cpu/execute.v"
`include "cpu/memory.v"
`include "cpu/writeback.v"

module cpu(
    input clk,
    input reset,
);
    ram ram(clk, reset);
    rom rom(clk);

    always @(reset)
    begin
        // TODO: Reset everything
    end

endmodule
