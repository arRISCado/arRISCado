// INSPIRED BY https://learn.lushaylabs.com/tang-nano-9k-sharing-resources/
`ifndef RAM
`define RAM

module ram (
  input clk,
  input reset,
  input [31:0] address,
  input [31:0] data_in,
  input write_enable,
  output reg [31:0] data_out
);
  reg [31:0] storage [255:0];

  integer i;
  initial
    for (i = 0; i <= 255; i = i + 1)
      storage[i] <= 0;

  always @(posedge clk or posedge reset)
  begin
    if (reset)
      for (i = 0; i <= 255; i = i + 1)
        storage[i] <= 0;
    else
    begin
      if (write_enable)
        storage[{2'b0, address[31:2]}] <= data_in;

      data_out <= storage[{2'b0, address[31:2]}];
    end
  end
endmodule
`endif
