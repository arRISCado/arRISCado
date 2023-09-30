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
  output [5:0] led,
  output [31:0] value1,
  output [31:0] value2
);
  reg [31:0] register [31:0];

  integer i;

  initial
  begin
    for (i = 0; i < 32; i = i + 1)
      register[i] <= 0;
  end

  assign led = write_enable;

  always @(posedge clk)
  begin
    if (write_enable == 1)
      if (write_address != 0)
        register[write_address] <= write_value;
  end

  assign value1 = register[read_address1];
  assign value2 = register[read_address2];

endmodule
`endif