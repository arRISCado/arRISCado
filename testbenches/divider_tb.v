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
    wire err;

    // Instantiate the Unit Under Test (UUT)
    divider uut (
        .clk(clock),
        .start(start),
        .reset(reset),
        .dividend(dividend),
        .divisor(divisor),
        .result(result),
        .reminder(reminder),
        .done(done),
        .err(err)
    );

    initial begin
        clock = 0;
        forever #50 clock = ~clock;
    end

    initial begin
        // Initialize Inputs
        start = 0;
        dividend = 32'd12;
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
        $display("clock=%d, reset=%d, start=%d, dividend=%d, divisor=%d, result=%d, reminder=%d, done=%d, err=%d",
                 clock, reset, start, dividend, divisor, result, reminder, done, err);
    end
endmodule
