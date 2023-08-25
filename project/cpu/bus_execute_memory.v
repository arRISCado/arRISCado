module bus_execute_emory (
    input clk,                  // Clock signal
    input rst,                  // Reset signal
    input [31:0] instr_ex,      // Instruction from EX stage
    input [4:0] rd_ex,          // Destination register from EX stage
    input mem_read_ex,          // Memory read control from EX stage
    input reg_write_ex,         // Register write control from EX stage
    input [31:0] alu_result_ex, // ALU result from EX stage
    output reg [31:0] instr_mem, // Instruction to MEM stage
    output reg [4:0] rd_mem,     // Destination register to MEM stage
    output reg mem_read_mem,    // Memory read control to MEM stage
    output reg reg_write_mem,   // Register write control to MEM stage
    output reg [31:0] alu_result_mem // ALU result to MEM stage
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            begin
                instr_mem <= 32'b0;
                rd_mem <= 5'b0;
                mem_read_mem <= 1'b0;
                reg_write_mem <= 1'b0;
                alu_result_mem <= 32'b0;
            end
        else
            begin
                instr_mem <= instr_ex;
                rd_mem <= rd_ex;
                mem_read_mem <= mem_read_ex;
                reg_write_mem <= reg_write_ex;
                alu_result_mem <= alu_result_ex;
            end
    end

endmodule
