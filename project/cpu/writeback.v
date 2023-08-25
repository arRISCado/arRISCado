module writeback (
    input clk,             // Clock signal
    input mem_done,        // Memory operation done signal from the memory stage
    input [4:0] rd_mem,    // Destination register for memory operation
    input [31:0] data_mem, // Data read from memory
    input [4:0] rd_alu,    // Destination register for ALU operation
    input [31:0] result_alu, // Result of ALU operation
    input [4:0] rd_wb_ctrl, // Destination register for writeback determined by control
    input mem_to_reg_ctrl, // Control signal to select memory result for writeback
    output reg [4:0] rd_wb, // Destination register for writeback
    output reg [31:0] data_wb // Data to be written back
);

    always @(posedge clk) begin
        if (mem_done && mem_to_reg_ctrl)
            begin
                rd_wb <= rd_mem;
                data_wb <= data_mem;
            end
        else
            begin
                rd_wb <= rd_alu;
                data_wb <= result_alu;
            end
    end

endmodule
