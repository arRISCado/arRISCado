/* TODO: Use this to initialize the Instruction ROM
`ifndef ROM_FILE
`define ROM_FILE "init_rom.txt"
`endif ROM_FILE

$readmemh(`ROM_FILE, memory);
*/

module rom (
  input [31:0] address,
  output wire [31:0] data
);

  reg [31:0] memory[255:0];

  initial
  begin    
    memory[0] = 32'h00100513; // addi a0, zero, 1
    memory[1] = 32'h40a005b3; // sub a1, zero, a0
    memory[2] = 32'h00a50633; // add a2, a0, a0
    memory[3] = 32'h00c60633; // add a2, a2, a2
    memory[4] = 32'h7ff00693; // addi a3, zero, 4095 
    memory[5] = 32'h00b60733; // add a4, a2, a1
    memory[6] = 32'h40e607b3; // sub a5, a2, a4
    memory[7] = 32'h00568813; // addi a6, a3, 5
    memory[8] = 32'h000628b7; // lui a7, 98
    memory[9] = 32'h00000917; // auipc s2, 0
  end

  assign data = (address <= 32'd255) ? memory[address] : 32'bZ;

endmodule
