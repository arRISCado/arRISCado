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
    output reg [31:0] out_AluResult,       // Propagate ALU result
    output [31:0] mem_write_data, // Send data to write in RAM
    output reg mem_write_enable      // Send signal to enable writing in RAM
);

    reg [31:0] _addr, _data_in;
    reg _load, _store, _MemToReg, _RegWrite, _RegDataSrc, _PCSrc;
    reg [4:0] _RegDest;
    
    assign mem_addr = _addr;
    assign mem_write_data = _data_in;
    assign data_out = mem_read_data;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            _addr <= 0;
            _data_in <= 0;
            _load <= 0;
            _store <= 0;
            
            _MemToReg <= 0;
            _RegWrite <= 0;
            _RegDest <= 0;
            _RegDataSrc <= 0;
            _PCSrc <= 0;
            mem_done <= 0;
            mem_write_enable <= 0;
        end
        else 
        begin
            // Input signals from execute and control
            _addr <= addr;
            _data_in <= data_in;
            _load <= MemRead;
            _store <= MemWrite;

            // Control signals to the next step
            _MemToReg <= in_MemToReg;
            _RegWrite <= in_RegWrite;
            _RegDest <= in_RegDest;
            _RegDataSrc <= in_RegDataSrc;
            _PCSrc <= in_PCSrc;

            if (_load)
            begin
                mem_write_enable <= 0;
                mem_done <= 1;
            end
            else if (MemWrite)
            begin
                mem_write_enable <= 1;
                mem_done <= 1;
            end
            else
            begin
                mem_write_enable <= 0;
                mem_done <= 0;
            end
        end
    end

    always @(*)
    begin   
        out_MemToReg <= _MemToReg;
        out_RegWrite <= _RegWrite;
        out_RegDest <= _RegDest;
        out_RegDataSrc <= _RegDataSrc;
        out_PCSrc <= _PCSrc;
        out_AluResult <= _addr;
    end

endmodule

`endif