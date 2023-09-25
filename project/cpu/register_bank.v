`ifndef REGISTER_BANK
`define REGISTER_BANK

// Register Bank
module register_bank(
  input clk,
  input reset,
  input write_enable,
  input [4:0] write_address,
  input [31:0] write_value,
  input [4:0] read_address1,
  input [4:0] read_address2,
  output reg [31:0] value1,
  output reg [31:0] value2
);

  reg [31:0] register [31:1];

  integer i;
  
  always @(posedge clk or posedge reset)
  begin
    if (reset)
      for (i = 1; i < 32; i = i + 1)
      register[i] = 0;
    else
      // Write to memory
      if (write_enable)
        if (write_address)
          register[write_address] = write_value;
  end

  always @(*)
  begin
    if (read_address1 == 32'b0)
      value1 = 0;
    else
      value1 = register[read_address1];
    if (read_address2 == 0)
      value2 = 0;
    else
      value2 = register[read_address2];
  end

endmodule
`endif