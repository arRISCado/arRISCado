// Arithmetic Logic Unit

module alu (
  input [3:0] opcode,
  input [31:0] a,
  input [31:0] b,
  output [31:0] result,
  output zero
);
  wire [31:0] add_result;
  wire [31:0] sub_result;
  wire [31:0] and_result;

  assign add_result = A + B;
  assign sub_result = A - B;
  assign and_result = A & B;

  always @(*)
  begin
    case (op)
      2'b00: result = add_result; // Addition
      2'b01: result = sub_result; // Subtraction
      2'b10: result = and_result; // Bitwise AND
      // Bitwise OR
      // Bitwise XOR
      // Bitwise NOT
      // Shift Left
      // Shift Right
      // Arithmetic Shift Right
      default: result = 8'b0; // Default output
    endcase

    zero = (result == 8'b0);
  end

endmodule
