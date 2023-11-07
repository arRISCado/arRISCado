`include "../../testbenches/utils/imports.v"

module test;

    reg clock = 0;
    reg reset = 0;
    reg mem_done;
    reg [31:0] data_mem;
    reg [31:0] result_alu;
    wire [31:0] data_wb;
    reg [31:0] addr;
    reg [31:0] data_in;
    reg load_store;
    reg [1:0] op;

    writeback writeback_test (
        // inputs
        .clk(clock),
        .rst(reset),

        .mem_done(mem_done),
        .data_mem(data_mem),
        .result_alu(result_alu),

        // control inputs
        .MemToReg(),
        .in_RegWrite(),
        .in_RegDest(),
        .in_PCSrc(),

        // outputs
        // .rb_write_en(rb_write_en),
        .data_wb(data_wb),

        // control outputs
        .out_RegDest(),
        .out_PCSrc(out_PCSrc)
    );

    // Clock generation
    always begin
        #20 clock = ~clock;
    end

    // Initialize signals
    initial begin
        $display("Test Case 1: Store operation, no reset");
        reset = 0;
        addr = 32'b0010;
        data_in = 32'h1234_5678;
        load_store = 1;
        op = 2'b01; // Store operation
        #100; // Wait for simulation to settle

    end

endmodule
