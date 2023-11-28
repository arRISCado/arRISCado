`include "../../testbenches/utils/imports.v"

module test;

    // Define constants

    // inputs
    reg clock = 0; // Initialize clock to 0
    reg reset = 0;
    reg [31:0] addr;
    reg [31:0] data_in;
    reg stall;
    wire stall_from_memory;
    wire memory_tb;

    // from RAM signal
    wire [31:0] mem_read_data;

    // control signals
    reg MemRead;          // load command signal
    reg MemWrite;         // store command signal

    // outputs
    wire [31:0] data_out;
    wire mem_done;

    // to RAM signals
    wire [31:0] mem_addr;
    wire [31:0] mem_write_data;
    wire mem_write_enable;

    wire MemToReg;
    wire RegWrite;
    wire [4:0] RegDest;
    wire RegDataSrc;
    wire PCSrc;
    wire [31:0] BranchTarget;
    wire [31:0] AluResult;

    // Instantiate the RAM module
    ram ram_test(
        .clk(clock), 
        .reset(reset),
        .address(mem_addr), // Correct the signal name
        .data_in(mem_write_data), // Correct the signal name
        .write_enable(mem_write_enable), // Correct the signal name
        .data_out(mem_read_data) // Correct the signal name
    );

    // Instantiate the memory module
    memory memory_test (
        // inputs
        .clk(clock),
        .rst(reset),
        .stall(stall),

        .addr(addr),
        .data_in(data_in),

        // from RAM signal
        .mem_read_data(mem_read_data),

        // control inputs
        .MemRead(MemRead),
        .MemWrite(MemWrite),

        .in_MemToReg(1'b0), // todos os in_ não são alterados e serão passados para out
        .in_RegWrite(1'b0),
        .in_RegDest(5'b0),
        .in_RegDataSrc(1'b0),
        .in_PCSrc(1'b0),
        .in_BranchTarget(32'b0),

        // output
        .data_out(data_out),
        .mem_done(mem_done),

        .out_MemToReg(MemToReg),
        .out_RegWrite(RegWrite),
        .out_RegDest(RegDest),
        .out_RegDataSrc(RegDataSrc),
        .out_PCSrc(PCSrc),
        .out_AluResult(AluResult),
        .out_BranchTarget(BranchTarget),

        // to RAM signals
        .mem_addr(mem_addr),
        .mem_write_data(mem_write_data),
        .mem_write_enable(mem_write_enable),
        .stall_pipeline(stall_from_memory)
    );


      initial begin
        $dumpfile("memory_tb.vcd");
        $dumpvars(0, memory_tb);

        // Test case 1
        reset = 1;
        #10 reset = 0;

        // Test case 2
        #10 addr = 32'h1000;
        data_in = 32'hABCDEFF0;
        MemRead = 1;
        #10 MemRead = 0;

        // Test case 3
        #10 addr = 32'h2000;
        data_in = 32'h12345678;
        MemWrite = 1;
        #10 MemWrite = 0;

        // Add more test cases as needed

        #100 $finish;
    end

    // Monitor
    always @(posedge clock) begin
        $display("Time %0t: addr = %h, data_in = %h, mem_read_data = %h, data_out = %h, mem_done = %b", $time, addr, data_in, mem_read_data, data_out, mem_done);
        $display("Time %0t: mem_addr = %h, mem_write_data = %h, mem_write_enable = %b, stall_from_memory = %b", $time, mem_addr, mem_write_data, mem_write_enable, stall_from_memory);
    end



endmodule