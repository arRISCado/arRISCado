module writeback_tb;

    reg clock = 0;
    reg reset = 0;
    reg mem_done;
    reg [31:0] data_mem;
    reg [31:0] result_alu;
    reg mem_to_reg_ctrl;
    wire [31:0] data_wb;

    writeback writeback_test (
        // inputs
        .clk(clock),
        .rst(reset),

        .mem_done(mem_done),
        .data_mem(data_mem),
        .result_alu(result_alu),
        .mem_to_reg_ctrl(mem_to_reg_ctrl),

        // control inputs
        .RegWrite(mem_wr_RegWrite),
        .RegDataSrc(mem_wr_RegDataSrc),
        .in_RegDest(mem_wr_RegDest),
        .in_PCSrc(mem_wr_PCSrc),

        // outputs
        .rb_write_en(rb_write_en),
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
        $display("\n\nTest Case 1: Store operation, no reset");
        reset = 0;
        addr = 32'b0010;
        data_in = 32'h1234_5678;
        load_store = 1;
        op = 2'b01; // Store operation
        #100; // Wait for simulation to settle

    end

endmodule
