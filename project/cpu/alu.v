// Arithmetic Logic Unit

module alu (
  input [3:0] AluControl,
  input [31:0] a,
  input [31:0] b,
  output [31:0] result,
  output zero
);
  wire [31:0] add_result;
  wire [31:0] sub_result;
  wire [31:0] and_result;

  assign add_result = a + b;
  assign sub_result = a - b;
  assign and_result = a & b;

  always @(*)
  begin
    case (AluControl)
      4'b0000: result = a&b; // Bitwise AND
      4'b0001: result = a|b; // Bitwise OR
      4'b0010: result = a+b; // Addition
      4'b0011: result = a^b; // Bitwise XOR
      4'b0100: result = a-b; // Subtraction
      4'b0101: result = ~a; // Bitwise NOT
      4'b0110: result = a<<b; // Shift Left
      4'b0111: result = a>>b; // Shift Right
      4'b1000: result = a>>>b; // Arithmetic Shift Right
      default: result = 32'b0; // Default output
    endcase

    zero = (result == 32'b0);
  end

endmodule
