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

    wire [20:0] t_imm;
    wire [6:0] t_opcode;
    wire [1:0] t_aluOp;
    wire [31:0] t_rb_value1;
    wire [31:0] t_rb_value2;

    always @(posedge clk) begin
        t_opcode = opcode;
        t_aluOp = aluOp;
        t_imm = imm;
        t_rb_value1 = rb_value1;
        t_rb_value2 = rb_value2;
    end

    wire rb_write_enable;
    wire [7:0] rb_write_address;
    wire [31:0] rb_write_value;
    wire [7:0] rb_read_address1;
    wire [7:0] rb_read_address2;
    wire [31:0] rb_value1;
    wire [31:0] rb_value2;

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

    execute execute(
        .op(t_opcode),
        .op_type(t_aluOp),
        .rs1_value(t_rb_value1),
        .rs2_value(t_rb_value1),
        .imm(t_imm),
        // .result(),
    );


endmodule
