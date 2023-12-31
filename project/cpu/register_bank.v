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
  output [5:0] debug_led,
  output [31:0] value1,
  output [31:0] value2
);
  // TODO: We should take the ram_style out when we can use the LEDs as a peripheral, 
  // because we can't connect the leds to the register if it is synthesized as ram
  // Also, the read should be synchronous, so we might need to change the execute 
  // stage to account for that.
  // (* ram_style = "logic" *) reg [31:0] register [31:0];
  reg [31:0] register [31:0];

  integer i;
  initial
    for (i = 0; i < 32; i = i + 1)
      register[i] <= 0;

  always @(posedge clk)
    if (write_enable == 1)
      if (write_address != 0)
        register[write_address] <= write_value;

  assign value1 = (write_enable && write_address == read_address1 && write_address != 0) ? write_value : register[read_address1];
  assign value2 = (write_enable && write_address == read_address2 && write_address != 0) ? write_value : register[read_address2];

  assign debug_led[0] = (register[5] == 5) ? 0 : 1;
  assign debug_led[1] = (register[6] == 10) ? 0 : 1;
  assign debug_led[2] = (register[10] == 536870912) ? 0 : 1;
  assign debug_led[3] = (register[11] == 536870913) ? 0 : 1;
  assign debug_led[4] = (write_address == 11) ? 0 : 1;
  assign debug_led[5] = (write_address == 10) ? 0 : 1;
  //assign debug_led[5] = (write_value == 536870912) ? 0 : 1;


endmodule
`endif
