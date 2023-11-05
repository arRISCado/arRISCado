`ifndef MEMORY_STAGE
`define MEMORY_STAGE

module memory (
    input clk,                 // Clock signal
    input rst,                 // Reset signal
    input [31:0] addr,         // Address input
    input [31:0] data_in,      // Data input to be written
    
    input [31:0] mem_read_data, // Data from RAM

    // Control Signals
    input MemRead,          // load command signal
    input MemWrite,         // store command signal
    input in_MemToReg,      // Just goes to the next stage
    input in_RegWrite,      // Just goes to the next stage
    input [4:0] in_RegDest, // Just goes to the next stage
    input in_RegDataSrc,    // Just goes to the next stage
    input in_PCSrc,         // Just goes to the next stage

    output [31:0] data_out,       // Data output read from memory
    output reg mem_done,              // Memory operation done signal

    // Control Signals
    output reg out_MemToReg,
    output reg out_RegWrite,
    output reg [4:0] out_RegDest,
    output reg out_RegDataSrc,
    output reg out_PCSrc,

    // to RAM signals
    output [31:0] mem_addr,       // Send   address to RAM
    output [31:0] out_AluResult,       // Propagate ALU result
    output [31:0] mem_write_data, // Send data to write in RAM
    output reg mem_write_enable      // Send signal to enable writing in RAM
);

    reg [31:0] _addr, _data_in;
    reg _load, _store;
    reg [4:0] _RegDest;

    assign mem_addr = _addr;
    assign mem_write_data = _data_in;
    assign data_out = mem_read_data;
    assign out_AluResult = _addr;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            _addr <= 0;
            _data_in <= 0;
            _load <= 0;
            _store <= 0;
            
            out_MemToReg <= 0;
            out_RegWrite <= 0;
            out_RegDest <= 0;
            out_RegDataSrc <= 0;
            out_PCSrc <= 0;
            mem_write_enable <= 0;
            mem_done <= 0;
        end
        else 
        begin
            // Input signals from execute and control
            _addr <= addr;
            _data_in <= data_in;
            _load <= MemRead;
            _store <= MemWrite;

            // Control signals to the next step
            out_MemToReg <= in_MemToReg;
            out_RegWrite <= in_RegWrite;
            out_RegDest <= in_RegDest;
            out_RegDataSrc <= in_RegDataSrc;
            out_PCSrc <= in_PCSrc;
            mem_done <= 1;

            if (mem_write_enable)
                mem_write_enable <= 0;

            `ifdef TESTBENCH
            if (MemWrite)
            `elsif TEST
            if (MemWrite)
            `else
            if (_store)
            `endif
                mem_write_enable <= 1;
        end
    end
endmodule
`endif
