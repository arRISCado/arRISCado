module memory_tb;

    // Define constants

    // inputs
    reg clock = 0; // Initialize clock to 0
    reg reset = 0;
    reg [31:0] addr;
    reg [31:0] data_in;
    reg load_store;
    reg [1:0] op;

    // from RAM signal
    wire [31:0] mem_read_data;

    // control signals
    reg MemRead;
    reg MemWrite;
    reg MemToReg;
    reg in_RegWrite;
    reg [4:0] in_RegDest;
    reg in_RegDataSrc;
    reg in_PCSrc;

    // outputs
    wire [31:0] data_out;
    wire mem_done;

    // control outputs
    wire out_RegWrite;
    wire [4:0] out_RegDest;
    wire out_RegDataSrc;
    wire out_PCSrc;

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
        .load_store(load_store),
        .op(op),

        // from RAM signal
        .mem_read_data(mem_read_data),

        // control inputs
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .in_RegWrite(in_RegWrite),
        .in_RegDest(in_RegDest),
        .in_RegDataSrc(in_RegDataSrc),
        .in_PCSrc(in_PCSrc),

        // outputs
        .data_out(data_out),
        .mem_done(mem_done),

        // control outputs
        .out_RegWrite(out_RegWrite),
        .out_RegDest(out_RegDest),
        .out_RegDataSrc(out_RegDataSrc),
        .out_PCSrc(out_PCSrc),

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
        $display("\n\nTest Case 1: Store operation, no reset");
        reset = 0;
        addr = 32'b0010;
        data_in = 32'h1234_5678;
        load_store = 1;
        op = 2'b01; // Store operation
        #100; // Wait for simulation to settle

        // Check if the memory operation is done
        if (mem_done !== 1) begin
            $display("ERROR: mem_done is not the desired value, expected: 1");
        end
        else begin
            $display("mem_done correct");
        end

        if (mem_addr !== addr) begin
            $display("ERROR: mem_addr is not the desired value, expected: %d", addr);
        end
        else begin
            $display("mem_addr correct");
        end
        if (mem_write_data !== data_in) begin
            $display("ERROR: mem_write_data is not the desired value, expected: %d", data_in);
        end
        else begin
            $display("mem_write_data correct");
        end
        if (mem_write_enable !== 1) begin
            $display("ERROR: mem_write_enable is not the desired value (expected 1)");
        end
        else begin
            $display("mem_write_enable correct");
        end



        $display("\n\nTest Case 2: Load operation, no reset");
        reset = 0;
        addr = 32'b0010;
        data_in = 32'h1234_5678;
        load_store = 1;
        op = 2'b00; // Load operation
        #100; // Wait for simulation to settle

        // Check if the memory operation is done
        if (mem_done !== 1) begin
            $display("ERROR: mem_done is not the desired value, expected: 1");
        end
        else begin
            $display("mem_done correct");
        end
        if (mem_addr !== addr) begin
            $display("ERROR: mem_addr is not the desired value, expected: %d", addr);
        end
        else begin
            $display("mem_addr correct");
        end
        if (data_out !== data_in) begin
            $display("ERROR: data_out is not the desired value, expected: %d", data_in);
        end
        else begin
            $display("mem_write_data correct");
        end
        if (mem_write_enable !== 0) begin
            $display("ERROR: mem_write_enable is not the desired value, expected: %d", 0);
        end
        else begin
            $display("mem_write_enable correct");
        end



        $display("\n\nTest Case 3: Store operation, but reset is called");
        reset = 1;
        addr = 32'b0010;
        data_in = 32'h1234_5678;
        load_store = 1;
        op = 2'b01; // Store operation
        #100; // Wait for simulation to settle

        // Check if the memory operation is done
        if (mem_done !== 0) begin
            $display("ERROR: mem_done is not the desired value, expected: 0");
        end
        else begin
            $display("mem_done correct");
        end

        // Finish simulation
        $finish;
    end

endmodule
