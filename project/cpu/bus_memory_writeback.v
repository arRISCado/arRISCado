module bus_memory_writeback (
    input clk,                  // Clock signal
    input rst,                  // Reset signal
    input [31:0] instr_mem,     // Instruction from MEM stage
    input [4:0] rd_mem,         // Destination register from MEM stage
    input mem_read_mem,         // Memory read control from MEM stage
    input reg_write_mem,        // Register write control from MEM stage
    input [31:0] alu_result_mem, // ALU result from MEM stage
    input [31:0] data_mem,      // Data read from memory
    input [4:0] rd_alu_mem,     // Destination register from ALU operation in MEM stage
    output reg [31:0] instr_wb, // Instruction to WB stage
    output reg [4:0] rd_wb,     // Destination register to WB stage
    output reg mem_read_wb,    // Memory read control to WB stage
    output reg reg_write_wb,   // Register write control to WB stage
    output reg [31:0] alu_result_wb, // ALU result to WB stage
    output reg [31:0] data_wb,  // Data to be written back
    output reg [4:0] rd_alu_wb  // Destination register from ALU operation in WB stage
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            begin
                instr_wb <= 32'b0;
                rd_wb <= 5'b0;
                mem_read_wb <= 1'b0;
                reg_write_wb <= 1'b0;
                alu_result_wb <= 32'b0;
                data_wb <= 32'b0;
                rd_alu_wb <= 5'b0;
            end
        else
            begin
                instr_wb <= instr_mem;
                rd_wb <= rd_mem;
                mem_read_wb <= mem_read_mem;
                reg_write_wb <= reg_write_mem;
                alu_result_wb <= alu_result_mem;
                data_wb <= data_mem;
                rd_alu_wb <= rd_alu_mem;
            end
    end

endmodule
