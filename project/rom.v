module rom (
  input [31:0] address,
  output wire [31:0] data
);

  reg [31:0] memory[255:0];

  initial
  begin    
    memory[0] = 32'h00100513;
    memory[1] = 32'h40a005b3;
    memory[2] = 32'h00a50633;
    memory[3] = 32'h00c60633;
    memory[4] = 32'h7ff00693;
    memory[5] = 32'h00b60733;
    memory[6] = 32'h40e607b3;
    memory[7] = 32'h00568813;
    memory[8] = 32'h000628b7;
    memory[9] = 32'h00000917;
  end

  assign data = (address <= 32'd255) ? memory[address] : 32'bZ;

endmodule
