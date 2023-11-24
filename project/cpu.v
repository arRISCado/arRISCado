`ifndef CPU
`define CPU

module cpu(
    input clock,
    input reset,
    output [5:0] led,
    input enable,
    input wire [31:0] rom_data,
    output wire [31:0] rom_address,
    output port_pwm1
);
    assign led[5] = clock_real;
    assign led[4] = port_pwm1;
    assign led[3] = (ram_data_in == 32'd5) ? 0 : 1;
    assign led[2] = (if_de_pc == 32'd72) ? 0 : 1;
    assign led[1] = (ram_address == 32'd536870912) ? 0 : 1;
    assign led[0] = (rb_value2 == 5) ? 0 : 1;
    //assign led[5:0] = ex_mem_result[5:0];

    wire clock_real = clock & enable;

    // ### Component wires ###

    // RAM
    wire [31:0] ram_address, ram_data_in, ram_data_out;
    wire ram_write_enable;
    
    // Register Bank
    wire rb_write_enable;
    wire [4:0] rb_write_address, rb_read_address1, rb_read_address2;
    wire [31:0] rb_value1, rb_value2, rb_write_value;

    // ### Components ###


    // Memories

    //Address map
    //abcxxx...xxx
    //abc = destiny (000 = ram, 001 = peripheral1, ..., 111 = peripheral7)
    //xxx...xxx = addr

    ram Ram(
        .clk(clock_real), 
        .reset(reset),
        .address(ram_address),
        .data_in(ram_data_in),
        .write_enable(ram_write_enable),
        // .led(led),
        .data_out(ram_data_out)
    );

    
    peripheral_manager Peripheral_manager(
        .clk(clock),
        .addr(ram_address),
        .data_in(ram_data_in),
        .write_enable(ram_write_enable),
        .pwm1_out(port_pwm1)
    );

    /*
    rom Rom(
        .address(rom_address),
        .data(rom_data)
    );
    */

    register_bank RegisterBank(
        .clk(clock_real),
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
    wire [31:0] if_de_pc;
    wire [31:0] if_de_instr;
    
    // Fetch -> Register Bank
    wire if_rb_RegWrite;            // Dies on Register Bank
    wire if_rb_RegDest;             // Dies on Register Bank

    // Decode -> Execute
    wire [31:0] de_ex_imm;          // Dies on execute
    wire [4:0] de_ex_rd;
    wire [2:0] de_ex_aluOp;         // Dies on execute
    wire de_ex_aluSrc;              // Dies on execute
    wire [4:0] de_ex_AluControl;    // Dies on execute
    wire de_ex_MemWrite;            // Goes to MEM stage
    wire de_ex_MemRead;             // Goes to MEM stage
    wire de_ex_RegWrite;            // Goes to WB
    wire [4:0] de_ex_RegDest;       // Goes to WB
    wire de_ex_MemToReg;            // Goes to MEM
    wire de_ex_RegDataSrc;          // Goes to WB
    wire de_ex_PCSrc;               // Goes to next Fetch
    wire [31:0] de_ex_PC;
    wire [31:0] de_ex_value1;
    wire [31:0] de_ex_value2;

    // Execute -> Memory
    wire [31:0] ex_mem_result;

    wire ex_mem_MemRead;             // Dies on MEM: There's load operation
    wire ex_mem_MemWrite;            // Dies on MEM: There's store operation
    wire ex_mem_MemToReg;            // Goes to WB: 1 = result to register, 0: result is from ALU (execute stage)
    wire ex_mem_RegWrite;            // Goes to WB
    wire [4:0] ex_mem_RegDest;       // Goes to WB
    wire ex_mem_RegDataSrc;          // Goes to WB
    wire ex_mem_PCSrc;               // Goes to next Fetch
    wire [31:0] ex_mem_rs2_value;

    // Memory -> Writeback
    wire [31:0] mem_wb_data_out;
    wire mem_wb_mem_done;

    wire mem_wb_RegWrite;            // Dies on WB
    wire mem_wb_RegDataSrc;          // Dies on WB
    wire mem_wb_MemToReg;            // Dies on WB
    wire [4:0] mem_wb_RegDest;       // Goes to RB
    wire mem_wb_PCSrc;               // Goes to next Fetch
    wire [31:0] mem_wb_AluResult;

    // Writeback -> Fetch
    wire [31:0] wb_if_BranchTarget;
    wire wb_if_PCSrc;               // Dies on Fetch

    // ### Pipeline ###

    fetch Fetch(
        .clk(clock_real),
        .rst(reset),
        
        .in_BranchTarget(wb_if_BranchTarget), // May come from writeback, but ideally from memory stage
        .rom_data(rom_data),
        .rom_address(rom_address),

        .PCSrc(wb_if_PCSrc), // May come from writeback, but ideally from memory stage

        .pc(if_de_pc), // TODO: goes to memory stage for auipc instruction
        .instr(if_de_instr)
    );

    wire [2:0] de_ex_BranchType;

    decode Decode(
        .clk(clock_real),
        .rst(reset),
        
        .next_instruction(if_de_instr),
        .PC(if_de_pc),
        .regbank_value1(rb_value1),
        .regbank_value2(rb_value2),
        
        .imm(de_ex_imm),
        .rs1(rb_read_address1),
        .rs2(rb_read_address2),
        
        .AluOp(de_ex_aluOp),
        .AluSrc(de_ex_aluSrc),
        .AluControl(de_ex_AluControl),
        .MemWrite(de_ex_MemWrite),
        .MemRead(de_ex_MemRead),
        .RegWrite(de_ex_RegWrite),
        .RegDest(de_ex_RegDest),
        .MemToReg(de_ex_MemToReg),
        .RegDataSrc(de_ex_RegDataSrc),
        .PCSrc(de_ex_PCSrc),
        .BranchType(de_ex_BranchType),
        .PC_out(de_ex_PC),
        .value1(de_ex_value1),
        .value2(de_ex_value2)
    );

    wire [31:0] ex_mem_BranchTarget;

    execute Execute(
        .clk(clock_real),
        .rst(reset),
        
        .rs1_value(rb_value1),//(de_ex_value1),
        .rs2_value(rb_value2),//(de_ex_value2),
        .imm(de_ex_imm),
       
        // control inputs
        .AluSrc(de_ex_aluSrc),
        .AluOp(de_ex_aluOp),
        .AluControl(de_ex_AluControl),
        .in_MemWrite(de_ex_MemWrite),
        .in_MemRead(de_ex_MemRead),
        .in_RegWrite(de_ex_RegWrite),
        .in_RegDest(de_ex_RegDest),
        .in_MemToReg(de_ex_MemToReg),
        .in_RegDataSrc(de_ex_RegDataSrc),
        .in_PCSrc(de_ex_PCSrc),
        .in_BranchType(de_ex_BranchType),

        // Data Fowarding
        .rb_read_address1(rb_read_address1),
        .rb_read_address2(rb_read_address2),

        // Data Fowarding Execute Signals
        .ex_mem_RegWrite(ex_mem_RegWrite),
        .ex_mem_RegDest(ex_mem_RegDest),
        .in_result(ex_mem_result),

        // Data Fowarding Memory Signals
        .mem_wb_RegWrite(mem_wb_RegWrite),
        .mem_wb_RegDest(mem_wb_RegDest),
        .mem_wb_data_out(mem_wb_data_out),
        .mem_wb_AluResult(mem_wb_AluResult),

        // Control Outputs
        .out_MemWrite(ex_mem_MemWrite),
        .out_MemRead(ex_mem_MemRead),
        .out_RegWrite(ex_mem_RegWrite),
        .out_RegDest(ex_mem_RegDest),
        .out_MemToReg(ex_mem_MemToReg),
        .out_RegDataSrc(ex_mem_RegDataSrc),
        .out_PCSrc(ex_mem_PCSrc),
        .out_BranchTarget(ex_mem_BranchTarget),

        ._rs2_value(ex_mem_rs2_value),
        .result(ex_mem_result),
        .PC(de_ex_PC)
    );

    wire [31:0] mem_wb_BranchTarget;

    memory Memory(
        .clk(clock_real),
        .rst(reset),

        .addr(ex_mem_result), // deve ser atualizado
        .data_in(ex_mem_rs2_value), 

        // from RAM signals
        .mem_read_data(ram_data_out),

        // control inputs
        .MemRead(ex_mem_MemRead), // sinal de load
        .MemWrite(ex_mem_MemWrite), // sinal de store

        .in_MemToReg(ex_mem_MemToReg), // todos os in_ não são alterados e serão passados para out
        .in_RegWrite(ex_mem_RegWrite),
        .in_RegDest(ex_mem_RegDest),
        .in_RegDataSrc(ex_mem_RegDataSrc),
        .in_PCSrc(ex_mem_PCSrc),
        .in_BranchTarget(ex_mem_BranchTarget),

        // outputs
        .data_out(mem_wb_data_out),
        .mem_done(mem_wb_mem_done),

        // control outputs
        .out_MemToReg(mem_wb_MemToReg),
        .out_RegWrite(mem_wb_RegWrite),
        .out_RegDest(mem_wb_RegDest),
        .out_RegDataSrc(mem_wb_RegDataSrc),
        .out_PCSrc(mem_wb_PCSrc),
        .out_AluResult(mem_wb_AluResult),
        .out_BranchTarget(mem_wb_BranchTarget),

        // to RAM signals
        .mem_addr(ram_address),
        .mem_write_data(ram_data_in),
        .mem_write_enable(ram_write_enable)
    );

    wire [4:0] wb_if_RegDest; //LIGAR

    writeback Writeback(
        // inputs
        .clk(clock_real),
        .rst(reset),

        .mem_done(mem_wb_mem_done),
        .data_mem(mem_wb_data_out),
        .result_alu(mem_wb_AluResult),

        // control inputs
        .MemToReg(mem_wb_MemToReg),

        .in_RegWrite(mem_wb_RegWrite),
        .in_RegDest(mem_wb_RegDest),
        .in_PCSrc(mem_wb_PCSrc),
        .in_BranchTarget(mem_wb_BranchTarget),

        // outputs
        .data_wb(rb_write_value),

        // control outputs
        .out_PCSrc(wb_if_PCSrc),
        .out_BranchTarget(wb_if_BranchTarget),
        
        .out_RegWrite(rb_write_enable),
        .out_RegDest(rb_write_address)  // vai para o Register Bank
    );
endmodule

`endif