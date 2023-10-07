// Register Bank
module register_bank(
  input clk,
  input reset,
  input write_enable,
  input [4:0] write_address,
  input [31:0] write_value,
  input [4:0] read_address1,
  input [4:0] read_address2,
  output [31:0] value1,
  output [31:0] value2
);

  reg [31:0] register [31:0];

  integer i;
  initial
    for (i = 0; i <= 32; i = i + 1)
      register[i] = 0;

  always @(posedge clk)
    if (write_enable)
      register[write_address] <= write_value;

  assign value1 = read_address1 == 0 ? 0 :
                  ((read_address1 == write_address) && write_enable) ? write_value :
                  read_address1 == 1 ? register[1] :
                  read_address1 == 2 ? register[2] :
                  read_address1 == 3 ? register[3] :
                  read_address1 == 4 ? register[4] :
                  read_address1 == 5 ? register[5] :
                  read_address1 == 6 ? register[6] :
                  read_address1 == 7 ? register[7] :
                  read_address1 == 8 ? register[8] :
                  read_address1 == 9 ? register[9] :
                  read_address1 == 10 ? register[10] :
                  read_address1 == 11 ? register[11] :
                  read_address1 == 12 ? register[12] :
                  read_address1 == 13 ? register[13] :
                  read_address1 == 14 ? register[14] :
                  read_address1 == 15 ? register[15] :
                  read_address1 == 16 ? register[16] :
                  read_address1 == 17 ? register[17] :
                  read_address1 == 18 ? register[18] :
                  read_address1 == 19 ? register[19] :
                  read_address1 == 20 ? register[20] :
                  read_address1 == 21 ? register[21] :
                  read_address1 == 22 ? register[22] :
                  read_address1 == 23 ? register[23] :
                  read_address1 == 24 ? register[24] :
                  read_address1 == 25 ? register[25] :
                  read_address1 == 26 ? register[26] :
                  read_address1 == 27 ? register[27] :
                  read_address1 == 28 ? register[28] :
                  read_address1 == 29 ? register[29] :
                  read_address1 == 30 ? register[30] :
                  read_address1 == 31 ? register[31] : 0;

  assign value2 = read_address2 == 0 ? 0 :
                  ((read_address2 == write_address) && write_enable) ? write_value :
                  read_address2 == 1 ? register[1] :
                  read_address2 == 2 ? register[2] :
                  read_address2 == 3 ? register[3] :
                  read_address2 == 4 ? register[4] :
                  read_address2 == 5 ? register[5] :
                  read_address2 == 6 ? register[6] :
                  read_address2 == 7 ? register[7] :
                  read_address2 == 8 ? register[8] :
                  read_address2 == 9 ? register[9] :
                  read_address2 == 10 ? register[10] :
                  read_address2 == 11 ? register[11] :
                  read_address2 == 12 ? register[12] :
                  read_address2 == 13 ? register[13] :
                  read_address2 == 14 ? register[14] :
                  read_address2 == 15 ? register[15] :
                  read_address2 == 16 ? register[16] :
                  read_address2 == 17 ? register[17] :
                  read_address2 == 18 ? register[18] :
                  read_address2 == 19 ? register[19] :
                  read_address2 == 20 ? register[20] :
                  read_address2 == 21 ? register[21] :
                  read_address2 == 22 ? register[22] :
                  read_address2 == 23 ? register[23] :
                  read_address2 == 24 ? register[24] :
                  read_address2 == 25 ? register[25] :
                  read_address2 == 26 ? register[26] :
                  read_address2 == 27 ? register[27] :
                  read_address2 == 28 ? register[28] :
                  read_address2 == 29 ? register[29] :
                  read_address2 == 30 ? register[30] :
                  read_address2 == 31 ? register[31] : 0;

endmodule