`include "ram.v"
`include "rom.v"
`include "cpu/register_bank.v"
`include "cpu/fetch.v"
`include "cpu/decode.v"
`include "cpu/execute.v"
`include "cpu/memory.v"
`include "cpu/writeback.v"

module cpu(
    input clock,
    input reset,
);
    // TODO: Reorganize
    wire [31:0] ram_address, ram_data_in, ram_data_out;
    wire ram_write_enable;

    ram ram(
        .clk(clock), 
        .reset(reset),
        .address(ram_address),
        .data_in(ram_data_in),
        .write_enable(ram_write_enable),
        .data_out(ram_data_out),
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
        .next_instruction(instr),
        
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

    wire [31:0] ex_result;

    execute execute(
        .clk(clock),
        .rst(reset),
        .rs1_value(rb_value1),
        .rs2_value(rb_value1),
        .imm(imm),
       
        .result(ex_result),

        // Control signals
        .AluSrc(t_AluSrc),
        .AluOp(t_AluOp),
        .in_MemWrite(t_MemWrite),
        .in_MemRead(t_MemRead),
        .in_RegWrite(t_RegWrite),
        .in_RegDest(t_RegDest),
        .in_AluControl(t_AluControl),
        .in_Branch(t_Branch),
        .in_MemToReg(t_MemToReg),
        .in_RegDataSrc(t_RegDataSrc),
        .in_PCSrc(t_PCSrc)
    );

    wire [31:0] mem_wr_data_out;
    wire mem_wr_mem_done;
    wire mem_we_rd;

    memory memory(
        .clk(clock),
        .rst(reset),

        .addr(),
        .data_in(ex_result),
        .load_store(),
        .op(),
        .mem_read_data(ram_data_out),
        .rd(mem_we_rd),

        .mem_addr(ram_address),
        .mem_write_data(ram_data_in),
        .mem_write_enable(ram_write_enable),
        .data_out(mem_wr_data_out),
        .mem_done(mem_wr_mem_done),
        .rd_out(),
    );

    writeback writeback(
        .clk(clock),
        .rst(reset),

        .mem_done(mem_wr_mem_done),
        .rd(mem_we_rd),
        .data_mem(mem_wr_data_out),
        .result_alu(),
        .mem_to_reg_ctrl(),

        .rd_out(rb_write_address),
        .rb_write_en(rb_write_enable),
        .data_wb(rb_write_value),
    );


endmodule
