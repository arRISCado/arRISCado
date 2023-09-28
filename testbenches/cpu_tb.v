// `define ROM_FILE "../../testbenches/cpu_tb.txt"
`define ROM_FILE "../../project/init_rom.txt"
`include "../../testbenches/utils/imports.v"

module test;
  reg clock = 0;
  reg reset = 0;
  wire [5:0] led;

  cpu cpu(
    .clock(clock), 
    .reset(reset), 
    .led(led),
    .enable(1'b1)
  );

  // Clock generation
  always
    #10 clock = ~clock;

  integer i;

  initial
  begin
    reset = 1;
    #5;
    reset = 0;
    
    // Register Bank
    // $monitor("%d %h %h", cpu.Fetch.pc, cpu.Execute.a, cpu.Execute.b);

    // Write Signals
    $monitor("%h %b %h %h", cpu.Fetch.pc, cpu.Ram.write_enable, cpu.Ram.address, cpu.Ram.data_in);

    // Read Signals
    // $monitor("%h %b %h %h", cpu.Fetch.pc, cpu.Writeback._MemToReg, cpu.Writeback.data_mem, cpu.Ram.data_in);

    // $monitor("%h %b %b", cpu.Fetch.pc, cpu.Ram.address[5:0], cpu.Ram.data_out[5:0]);
    // $monitor("%d %h %h", cpu.Fetch.pc, cpu.Execute.a, cpu.Execute.b);

    #600;

    $display("RAM");
    for (i = 0; i < 5; i++)
      $display("%d: %h", i, cpu.Ram.storage[i]);
    $display("Registers");
    for (i = 1; i < 7; i++)
      $display("%d: %h", i, cpu.RegisterBank.register[i]);

    $finish;
  end

endmodule
