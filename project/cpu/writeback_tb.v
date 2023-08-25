module writeback_tb;

    reg clk;
    reg mem_done;
    reg [4:0] rd_mem;
    reg [31:0] data_mem;
    reg [4:0] rd_alu;
    reg [31:0] result_alu;
    reg [4:0] rd_wb_ctrl;
    reg mem_to_reg_ctrl;
    wire [4:0] rd_wb;
    wire [31:0] data_wb;

    writeback writeback_inst (
        .clk(clk),
        .mem_done(mem_done),
        .rd_mem(rd_mem),
        .data_mem(data_mem),
        .rd_alu(rd_alu),
        .result_alu(result_alu),
        .rd_wb_ctrl(rd_wb_ctrl),
        .mem_to_reg_ctrl(mem_to_reg_ctrl),
        .rd_wb(rd_wb),
        .data_wb(data_wb)
    );

    initial begin
        clk = 0;
        mem_done = 0;
        rd_mem = 5'b00000;
        data_mem = 32'hAABBCCDD;
        rd_alu = 5'b00101;
        result_alu = 32'h11223344;
        rd_wb_ctrl = 5'b01010; // Let's assume this control value indicates ALU result
        mem_to_reg_ctrl = 0;
        
        // Toggle the clock to observe behavior
        forever #5 clk = ~clk;
    end

endmodule
