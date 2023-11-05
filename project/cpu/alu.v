`ifndef ALU
`define ALU

// Arithmetic Logic Unit

module alu (
  input [3:0] AluControl,
  input [31:0] a,
  input [31:0] b,
  output reg [31:0] result,
  output reg zero
);

  localparam BITWISE_AND = 4'b0000;
  localparam BITWISE_OR  = 4'b0001;
  localparam ADDITION    = 4'b0010;
  localparam BITWISE_XOR = 4'b0011;
  localparam SUBTRACTION = 4'b0110;
  localparam BITWISE_NOT = 4'b0101;
  localparam SHIFT_LEFT  = 4'b1111;
  localparam SHIFT_RIGHT = 4'b0111;
  localparam ARIT_SRIGHT = 4'b1000;

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

`endif