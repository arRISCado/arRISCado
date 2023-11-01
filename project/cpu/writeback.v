`ifndef WRITE_BACK
`define WRITE_BACK

module writeback (
    input clk,                  // Clock signal
    input rst,                  // Reset signal
    input stall,

    input mem_done,             // Memory operation done signal from the memory stage
    input [31:0] data_mem,      // Data read from memory
    input [31:0] result_alu,    // Result of ALU operation

    // Control Signals
    input MemToReg,
    input in_RegWrite,
    input [4:0] in_RegDest,
    input in_PCSrc,

    output [31:0] data_wb,   // Data to be written back

    // Control Signal
    output reg out_RegWrite,
    output reg [4:0] out_RegDest,
    output reg out_PCSrc
);
    // TODO: Pensar como carregar o dado de entrada
    reg _mem_done, _MemToReg;
    reg [31:0] _result_alu;

    reg [4:0] _RegDest;
    reg _PCSrc, _RegWrite;

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
        else if(~stall)
        begin
            _mem_done <= mem_done;
            _MemToReg <= MemToReg;
            _result_alu <= result_alu;

            // Control Signal
            out_RegDest <= in_RegDest;
            out_PCSrc <= in_PCSrc;
            out_RegWrite <= in_RegWrite;
        end
    end

    assign data_wb = (_MemToReg) ? data_mem : _result_alu;
endmodule
`endif
