`define ROM_FILE "../../testbenches/cpu_tb.txt"
`include "../../testbenches/utils/imports.v"
// `timescale 1ps/1ps

module test;
  reg clock = 0;
  reg reset = 0;
  
  cpu cpu(
    .clock(clock), 
    .reset(reset), 
    .enable(1'b1)
  );

  // Clock generation
  always
    #10 clock = ~clock;

  integer i;

  initial
  begin
  $dumpfile("cpu_tb.vcd");
  $dumpvars(0, test);
    reset = 1;
    #5;
    reset = 0;
    
    #600;

    // $monitor("%h %h %h %h", cpu.Fetch.pc, cpu.Memory._load, cpu.Memory.mem_done, cpu.Writeback.mem_done);
    $monitor("%h %h", cpu.Ram.data_out, cpu.Ram.address);

    #400;

    $display("RAM");
    for (i = 0; i < 5; i++)
      $display("%d: %h", i, cpu.Ram.storage[i]);
    $display("Registers");
    for (i = 1; i < 7; i++)
      $display("%d: %h", i, cpu.RegisterBank.register[i]);

    $finish;
  end

endmodule
