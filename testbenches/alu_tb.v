`include "../../project/cpu/alu.v"

module test;
    // Outputs
    reg [3:0] AluControl;
    reg [31:0] a;
    reg [31:0] b;
    output [31:0] result;

    alu alu(AluControl, a, b, result);

    // Testbench procedure
    initial begin
        $display("Test Case 1: Testing Display");
        #10;
        
        $display("Test Case 2: AND ");
        AluControl = 4'b0000;
        a = 32'b0101;
        b = 32'b0011;
        #10;
        $display("a: %b, b: %b, result: %b", a, b, result);
        

        $display("Test Case 3: OR");
        AluControl = 4'b0001;
        a = 32'b101;
        b = 32'b001;
        #10;
        $display("a: %b, b: %b, result: %b", a, b, result);
        
        $display("Test Case 4: ADD/ADDI");
        AluControl = 4'b0010;
        a = 32'b101;
        b = 32'b010;
        #10;
        $display("a: %b, b: %b, result: %b", a, b, result);
        
        $display("Test Case 5: XOR");
        AluControl = 4'b0011;
        a = 32'b0101;
        b = 32'b0110;
        #10;
        $display("a: %b, b: %b, result: %b", a, b, result);

        $display("Test Case 6: SUB");
        AluControl = 4'b0100;
        a = 32'b0101;
        b = 32'b0110;
        #10;
        $display("a: %b, b: %b, result: %b", a, b, result);

        $display("Test Case 7: NOT");
        AluControl = 4'b0101;
        a = 32'b0101;
        b = 32'b0;
        #10;
        $display("a: %b, b: %b, result: %b", a, b, result);

        $display("Test Case 8: Shift Left");
        AluControl = 4'b0110;
        a = 32'b10000000000000000000000000000101;
        b = 32'b0001;
        #10;
        $display("a: %b, b: %b, result: %b", a, b, result);

        $display("Test Case 9: Shift Right");
        AluControl = 4'b0111;
        a = 32'b11000000000000000000000000000101;
        b = 32'b0001;
        #10;
        $display("a: %b, b: %b, result: %b", a, b, result);
    
        $display("Test Case 10: Arithmetic Shift Right"); //Como isso funciona?
        AluControl = 4'b1000;
        a = 32'b10000000000000000000000000000101;
        b = 32'b0001;
        #10;
        $display("a: %b, b: %b, result: %b", a, b, result);
        $finish;
    end

endmodule
