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
    // ### Component wires ###

    // ROM
    wire [31:0] rom_data, rom_address;

    // RAM
    wire [31:0] ram_address, ram_data_in, ram_data_out;
    wire ram_write_enable;
    
    // Register Bank

    wire rb_write_enable;
    wire [4:0] rb_write_address, rb_read_address1, rb_read_address2;
    wire [31:0] rb_value1, rb_value2, rb_write_value;

    // ### Components ###

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

    // ### Pipeline wires ###

    // Fetch -> Decode
    wire [31:0] if_de_pc; // Unused
    wire [31:0] if_de_instr; // 

    // Decode -> Execute
    wire [20:0] de_ex_imm;
    wire [2:0] de_ex_aluOp;
    wire de_ex_aluSrc;
    wire [4:0] de_ex_rd;

    // Execute -> Memory
    wire [31:0] ex_mem_result;
    wire [4:0] ex_mem_rd;

    // Memory -> Writeback
    wire [31:0] mem_wr_data_out;
    wire mem_wr_mem_done;
    wire mem_we_rd;
    wire [4:0] mem_wr_rd_out;

    // Writeback -> Fetch
    wire wr_if_pc_src;
    wire [31:0] wr_if_branch_target;

    // ### Pipeline ###

    fetch fetch(
        .clk(clock),
        .rst(reset),
        
        .pc_src(wr_if_pc_src), // May come from writeback, but ideally from memory stage
        .branch_target(wr_if_branch_target), // May come from writeback, but ideally from memory stage
        .rom_data(rom_data),

        .pc(if_de_pc), // TODO: goes to memory stage for auipc instruction
        .instr(if_de_instr),
    );

    decode decode(
        .clk(clock),
        .rst(reset),
        
        .next_instruction(if_de_instr),
        
        .imm(de_ex_imm),
        .rd(de_ex_rd),
        .rs1(rb_read_address1),
        .rs2(rb_read_address2),
        
        .AluOp(de_ex_aluOp),
        .AluSrc(de_ex_aluSrc),
    );

    execute execute(
        .clk(clock),
        .rst(reset),
        
        .rs1_value(rb_value1),
        .rs2_value(rb_value1),
        .imm(de_ex_imm),
       
        // Control signals
        .AluSrc(de_ex_aluSrc),
        .AluOp(de_ex_aluOp),
        .in_MemWrite(),
        .in_MemRead(),
        .in_RegWrite(),
        .in_RegDest(),
        .in_AluControl(),
        .in_Branch(),
        .in_MemToReg(),
        .in_RegDataSrc(),
        .in_PCSrc(),

        .result(ex_mem_result),
        .rd_out(ex_mem_rd),
    );

    memory memory(
        .clk(clock),
        .rst(reset),

        .addr(),
        .data_in(ex_mem_result),
        .load_store(),
        .op(),
        .mem_read_data(ram_data_out),
        .rd(ex_mem_rd),

        .mem_addr(ram_address),
        .mem_write_data(ram_data_in),
        .mem_write_enable(ram_write_enable),
        .data_out(mem_wr_data_out),
        .mem_done(mem_wr_mem_done),
        .rd_out(mem_wr_rd_out),
    );

    writeback writeback(
        .clk(clock),
        .rst(reset),

        .mem_done(mem_wr_mem_done),
        .rd(mem_wr_rd_out),
        .data_mem(mem_wr_data_out),
        .result_alu(),
        .mem_to_reg_ctrl(),
        // .pc_src(wr_if_pc_src),

        .rd_out(rb_write_address),
        .rb_write_en(rb_write_enable),
        .data_wb(rb_write_value),
    );

endmodule
