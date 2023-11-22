`include "../../testbenches/utils/imports.v"

module test;
    // Outputs
    reg [4:0] AluControl;
    reg [31:0] a;
    reg [31:0] b;
    output [31:0] result;
    output zero;
    output negative;
    output borrow;

    alu alu(AluControl, a, b, result, zero, negative, borrow);

    // Testbench procedure
    initial begin
        $display("Test Case 1: Testing Display");
        #10;
        
        // RV32I Test

        $display("Test Case 2: AND ");
        AluControl = 5'b00000;
        a = 32'b1100;
        b = 32'b1010;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);
        
        $display("Test Case 3: OR");
        AluControl = 5'b00001;
        a = 32'b1100;
        b = 32'b1010;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);
        
        $display("Test Case 4: ADD/ADDI");
        AluControl = 5'b00010;
        a = 32'b0110;
        b = 32'b1101;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);
        
        $display("Test Case 5: XOR");
        AluControl = 5'b00011;
        a = 32'b1100;
        b = 32'b1010;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);

        $display("Test Case 6: SUB");
        AluControl = 5'b00100;
        a = 32'b0101;
        b = 32'b0110;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);

        $display("Test Case 7: NOT");
        AluControl = 5'b00101;
        a = 32'b0101;
        b = 32'b0;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);

        $display("Test Case 8: Shift Left");
        AluControl = 5'b00110;
        a = 32'b10000000000000000000000000000101;
        b = 32'b0001;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);

        $display("Test Case 9: Shift Right");
        AluControl = 5'b00111;
        a = 32'b11000000000000000000000000000101;
        b = 32'b0001;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);

        $display("Test Case 10: Arithmetic Shift Right");
        AluControl = 5'b01000;
        a = 32'b11000000000000000000000000000101;
        b = 32'b0001;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);

        $display("Test Case 11: Set (SLT e SLTI)");
        AluControl = 5'b01001;
        a = 32'b11100000000000000000000000000110;
        b = 32'b0101;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);

        $display("Test Case 12: Set Unsigned (SLTU e SLTIU)");
        AluControl = 5'b01010;
        a = 32'b11100000000000000000000000000110;
        b = 32'b0101;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);

        // RV32M Test

        $display("Test Case 21: MUL");
        AluControl = 5'b01011;
        a = 32'b11111111111111111111111111110100;
        b = 32'b1010;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);

        $display("Test Case 22: MULH");
        AluControl = 5'b01100;
        a = 32'b11111111111111111111111111110100;
        b = 32'b1010;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);
        
        $display("Test Case 23: MULHSU");
        AluControl = 5'b01101;
        a = 32'b11111111111111111111111111110100;
        b = 32'b1010;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);
        
        $display("Test Case 24: MULHU");
        AluControl = 5'b01110;
        a = 32'b11111111111111111111111111110100;
        b = 32'b1010;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);

        $display("Test Case 25: DIV");
        AluControl = 5'b01111;
        a = 32'b1101;
        b = 32'b0011;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);

        $display("Test Case 26: DIVU");
        AluControl = 5'b10000;
        a = 32'b1101;
        b = 32'b0011;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);

        $display("Test Case 27: REM");
        AluControl = 5'b10001;
        a = 32'b1101;
        b = 32'b0011;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);

        $display("Test Case 28: REMU");
        AluControl = 5'b10010;
        a = 32'b1101;
        b = 32'b0011;
        #10;
        $display("a: %b, b: %b, result: %b, zero: %b, negative: %b, barrow: %b", a, b, result, zero, negative, borrow);
        $finish;
    end

endmodule
