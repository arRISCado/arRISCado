`include "ram.v"
`include "rom.v"
`include "cpu/register_bank.v"
`include "cpu/fetch.v"
`include "cpu/decode.v"
`include "cpu/execute.v"
// `include "cpu/memory.v"
// `include "cpu/writeback.v"

module cpu(
    input clock,
    input reset,
);
    ram ram(
        .clk(clock), 
        .reset(reset)
    );
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
        .rst(reset),
        .pc_src(pc_src),
        .branch_target(branch_target),
        .rom_data(rom_data),

        .pc(pc),
        .instr(instr),
    );

    wire [20:0] imm;
    wire [2:0] aluOp;
    wire aluSrc;
    wire pc_src;

    decode decode(
        .clk(clock),
        .rst(reset),
        .instruction(instr),
        
        .imm(imm),
        .rd(rd),
        .rs1(rb_read_address1),
        .rs2(rb_read_address2),
        
        .AluOp(aluOp),
        .AluSrc(aluSrc),
        .PCSrc(pc_src),
    );

    wire rb_write_enable;
    wire [7:0] rb_write_address;
    wire [31:0] rb_write_value;
    wire [5:0] rb_read_address1;
    wire [5:0] rb_read_address2;
    wire [31:0] rb_value1;
    wire [31:0] rb_value2;

    register_bank RegisterBank(
        .clk(clock),
        .reset(reset),
        .write_enable(rb_write_enable),
        .write_address(rb_write_address),
        .write_value(rb_write_value),
        .read_address1(rb_read_address1),
        .read_address2(rb_read_address2),
        .value1(rb_value1),
        .value2(rb_value2),
    );

    wire [31:0] result;

    execute execute(
        .clk(clock),
        .rst(reset),

        .rs1_value(rb_value1),
        .rs2_value(rb_value1),
        .imm(imm),
        .pc_src(pc_src),

        .AluOp(aluOp),
        .AluSrc(aluSrc),
        .rd(rd),
        
        .result(result),
    );

endmodule
