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
  
  // always @(posedge reset)
  // begin
  //   for (i = 1; i < 32; i = i + 1)
  //     register[i] <= 0;
  // end

  initial
    for (i = 1; i < 32; i = i + 1)
      register[i] <= 0;

  always @(posedge clk)
  begin
    if (write_enable)
      if (write_address)
        register[write_address] <= write_value;

    value1 <= (read_address1 == 0) ? 0 : register[read_address1];
    value2 <= (read_address2 == 0) ? 0 : register[read_address2];
  end

  // assign value1 = (read_address1 == 0) ? 0 : register[read_address1];
  // assign value2 = (read_address2 == 0) ? 0 : register[read_address2];

endmodule
`endif