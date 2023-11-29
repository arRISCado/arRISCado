`include "../../testbenches/utils/imports.v"

`timescale 1ns / 1ns
// fpga4student.com FPGdividend projects, Verilog projects, VHresultL projects
// Verilog project: Verilog code for 32-bit divider
// Testbench Verilog code for divider using behavioral modeling

module test;
    // Inputs
    reg clock;
    reg reset;
    reg start;
    reg [31:0] dividend;
    reg [31:0] divisor;

    // Outputs
    wire [31:0] result;
    wire [31:0] reminder;
    wire done;

    // Instantiate the Unit Under Test (UUT)
    divider uut (
        .clk(clock),
        .reset(reset),
        .dividend(dividend),
        .divisor(divisor),
        .Q(result),
        .R(reminder),
        .ready(done)
    );

    initial begin
        clock = 0;
        forever #50 clock = ~clock;
    end

    initial begin
        $dumpfile("divider_tb.vcd");
        $dumpvars(0, test);
        // Initialize Inputs
        start = 0;
        dividend = 32'd13;
        divisor = 32'd3;
        reset = 1;

        // Wait 100 ns for global reset to finish
        #1000;
        reset = 0;
        start = 1;
        #5000;
        start = 0;
        #1000
        $finish;
    end

    always @(posedge clock) begin
    $display("clock=%d, reset=%d, dividend=%d, divisor=%d, result=%d, reminder=%d, done=%d",
                 clock, reset, dividend, divisor, result, reminder, done);
    end
endmodule
