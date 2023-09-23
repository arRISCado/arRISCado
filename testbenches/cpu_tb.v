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
    // $monitor("%h", cpu.Ram.storage[0]);
    // $monitor("%h %b %h %h", cpu.Fetch.pc, cpu.Ram.write_enable, cpu.Ram.address, cpu.Ram.data_in);
    // $monitor("%h %b %h %h", cpu.Fetch.pc, cpu.Memory.mem_write_enable, cpu.Memory.mem_addr, cpu.Memory.mem_write_data);
    $monitor("%h %b %h %h", cpu.Fetch.pc, cpu.Memory._load, cpu.Memory.mem_addr, cpu.Memory.mem_read_data);

    #300;

    $display("### Registers ###");
    for (i = 1; i <= 6; i++)
      $display("%h: %h", i, cpu.RegisterBank.register[i]);
    $display("%d", cpu.Fetch.pc);

    $finish;
  end

endmodule
