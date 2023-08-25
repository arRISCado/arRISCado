module memory_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in time units
    
    // Inputs
    reg clk;
    reg [31:0] addr;
    reg [31:0] data_in;
    reg mem_write;
    reg mem_read;
    reg load_store;
    reg [1:0] op;

    // Outputs
    wire [31:0] data_out;
    wire mem_done;

    // Instantiate the memory module
    memory mem_inst (
        .clk(clk),
        .addr(addr),
        .data_in(data_in),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .load_store(load_store),
        .op(op),
        .data_out(data_out),
        .mem_done(mem_done)
    );

    // Clock generation
    always #((CLK_PERIOD)/2) clk = ~clk;

    // Test stimulus
    initial begin
        clk = 0;
        addr = 10;
        data_in = 32'hA5A5A5A5;
        mem_write = 1;
        mem_read = 0;
        load_store = 0;
        op = 2'b00;
        
        #5; // Wait for a few clock cycles
        
        // Perform a write operation
        addr = 5;
        data_in = 32'h12345678;
        mem_write = 1;
        mem_read = 0;
        load_store = 1;
        op = 2'b01;
        #5;
        
        // Perform a read operation
        addr = 5;
        mem_write = 0;
        mem_read = 1;
        #5;
        
        // Perform a load operation
        addr = 15;
        load_store = 1;
        op = 2'b00;
        #5;
        
        // Display the results
        $display("Data read from memory: %h", data_out);
        $display("Memory operation done: %b", mem_done);
        
        $finish; // End the simulation
    end

endmodule
