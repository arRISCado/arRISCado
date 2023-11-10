`ifndef ROM_FILE
`define ROM_FILE  "../../project/init_rom.txt"
`endif

module rom (
  input [7:0] address,
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
  
  wire [7:0] next_address = address + 4;
  wire [31:0] data1 = memory[address[7:2]];
  wire [31:0] data2 = memory[next_address[7:2]];

  assign data = address[1:0] == 'b00 ? data1 :
                address[1:0] == 'b01 ? {data2[7:0],  data1[31:8] } :
                address[1:0] == 'b10 ? {data2[15:0], data1[31:16]} :
                                       {data2[23:0], data1[31:24]};
endmodule
