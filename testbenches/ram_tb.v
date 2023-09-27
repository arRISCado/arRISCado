`define ROM_FILE "../../testbenches/cpu_tb.txt"
`include "../../testbenches/utils/imports.v"

module test;
    // Outputs
    wire [31:0] data_out;
    reg  [31:0] data_in;
    reg  [31:0] address;
    reg write_enable, clk, reset;

    ram ram(
        .clk(clk),
        .reset(reset),
        .address(address),
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    integer i;

    // Testbench procedure
    initial begin
        clk = 0;
        reset = 1;
        #5

        reset = 0;
        #5

        for (i = 0; i < 10; i++)
            $display("%d: %h", i, ram.storage[i]);

        address = 3;
        data_in = 7;
        write_enable = 1;
        #5
        clk = 1;
        #5
        clk = 0;
        $display("Addr: %h, Data: %h", address, data_out);
        #10
        
        write_enable = 0;
        address = 3;
        clk = 1;
        #10
        clk = 0;
        $display("Addr: %h, Data: %h", address, data_out);
        #10
        
        write_enable = 0;
        address = 1;
        clk = 1;
        #10
        clk = 0;
        $display("Addr: %h, Data: %h", address, data_out);
        #10
        
        write_enable = 0;
        address = 3;
        clk = 1;
        #10
        clk = 0;
        $display("Addr: %h, Data: %h", address, data_out);
        #10
        
        write_enable = 0;
        reset = 1;
        address = 0;
        clk = 1;
        #10
        reset = 0;
        clk = 0;
        $display("Addr: %h, Data: %h", address, data_out);
        #10
        
        $finish;
    end

endmodule
