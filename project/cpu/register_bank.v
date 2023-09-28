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
  output reg [5:0] led,
  output reg [31:0] value1,
  output reg [31:0] value2
);
initial
  led[5:0] = 0;


  reg [31:0] register [31:1];

  integer i;
  
  always @(posedge reset)
  begin
    for (i = 1; i < 32; i = i + 1)
      register[i] <= 0;
    value1 <= 0;
    value2 <= 0;
  end

  always @(posedge clk) begin
    if (write_enable) begin
      led[5:0] <= 6'b111111;
      if (write_address) begin
        register[write_address] <= write_value;
        led[5:0] <= write_value;
      end
    end
  end


  always @(negedge clk)
  begin
    if (read_address1 == 32'b0)
      value1 <= 0;
    else
      value1 <= register[read_address1];
    if (read_address2 == 0)
      value2 <= 0;
    else
      value2 <= register[read_address2];
  end

endmodule
`endif