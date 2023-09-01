`define ROM_FILE "../../testbenches/if_de_ex_wb_tb.txt"

`include "../../project/rom.v"
`include "../../project/ram.v"
`include "../../project/cpu/fetch.v"
`include "../../project/cpu/decode.v"
`include "../../project/cpu/execute.v"
`include "../../project/cpu/writeback.v"
`include "../../project/cpu/alu.v"
`include "../../project/cpu/register_bank.v"

module test;

    // Test Inputs
    reg clock;
    reg pc_src = 0;
    reg [31:0] branch_target = 0;

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
        .data_out(ram_data_out)
    );

    rom rom(
        .address(rom_address),
        .data(rom_data)
    );

    register_bank RegisterBank(
        .clk(clock), // Unused
        .reset(reset),
        .write_enable(rb_write_enable),
        .write_address(rb_write_address),
        .write_value(rb_write_value),
        .read_address1(rb_read_address1),
        .read_address2(rb_read_address2),
        .value1(rb_value1),
        .value2(rb_value2)
    );

    // ### Pipeline wires ###

    // Fetch -> Decode
    wire [31:0] if_de_pc; // Unused
    wire [31:0] if_de_instr;

    // Decode -> Execute
    wire [31:0] de_ex_imm;
    wire [2:0] de_ex_aluOp;
    wire de_ex_aluSrc;
    wire [4:0] de_ex_rd;

    // Execute -> Memory
    wire [31:0] ex_mem_result;
    wire [4:0] ex_mem_rd;

    assign ex_mem_rd = mem_wr_rd_out;

    // Memory -> Writeback
    wire [31:0] mem_wr_data_out;
    reg mem_wr_mem_done = 0;
    wire [4:0] mem_wr_rd_out;

    // Writeback -> Fetch
    wire wr_if_pc_src;
    wire [31:0] wr_if_branch_target;

    // ### Pipeline ###

    fetch fetch(
        .clk(clock),
        .rst(reset),
        
        .pc_src(pc_src), // May come from writeback, but ideally from memory stage
        .branch_target(branch_target), // May come from writeback, but ideally from memory stage
        .rom_data(rom_data),
        .rom_address(rom_address),

        .pc(if_de_pc), // TODO: goes to memory stage for auipc instruction
        .instr(if_de_instr)
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
        .AluSrc(de_ex_aluSrc)
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
        .a(a),
        .b(b),
        .rd_out(ex_mem_rd)
    );

    writeback writeback(
        .clk(clock),
        .rst(reset),

        .mem_done(mem_wr_mem_done),
        .rd(mem_wr_rd_out),
        .data_mem(mem_wr_data_out),
        .result_alu(ex_mem_result),
        // .mem_to_reg_ctrl(),
        // .pc_src(wr_if_pc_src),

        .rd_out(rb_write_address),
        .rb_write_en(rb_write_enable),
        .data_wb(rb_write_value)
    );

    wire [31:0] a;
    wire [31:0] b;

    integer i;

    // Testbench procedure
    initial begin
        // Initialize inputs
        clock = 0;
        #10;

        // Test case 1: Sequential fetch
        $display("Test Case 1");

        for (i = 0; i < 15; i = i + 1)
        begin
            $display("Instr: %h, AluOp: %b, AluSrc: %b", if_de_instr, de_ex_aluOp, de_ex_aluSrc);
            $display("1: Addr: %h, Value: %h, a: %h", rb_read_address1, rb_value1, a);
            $display("2: Addr: %h, Value: %h, b: %h", rb_read_address2, rb_value2, b);

            clock = 1;
            #10;
            clock = 0;
            #10;
        end

        $finish;
    end

endmodule
