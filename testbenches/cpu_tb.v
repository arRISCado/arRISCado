`define ROM_FILE "../../testbenches/if_de_ex_wb_tb.txt"
`include "../../testbenches/utils/imports.v"

module test;
  reg clock;
  reg reset;
  
  cpu cpu(clock, reset);

  // Clock generation
  always
    #10 clock = ~clock;

  initial
  begin
    
    #100

    $finish;
  end

endmodule
