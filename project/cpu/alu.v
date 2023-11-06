`ifndef ALU
`define ALU

// Arithmetic Logic Unit

module alu (
  input [4:0] AluControl,
  input [31:0] a,
  input [31:0] b,
  output reg [31:0] result,
  output reg zero
);

  localparam BITWISE_AND    = 5'b00000;
  localparam BITWISE_OR     = 5'b00001;
  localparam ADDITION       = 5'b00010;
  localparam BITWISE_XOR    = 5'b00011;
  localparam SUBTRACTION    = 5'b00100;
  localparam BITWISE_NOT    = 5'b00101;
  localparam SHIFT_LEFT     = 5'b00110;
  localparam SHIFT_RIGHT    = 5'b00111;
  localparam ARIT_SRIGHT    = 5'b01000;
  localparam SET_LESS       = 5'b01001;
  localparam SET_LESS_U     = 5'b01010;
  localparam MUL_SGN_SGN    = 5'b01011;
  localparam MUL_HIGH       = 5'b01100;
  localparam MUL_SGN_USGN   = 5'b01101;
  localparam MUL_USGN_USGN  = 5'b01110;
  localparam DIV_SGN        = 5'b01111;
  localparam MUL_USGN       = 5'b10000;
  localparam REM_SGN        = 5'b10001;
  localparam REM_USGN       = 5'b10010;


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
      SET_LESS:
      begin
        if (a < b)
        result = 1;
        else
        result = 0;
      end
      SET_LESS_U:
      begin
        if (u_a < u_b)
        result = 1;
        else
        result = 0;
      end
      MUL_SGN_SGN: result = a * b;
      MUL_HIGH: result = a * b;
      MUL_SGN_USGN: result = a * u_b;
      MUL_USGN_USGN: result = u_a * u_b;
      DIV_SGN: result = a / b;
      MUL_USGN: result = u_a / u_b;
      REM_SGN: result = a % b;
      REM_USGN: result = u_a % u_b;
      SUB_USN: {result, borrow} = u_a - u_b;

      default: result = 32'b0; // Default output
    endcase

    zero = (result == 32'b0);
  end

endmodule

`endif