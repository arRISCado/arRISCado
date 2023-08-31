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
        .next_instruction(instr),
        
        .imm(imm),
        .rd(rd),
        .rs1(rb_read_address1),
        .rs2(rb_read_address2),
        
        .AluOp(aluOp),
        .AluSrc(aluSrc),
        .PCSrc(pc_src),
    );

    wire [20:0] t_imm;
    wire [6:0] t_opcode;
    wire [31:0] t_rb_value1;
    wire [31:0] t_rb_value2;
    wire t_MemWrite;          
    wire t_MemRead;           
    wire t_RegWrite;          
    wire [4:0] t_RegDest;     
    wire t_AluSrc;            
    wire [2:0] t_AluOp;      
    wire [3:0] t_AluControl; 
    wire t_Branch;            
    wire t_MemToReg;          
    wire t_RegDataSrc;        
    wire t_PCSrc;

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
       
        .result(result),

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

endmodule
