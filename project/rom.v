` def ROM_FILE
`define ROM_FILE  "../../project/init_rom.txt"
`endif

`ifndef ROM
`define ROM

module rom (
  input [31:0] address,
  output wire [31:0] data
);

  reg [31:0] memory[255:0];

  initial
  begin
    // synthesis translate_off
    $display(`ROM_FILE);
    // synthesis translate_on
    $readmemh(`ROM_FILE, memory, 0, 255);
  end
  
  assign data = (address <= 32'd255) ? memory[address] : 32'bZ;

endmodule

`endif