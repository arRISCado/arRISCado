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


    output reg [31:0] data_out,       // Data output read from memory
    output reg mem_done,              // Memory operation done signal

    // Control Signals
    output reg out_MemToReg,
    output reg out_RegWrite,
    output reg [4:0] out_RegDest,
    output reg out_RegDataSrc,
    output reg out_PCSrc,

    // to RAM signals
    output reg [31:0] mem_addr,       // Send   address to RAM
    output reg [31:0] mem_write_data, // Send data to write in RAM
    output reg mem_write_enable,      // Send signal to enable writing in RAM
);

    reg [31:0] _addr, _data_in;
    reg _load, _store;
    
    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            _addr = 0;
            _data_in = 0;
            _load = 0;
            _store = 0;
            out_RegDest = 0;
            out_MemToReg = 0;
            out_RegWrite = 0;
            out_RegDest = 0;
            out_RegDataSrc = 0;
            out_PCSrc = 0;
            mem_addr = 0;
            mem_write_data = 0;
            mem_write_enable = 0;
        end
        else begin
            // Input signals from execute and control
            _addr = addr;
            _data_in = data_in;
            _load = MemRead;
            _store = MemWrite;

            // Control signals to the next step
            out_RegWrite <= in_RegWrite;
            out_RegDest <= in_RegDest;
            out_RegDataSrc <= in_RegDataSrc;
            out_PCSrc <= in_PCSrc;
        end
    end

    always @(*)
    begin
        mem_done = 0; // Default: memory operation not done
        
        if (_load) // Load operation
        begin
            mem_write_enable = 0;
            mem_addr = _addr;
            // Espera operação de memória terminar
            data_out = mem_read_data;
            mem_done = 1;
            // when dealing with memory delay we need to receive a confirmation from RAM
        end
        
        if (_store) // Store operation
        begin
            mem_write_enable = 1;
            mem_addr = _addr;
            // Espera operação de memória terminar
            mem_write_data = _data_in;
            mem_done = 1;
            // when dealing with memory delay we need to receive a confirmation from RAM
        end

        
    end

endmodule

`endif