module Adder(X, Y, carry_in, S);
    parameter n = 1;
    input [n-1, 0] X, Y;
    input carry_in;
    output reg [n-1, 0], S;

    always @(X, Y, carry_in)
        S = X + Y + carry_in;
        
endmodule