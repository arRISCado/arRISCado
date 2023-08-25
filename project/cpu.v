`include "ram.v"
`include "rom.v"
// `include "cpu/register_bank.v"
`include "cpu/fetch.v"
// `include "cpu/decode.v"
// `include "cpu/execute.v"
// `include "cpu/memory.v"
// `include "cpu/writeback.v"

module cpu(
    input clk,
    input reset,
);
    ram ram(clk, reset);
    rom rom(
        .address(rom_address),
        .data(rom_data),
    );

    wire pc_src;
    wire [31:0] branch_target;
    wire [31:0] rom_data;
    wire [31:0] rom_address;
    wire [31:0] pc;
    wire [31:0] instr;

    fetch fetch(
        .clk(clock),
        .pc_src(pc_src),
        .branch_target(branch_target),
        .rom_data(rom_data),
        .pc(pc),
        .instr(instr),
    );

endmodule
