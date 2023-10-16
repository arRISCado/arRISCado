`ifndef WRITE_BACK
`define WRITE_BACK

module writeback (
    input clk,                  // Clock signal
    input rst,                  // Reset signal
    input mem_done,             // Memory operation done signal from the memory stage
    input [31:0] data_mem,      // Data read from memory
    input [31:0] result_alu,    // Result of ALU operation

    // Control Signals
    input MemToReg,
    input in_RegWrite,
    input in_PCSrc,
    input [4:0] in_RegDest,
    input [11:0] in_BranchOffset,

    output [31:0] data_wb,   // Data to be written back

    // Control Signal
    output reg out_RegWrite,
    output reg [4:0] out_RegDest,
    output reg out_PCSrc,
    output reg [31:0] out_BranchOffset
);
    // TODO: Pensar como carregar o dado de entrada
    reg _mem_done, _MemToReg;
    reg [31:0] _result_alu;

    reg [4:0] _RegDest;
    reg _PCSrc, _RegWrite;
    reg [11:0] _BranchOffset;

    always @(posedge clk or posedge rst) 
    begin
        if (rst)
        begin
            _mem_done <= 0;
            _MemToReg <= 0;
            _result_alu <= 0;

            _RegDest <= 0;
            _PCSrc <= 0;
            _RegWrite <= 0;
        end
        else 
        begin
            _mem_done <= mem_done;
            _MemToReg <= MemToReg;
            _result_alu <= result_alu;

            // Control Signal
            _RegDest <= in_RegDest;
            _PCSrc <= in_PCSrc;
            _RegWrite <= in_RegWrite;
        end
    end

    always @(*)
    begin
        out_RegDest <= _RegDest;
        out_PCSrc <= _PCSrc;
        out_RegWrite <= _RegWrite;
    end

    assign data_wb = (_MemToReg) ? data_mem : _result_alu;
endmodule
`endif
