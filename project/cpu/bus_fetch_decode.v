module bus_fetch_decode (
    input clk,                // Clock signal
    input rst,                // Reset signal
    input [31:0] instruction, // Instruction from IF stage
    input [4:0] rd_if,        // Destination register from IF stage
    input mem_read_ctrl,      // Control signal for memory read
    input reg_write_ctrl,     // Control signal for register write
    output reg [31:0] instr_id, // Instruction to ID stage
    output reg [4:0] rd_id,     // Destination register to ID stage
    output reg mem_read_id,    // Memory read control to ID stage
    output reg reg_write_id    // Register write control to ID stage
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            begin
                instr_id <= 32'b0;
                rd_id <= 5'b0;
                mem_read_id <= 1'b0;
                reg_write_id <= 1'b0;
            end
        else
            begin
                instr_id <= instruction;
                rd_id <= rd_if;
                mem_read_id <= mem_read_ctrl;
                reg_write_id <= reg_write_ctrl;
            end
    end

endmodule