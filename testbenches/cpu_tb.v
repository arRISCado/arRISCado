`define ROM_FILE "../../testbenches/cpu_tb.txt"
`include "../../testbenches/utils/imports.v"

module test;
  reg clock = 0;
  reg reset = 0;
  
  cpu cpu(clock, reset);

  // Clock generation
  always
    #10 clock = ~clock;

  integer i;

  initial
  begin
    reset = 1;
    #5;
    reset = 0;

    // for (i = 1; i <= 5; i++)
      // $display("%h: %h", i, cpu.RegisterBank.register[i]);
    // $display("%h", cpu.fetch.pc);
    // $monitor("%h %b %h %h", cpu.fetch.pc, cpu.RegisterBank.write_enable, cpu.RegisterBank.write_value, cpu.RegisterBank.write_address);
    // $monitor("%h %h %h %h %h", cpu.fetch.pc, cpu.decode.RegDest, cpu.execute.out_RegDest, cpu.memory.out_RegDest, cpu.writeback.out_RegDest);
    $monitor("%h %h %h %h", cpu.fetch.pc, cpu.execute._RegDest, cpu.execute.rs1_value, cpu.execute.imm);

    #600;

    for (i = 1; i <= 5; i++)
      $display("%h: %h", i, cpu.RegisterBank.register[i]);
    $display("%d", cpu.fetch.pc);

    $finish;
  end

endmodule
