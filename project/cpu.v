`include "ram.v"
`include "rom.v"
`include "cpu/register_bank.v"
`include "cpu/fetch.v"
`include "cpu/decode.v"
`include "cpu/execute.v"
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

    wire rb_write_enable;
    wire rb_write_address;
    wire rb_write_value;
    wire rb_read_address1;
    wire rb_read_address2;
    wire rb_value1;
    wire rb_value2;

    register_bank RegisterBank(
        .clk(clk),
        .reset(reset),
        .write_enable(rb_write_enable),
        .write_address(rb_write_address),
        .write_value(rb_write_value),
        .read_address1(rb_read_address1),
        .read_address2(rb_read_address2),
        .value1(rb_value1),
        .value2(rb_value2),
    );

    wire [20:0] imm;
    wire [6:0] opcode;
    wire [1:0] aluOp;

    decode decode(
        .instruction(instr),
        
        .imm(imm),
        //.rd(),
        .opcode(opcode),
        .AluOp(aluOp),
        .rs1(rb_read_address1),
        .rs2(rb_read_address2),
    );

    execute execute(
        .op(opcode),
        .op_type(aluOp),
        .rs1_value(rb_value1),
        .rs2_value(rb_value1),
        .imm(imm),
        // .result(),
    );


endmodule
