// Arithmetic Logic Unit

module alu (
  input [4:0] AluControl,
  input [31:0] a,
  input [31:0] b,
  output reg [31:0] result,
  output reg zero
);

  localparam BITWISE_AND = 5'b00000;
  localparam BITWISE_OR  = 5'b00001;
  localparam ADDITION    = 5'b00010;
  localparam BITWISE_XOR = 5'b00011;
  localparam SUBTRACTION = 5'b00100;
  localparam BITWISE_NOT = 5'b00101;
  localparam SHIFT_LEFT  = 5'b00110;
  localparam SHIFT_RIGHT = 5'b00111;
  localparam ARIT_SRIGHT = 5'b01000;

  always @(*)
  begin
    case (AluControl)
      BITWISE_AND: result = a & b; // Bitwise AND
      BITWISE_OR: result = a | b; // Bitwise OR
      ADDITION: result = a + b; // Addition
      BITWISE_XOR: result = a ^ b; // Bitwise XOR
      SUBTRACTION: result = a - b; // Subtraction
      BITWISE_NOT: result = ~a; // Bitwise NOT
      SHIFT_LEFT: result = a << b; // Shift Left
      SHIFT_RIGHT: result = a >> b; // Shift Right
      ARIT_SRIGHT: result = a >>> b; // Arithmetic Shift Right // TODO: Must be signed
      default: result = 32'b0; // Default output
    endcase

    zero = (result == 32'b0);
  end

endmodule
