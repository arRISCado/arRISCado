`ifndef CPU
`define CPU

module cpu(
    input clock,
    input physical_clk,
    input reset,
    output [5:0] led,
    input enable,
    input btn1,
    input btn2,
    input [31:0] rom_data,
    output wire [7:0] rom_address,
    output port_pwm1
);
    assign led[5] = clock_real;
    assign led[4] = ~enable;
    //assign led[4:0] = ex_mem_result[4:0];
    //assign led[5:0] = ~rom_data[5:0];

    //assign led[5] = (if_de_instr == 32'd99) ? 0 : 1;
    //assign led[4] = (mem_data_in == 32'd5) ? 0 : 1;
    //assign led[3] = (mmu_p_data_in == 32'd5) ? 0 : 1;
    //assign led[2] = (mmu_p_write_enable == 1) ? 0 : 1;
    ////assign led[1] = (ram_write_enable == 1) ? 0 : 1;
    //assign led[1] = (mem_address == 32'd536870912) ? 0 : 1;
    ////assign led[0] = (mem_write_enable == 1) ? 0 : 1;

    wire clock_real = clock & enable;

    // ### Component wires ###

    // Cache
    wire [31:0] mem_address, mem_data_in, mem_data_out;
    wire mem_write_enable, mem_data_ready;

    // RAM
    wire [31:0] ram_address, ram_data_in, ram_data_out;
    wire ram_write_enable;
    
    // Register Bank
    wire rb_write_enable;
    wire [4:0] rb_write_address, rb_read_address1, rb_read_address2;
    wire [31:0] rb_value1, rb_value2, rb_write_value;


    // ### Stall Control ###
    wire stall;
    wire stall_from_mem;
    wire stall_from_ex;

    assign stall = stall_from_mem || stall_from_ex;

    // ### Components ###

    // Memories

    ram Ram(
        .clk(clock_real), 
        .reset(reset),
        .address(ram_address),
        .data_in(ram_data_in),
        .write_enable(ram_write_enable),
        // .led(led),
        .data_out(ram_data_out)
    );

    wire [31:0] mmu_p_address;
    wire [31:0] mmu_p_data_in;
    wire mmu_p_write_enable;
    wire [31:0] p_mmu_data;
    wire p_mmu_data_ready;
    
    peripheral_manager Peripheral_manager(
        .clk(clock_real),
        .physical_clk(physical_clk),
        .addr(mmu_p_address),
        .data_in(mmu_p_data_in),
        .write_enable(mmu_p_write_enable),
        .btn1(btn1),
        .btn2(btn2),
        .pwm1_out(port_pwm1),
        .data_out(p_mmu_data)
        //,.debug_led(led[4:0])
    );

    mmu MMU(
        .clk(clock_real),
        
        .c_address(mem_address),
        .c_data_in(mem_data_in),
        .c_write_enable(mem_write_enable),
        .c_data_ready(mem_data_ready),
        .c_data_out(mem_data_out),
        
        .m_address(ram_address),
        .m_data_in(ram_data_in),
        .m_write_enable(ram_write_enable),
        .m_data_ready(1'b1),
        .m_data_out(ram_data_out),

        .p_address(mmu_p_address),
        .p_data_in(mmu_p_data_in),
        .p_write_enable(mmu_p_write_enable),
        .p_data_ready(1'd1),
        .p_data_out(p_mmu_data)
    );

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
        //,.debug_led(led)
    );

    // ### Pipeline wires ###

    // Fetch -> Decode
    wire [31:0] if_de_pc;
    wire [31:0] if_de_instr;
    
    // Fetch -> Register Bank
    wire if_rb_RegWrite;            // Dies on Register Bank
    wire if_rb_RegDest;             // Dies on Register Bank

    // Decode -> Execute
    wire [2:0] de_ex_BranchType;
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
    wire de_ex_PCSrc;               // Goes to next Fetch
    wire [31:0] de_ex_PC;
    wire [31:0] de_ex_value1;
    wire [31:0] de_ex_value2;

    // Execute -> Memory
    wire [31:0] ex_mem_BranchTarget;
    wire [31:0] ex_mem_result;
    wire ex_mem_MemRead;             // Dies on MEM: There's load operation
    wire ex_mem_MemWrite;            // Dies on MEM: There's store operation
    wire ex_mem_MemToReg;            // Goes to WB: 1 = result to register, 0: result is from ALU (execute stage)
    wire ex_mem_RegWrite;            // Goes to WB
    wire [4:0] ex_mem_RegDest;       // Goes to WB
    wire ex_mem_PCSrc;               // Goes to next Fetch
    wire [31:0] ex_mem_rs2_value;

    // Memory -> Writeback
    wire [31:0] mem_wb_data_out;
    wire mem_wb_MemToReg;
    wire mem_wb_RegWrite;            // Dies on WB
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
        .stall(stall),
        
        .in_BranchTarget(wb_if_BranchTarget),
        .rom_data(rom_data),
        .rom_address(rom_address),

        .PCSrc(wb_if_PCSrc),

        .pc(if_de_pc),
        .instr(if_de_instr)
    );

    decode Decode(
        .clk(clock_real),
        .rst(reset),
        .stall(stall),
        
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
        .PCSrc(de_ex_PCSrc),
        .BranchType(de_ex_BranchType),
        .PC_out(de_ex_PC),
        .value1(de_ex_value1),
        .value2(de_ex_value2)
    );

    execute Execute(
        .clk(clock_real),
        .rst(reset),
        .stall(stall_from_mem),
        
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
        .out_PCSrc(ex_mem_PCSrc),
        .out_BranchTarget(ex_mem_BranchTarget),

        ._rs2_value(ex_mem_rs2_value),
        .result(ex_mem_result),
        .stall_pipeline(stall_from_ex),
        .PC(de_ex_PC)
    );

    wire [31:0] mem_wb_BranchTarget;

    memory Memory(
        .clk(clock_real),
        .rst(reset),

        .addr(ex_mem_result), // deve ser atualizado
        .data_in(ex_mem_rs2_value), 

        // from RAM signals
        .mem_read_data(mem_data_out),

        // control inputs
        .MemRead(ex_mem_MemRead), // sinal de load
        .MemWrite(ex_mem_MemWrite), // sinal de store

        .in_MemToReg(ex_mem_MemToReg), // todos os in_ não são alterados e serão passados para out
        .in_RegWrite(ex_mem_RegWrite),
        .in_RegDest(ex_mem_RegDest),
        .in_PCSrc(ex_mem_PCSrc),
        .in_BranchTarget(ex_mem_BranchTarget),

        // outputs
        .data_out(mem_wb_data_out),
        .mem_done(mem_wb_mem_done),

        // control outputs
        .out_MemToReg(mem_wb_MemToReg),
        .out_RegWrite(mem_wb_RegWrite),
        .out_RegDest(mem_wb_RegDest),
        .out_PCSrc(mem_wb_PCSrc),
        .out_AluResult(mem_wb_AluResult),
        .out_BranchTarget(mem_wb_BranchTarget),

        // to RAM signals
        .mem_addr(mem_address),
        .mem_write_data(mem_data_in),
        .mem_write_enable(mem_write_enable),
        .stall_pipeline(stall_from_mem)
    );

    writeback Writeback(
        // inputs
        .clk(clock_real),
        .rst(reset),
        .stall(stall),

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