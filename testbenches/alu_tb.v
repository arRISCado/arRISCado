`include "../../testbenches/utils/imports.v"

module test;
    // Outputs
    reg [3:0] AluControl;
    reg [31:0] a;
    reg [31:0] b;
    output [31:0] result;
    output zero;
    output negative;

    alu alu(AluControl, a, b, result, negative, zero);

    // Testbench procedure
    initial begin
        $display("Test Case 1: Testing Display");
        #10;
        
        $display("Test Case 2: AND ");
        AluControl = 4'b0000;
        a = 32'b1100;
        b = 32'b1010;
        #10;
        $display("a: %b, b: %b, result: %b, negative: %b, zero: %b", a, b, result, negative, zero);
        

        $display("Test Case 3: OR");
        AluControl = 4'b0001;
        a = 32'b1100;
        b = 32'b1010;
        #10;
        $display("a: %b, b: %b, result: %b, negative: %b, zero: %b", a, b, result, negative, zero);
        
        $display("Test Case 4: ADD/ADDI");
        AluControl = 4'b0010;
        a = 32'b0110;
        b = 32'b1101;
        #10;
        $display("a: %b, b: %b, result: %b, negative: %b, zero: %b", a, b, result, negative, zero);
        
        $display("Test Case 5: XOR");
        AluControl = 4'b0011;
        a = 32'b1100;
        b = 32'b1010;
        #10;
        $display("a: %b, b: %b, result: %b, negative: %b, zero: %b", a, b, result, negative, zero);

        $display("Test Case 6: SUB");
        AluControl = 4'b0110;
        a = 32'b0101;
        b = 32'b0110;
        #10;
        $display("a: %b, b: %b, result: %b, negative: %b, zero: %b", a, b, result, negative, zero);

        $display("Test Case 7: NOT");
        AluControl = 4'b0101;
        a = 32'b0101;
        b = 32'b0;
        #10;
        $display("a: %b, b: %b, result: %b, negative: %b, zero: %b", a, b, result, negative, zero);

        $display("Test Case 8: Shift Left");
        AluControl = 4'b1111;
        a = 32'b10000000000000000000000000000101;
        b = 32'b0001;
        #10;
        $display("a: %b, b: %b, result: %b, negative: %b, zero: %b", a, b, result, negative, zero);

        $display("Test Case 9: Shift Right");
        AluControl = 4'b0111;
        a = 32'b11000000000000000000000000000101;
        b = 32'b0001;
        #10;
        $display("a: %b, b: %b, result: %b, negative: %b, zero: %b", a, b, result, negative, zero);

        $display("Test Case 10: Arithmetic Shift Left");
        AluControl = 4'b1010;
        a = 32'b10000000000000000000000000000101;
        b = 32'b0001;
        #10;
        $display("a: %b, b: %b, result: %b, negative: %b, zero: %b", a, b, result, negative, zero);

        $display("Test Case 11: Arithmetic Shift Right");
        AluControl = 4'b1000;
        a = 32'b11000000000000000000000000000101;
        b = 32'b0001;
        #10;
        $display("a: %b, b: %b, result: %b, negative: %b, zero: %b", a, b, result, negative, zero);
        $finish;
    end

endmodule
