module rom (
  input [31:0] address;
  output [31:0] data;
);

  reg [31:0] memory[255:0];

  initial
  begin
    memory[0] = 31'b0;
  end

  always @(address)
  begin
    if (address <= 8'd_255)
      data <= memory[address]
    else
      data <= 32'bZ; // High-impedance
  end

endmodule
