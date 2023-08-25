module bus_decode_execute (
    input clk,                 // Clock signal
    input rst,                 // Reset signal
    input [31:0] instr_id,     // Instruction from ID stage
    input [4:0] rd_id,         // Destination register from ID stage
    input mem_read_id,         // Memory read control from ID stage
    input reg_write_id,        // Register write control from ID stage
    output reg [31:0] instr_ex, // Instruction to EX stage
    output reg [4:0] rd_ex,     // Destination register to EX stage
    output reg mem_read_ex,    // Memory read control to EX stage
    output reg reg_write_ex    // Register write control to EX stage
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            begin
                instr_ex <= 32'b0;
                rd_ex <= 5'b0;
                mem_read_ex <= 1'b0;
                reg_write_ex <= 1'b0;
            end
        else
            begin
                instr_ex <= instr_id;
                rd_ex <= rd_id;
                mem_read_ex <= mem_read_id;
                reg_write_ex <= reg_write_id;
            end
    end

endmodule