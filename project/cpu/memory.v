module memory (
    input clk,             // Clock signal
    input rst,             // Reset signal
    input [31:0] addr,     // Address input
    input [31:0] data_in,  // Data input to be written
    input load_store,      // Load/store instruction signal
    input [1:0] op,        // Operation type (00: Load, 01: Store)
    input [31:0] mem_read_data,

    // Control Signals
    input MemRead,
    input MemWrite,
    input MemToReg,
    input in_RegWrite,
    input [4:0] in_RegDest,
    input in_RegDataSrc,
    input in_PCSrc,

    output reg [31:0] mem_addr,
    output reg [31:0] mem_write_data,
    output reg mem_write_enable,
    output [31:0] data_out,    // Data output read from memory
    output reg mem_done,       // Memory operation done signal

    // Control Signals
    output reg out_RegWrite,
    output reg [4:0] out_RegDest,
    output reg out_RegDataSrc,
    output reg out_PCSrc
);
    reg [31:0] _addr, _data_in;
    reg _mem_write, _mem_read, _load_store;
    reg [1:0] _op;
    
    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            _addr = 0;
            _data_in = 0;
            _load_store = 0;
            _op = 0;
            out_RegDest = 0;
        end
        else
        begin
            _addr = addr;
            _data_in = data_in;
            _load_store = load_store;
            _op = op;

            // Control Signals
            out_RegWrite = in_RegWrite;
            out_RegDest = in_RegDest;
            out_RegDataSrc = in_RegDataSrc;
            out_PCSrc = in_PCSrc;
        end
    end

    always @(*)
    begin
        mem_done = 0; // Default: memory operation not done
        
        if (_load_store && (_op == 2'b00)) // Load operation
        begin
            mem_addr = _addr;
            data_out = mem_read_data;
            mem_done <= 1; // Memory operation is done
        end
        
        if (_load_store && (_op == 2'b01)) // Store operation
        begin
            mem_write_enable = 1;
            mem_addr = _addr;
            mem_write_data = _data_in;
            mem_done <= 1; // Memory operation is done
        end
    end

endmodule
