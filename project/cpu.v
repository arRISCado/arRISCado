`include "ram.v"
`include "rom.v"
`include "cpu/register_bank.v"
`include "cpu/alu.v"
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

    // Main control
    wire stop_de;
    wire stop_ex;
    wire stop_mem;
    wire stop_wb;

    wire enable_if;
    wire enable_de;
    wire enable_ex;
    wire enable_mem;


    // Fetch -> Decode
    wire [31:0] if_de_pc;
    wire [31:0] if_de_instr;

    // Decode -> Execute
    wire [31:0] de_ex_imm;          // Dies on execute
    wire [2:0] de_ex_aluOp;         // Dies on execute
    wire de_ex_aluSrc;              // Dies on execute
    wire [3:0] de_ex_AluControl;    // Dies on execute
    wire de_ex_Branch;              // Dies on Execute
    wire de_ex_MemWrite;            // Goes to MEM stage
    wire de_ex_MemRead;             // Goes to MEM stage
    wire de_ex_RegWrite;            // Goes to WB
    wire [4:0] de_ex_RegDest;       // Goes to WB
    wire de_ex_MemToReg;            // Goes to MEM
    wire de_ex_RegDataSrc;          // Goes to WB
    wire de_ex_PCSrc;               // Goes to next Fetch

    // Execute -> Memory
    wire [31:0] ex_mem_result;

    wire ex_mem_MemRead;             // Dies on MEM
    wire ex_mem_MemWrite;            // Dies on MEM
    wire ex_mem_MemToReg;            // Dies on MEM
    wire ex_mem_RegWrite;            // Goes to WB
    wire [4:0] ex_mem_RegDest;       // Goes to WB
    wire ex_mem_RegDataSrc;          // Goes to WB
    wire ex_mem_PCSrc;               // Goes to next Fetch

    // Memory -> Writeback
    wire [31:0] mem_wb_data_out;
    wire mem_wb_mem_done;

    wire mem_wb_RegWrite;            // Dies on WB
    wire mem_wb_RegDataSrc;          // Dies on WB
    wire [4:0] mem_wb_RegDest;       // Goes to RB
    wire mem_wb_PCSrc;               // Goes to next Fetch

    // Writeback -> Fetch
    wire [31:0] wr_if_branch_target;

    wire wr_if_PCSrc;               // Dies on Fetch

    // ### Pipeline ###

    fetch fetch(
        .clk(clock),
        .rst(reset),
        .enable(enable),
        
        .branch_target(wr_if_branch_target), // May come from writeback, but ideally from memory stage
        .rom_data(rom_data),

        .PCSrc(wr_if_pc_src), // May come from writeback, but ideally from memory stage

        .pc(if_de_pc), // TODO: goes to memory stage for auipc instruction
        .instr(if_de_instr),
    );

    decode decode(
        .clk(clock),
        .rst(reset),
        .enable(enable_if),
        .stop_behind(stop_de),
        
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
        .enable(enable_ex),
        .stop_behind(stop_ex),
        
        .rs1_value(rb_value1),
        .rs2_value(rb_value1),
        .imm(de_ex_imm),
       
        // Control signals
        .AluSrc(de_ex_aluSrc),
        .AluOp(de_ex_aluOp),
        .AluControl(de_ex_AluControl),
        .Branch(de_ex_Branch),
        .in_MemWrite(de_ex_MemWrite),
        .in_MemRead(de_ex_MemRead),
        .in_RegWrite(de_ex_RegWrite),
        .in_RegDest(de_ex_RegDest),
        .in_MemToReg(de_ex_MemToReg),
        .in_RegDataSrc(de_ex_RegDataSrc),
        .in_PCSrc(de_ex_PCSrc),

        .result(ex_mem_result),
    );

    memory memory(
        .clk(clock),
        .rst(reset),
        .enable(enable_mem),
        .stop_behind(stop_mem),

        .addr(),
        .data_in(ex_mem_result),
        .load_store(),
        .op(),
        .mem_read_data(ram_data_out),

        .MemRead(ex_mem_MemRead),
        .MemWrite(ex_mem_MemWrite),
        .MemToReg(ex_mem_MemToReg),

        .in_RegWrite(ex_mem_RegWrite),
        .in_RegDest(ex_mem_RegDest),
        .in_RegDataSrc(ex_mem_RegDataSrc),
        .in_PCSrc(ex_mem_PCSrc),

        .mem_addr(ram_address),
        .mem_write_data(ram_data_in),
        .mem_write_enable(ram_write_enable),
        .data_out(mem_wb_data_out),
        .mem_done(mem_wb_mem_done),
    );

    writeback writeback(
        .clk(clock),
        .rst(reset),
        .enable(1),
        .stop_behind(stop_wb),

        .mem_done(mem_wb_mem_done),
        .data_mem(mem_wb_data_out),
        .result_alu(),
        .mem_to_reg_ctrl(),

        .RegWrite(mem_wb_RegWrite),
        .RegDataSrc(mem_wb_RegDataSrc),
        .in_RegDest(mem_wb_RegDest),
        .in_PCSrc(mem_wb_PCSrc),

        .rb_write_en(rb_write_enable),
        .data_wb(rb_write_value),
    );

    always @(clock) begin
        enable_if = !(stop_de || stop_ex || stop_mem || stop_wb);
        enable_de = !(stop_ex || stop_mem || stop_wb);
        enable_ex = !(stop_mem || stop_wb);
        enable_mem = !(stop_wb);
    end

endmodule
