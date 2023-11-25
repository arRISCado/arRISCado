`ifndef WRITE_BACK
`define WRITE_BACK

module writeback (
    input clk,                  // Clock signal
    input rst,                  // Reset signal
    input stall,

    input [31:0] data_mem,      // Data read from memory
    input [31:0] result_alu,    // Result of ALU operation

    // Control Signals
    input MemToReg,
    input in_RegWrite,
    input [4:0] in_RegDest,
    input in_PCSrc,
    input [31:0] in_BranchTarget,

    output [31:0] data_wb,   // Data to be written back

    // Control Signal
    output reg out_RegWrite,
    output reg [4:0] out_RegDest,
    output reg [31:0] out_BranchTarget,
    output reg out_PCSrc
);
    reg _MemToReg;
    reg [31:0] _result_alu;
    reg [31:0] _data_mem;

    always @(posedge clk or posedge rst) 
    begin
        if (rst)
        begin
            _MemToReg <= 0;
            _result_alu <= 0;


            out_RegDest <= 0;
            out_PCSrc <= 0;
            out_RegWrite <= 0;
            out_BranchTarget <= 0;
        end
        else 
        begin
            if (~stall) begin
                _MemToReg <= MemToReg;
                _result_alu <= result_alu;

                // Control Signal
                out_RegDest <= in_RegDest;
                out_PCSrc <= in_PCSrc;
                out_BranchTarget <= in_BranchTarget;
                out_RegWrite <= in_RegWrite;
            end
        end
    end

    assign data_wb = (_MemToReg) ? data_mem : _result_alu;
endmodule
`endif
