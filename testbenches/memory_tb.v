`include "../../testbenches/utils/imports.v"

module test;

    // Define constants

    // inputs
    reg clock = 0; // Initialize clock to 0
    reg reset = 0;
    reg [31:0] addr;
    reg [31:0] data_in;

    // from RAM signal
    wire [31:0] mem_read_data;

    // control signals
    reg MemRead;          // load command signal
    reg MemWrite;         // store command signal

    // outputs
    wire [31:0] data_out;
    wire mem_done;

    // to RAM signals
    wire [31:0] mem_addr;
    wire [31:0] mem_write_data;
    wire mem_write_enable;

    // Instantiate the RAM module
    ram ram_test(
        .clk(clock), 
        .reset(reset),
        .address(mem_addr), // Correct the signal name
        .data_in(mem_write_data), // Correct the signal name
        .write_enable(mem_write_enable), // Correct the signal name
        .data_out(mem_read_data) // Correct the signal name
    );

    // Instantiate the memory module
    memory memory_test (
        // inputs
        .clk(clock),
        .rst(reset),
        .addr(addr),
        .data_in(data_in),

        // from RAM signal
        .mem_read_data(mem_read_data),

        // control inputs
        .MemRead(MemRead),
        .MemWrite(MemWrite),

        // output
        .data_out(data_out),
        .mem_done(mem_done),

        // to RAM signals
        .mem_addr(mem_addr),
        .mem_write_data(mem_write_data),
        .mem_write_enable(mem_write_enable)
    );

    // Clock generation
    always begin
        #20 clock = ~clock;
    end

    // Initialize signals
    initial begin
        $display("Test Case 1: Store operation, no reset");
        reset = 0;
        addr = 32'b0010;
        data_in = 32'h1234_5678;
        MemRead = 0;
        MemWrite = 1;
        #100; // Wait for simulation to settle

        // Check if the memory operation is done
        if (mem_done !== 1) begin
            $display("ERROR: mem_done is not the desired value, expected: 1");
        end
        else begin
            $display("mem_done correct");
        end

        if (mem_addr !== addr) begin
            $display("ERROR: mem_addr is not the desired value, expected: %0d, result: %0d", addr, mem_addr);
        end
        else begin
            $display("mem_addr correct");
        end
        if (mem_write_data !== data_in) begin
            $display("ERROR: mem_write_data is not the desired value, expected: %0d, result: %0d", data_in, mem_write_data);
        end
        else begin
            $display("mem_write_data correct");
        end
        if (mem_write_enable !== 1) begin
            $display("ERROR: mem_write_enable is not the desired value (expected 1), result: %0d", mem_write_data);
        end
        else begin
            $display("mem_write_enable correct");
        end

        $display("\nTest Case 2: Load operation, no reset");
        reset = 0;
        addr = 32'b0010;
        data_in = 32'h1234_5678;
        MemRead = 1;
        MemWrite = 0;
        #100; // Wait for simulation to settle

        // Check if the memory operation is done
        if (mem_done !== 1) begin
            $display("ERROR: mem_done is not the desired value, expected: 1, result: %0d", mem_done);
        end
        else begin
            $display("mem_done correct");
        end
        if (mem_addr !== addr) begin
            $display("ERROR: mem_addr is not the desired value, expected: %0d, result: %0d", addr, mem_addr);
        end
        else begin
            $display("mem_addr correct");
        end
        if (data_out !== data_in) begin
            $display("ERROR: data_out is not the desired value, expected: %0d, result: %0d", data_in, data_out);
        end
        else begin
            $display("mem_write_data correct");
        end
        if (mem_write_enable !== 0) begin
            $display("ERROR: mem_write_enable is not the desired value, expected: %0d, result: %0d", 0, mem_write_enable);
        end
        else begin
            $display("mem_write_enable correct");
        end

        $display("\nTest Case 3: Store operation, but reset is called");
        reset = 1;
        addr = 32'b0010;
        data_in = 32'h1234_5678;
        MemRead = 0;
        MemWrite = 1;
        #100; // Wait for simulation to settle

        // Check if the memory operation is done
        if (mem_done !== 0) begin
            $display("ERROR: mem_done is not the desired value, expected: 0, result: %0d", mem_done);
        end
        else begin
            $display("mem_done correct");
        end

        // Finish simulation
        $finish;
    end

endmodule
