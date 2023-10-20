module rom (
  input [31:0] address,
  output wire [31:0] data
);

  reg [31:0] memory [255:0];

  initial
  begin
    // synthesis translate_off
    $display(`ROM_FILE);
    // synthesis translate_on
    $readmemh(`ROM_FILE, memory, 0, 255);
  end
  
  assign data = (address <= 255) ? memory[address] : 32'b0;

endmodule
