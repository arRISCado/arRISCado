`include "../../testbenches/utils/imports.v"

module test;
    // Outputs
    wire [31:0] data_out;
    reg  [31:0] data_in;
    reg  [31:0] address;
    reg write_enable, clk, reset;

    ram ram(
        clk,
        reset,
        address,
        data_in,
        write_enable,
        data_out
    );

    // Testbench procedure
    initial begin
        clk = 0;
        reset = 0;
        #10

        $display("Test Case 1");
        address = 0;
        data_in = 50;
        write_enable = 1;
        clk = 1;
        #10
        clk = 0;
        $display("Addr: %h, Data: %h", address, data_out);
        #10
        
        write_enable = 0;
        address = 0;
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
        address = 0;
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
