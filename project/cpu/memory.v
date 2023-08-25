module memory (
    input clk,             // Clock signal
    input [31:0] addr,     // Address input
    input [31:0] data_in,  // Data input to be written
    input mem_write,       // Write enable signal
    input mem_read,        // Read enable signal
    input load_store,      // Load/store instruction signal
    input [1:0] op,        // Operation type (00: Load, 01: Store)
    output reg [31:0] data_out, // Data output read from memory
    output mem_done        // Memory operation done signal
);

    reg [31:0] mem[0:1023]; // Example memory with 1024 locations, each storing a 32-bit word

    reg mem_done_reg;
    
    always @(posedge clk) begin
        if (mem_write) // Write data to memory
            mem[addr[9:2]] <= data_in;
        
        if (mem_read) // Read data from memory
            data_out <= mem[addr[9:2]];
        
        mem_done_reg <= 0; // Default: memory operation not done
        
        if (load_store && (op == 2'b00)) begin // Load operation
            data_out <= mem[addr[9:2]];
            mem_done_reg <= 1; // Memory operation is done
        end
        
        if (load_store && (op == 2'b01)) begin // Store operation
            mem[addr[9:2]] <= data_in;
            mem_done_reg <= 1; // Memory operation is done
        end
    end
    
    assign mem_done = mem_done_reg;

endmodule
