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
    .enable(1'b1),
    .rom_data(rom_data),
    .rom_address(rom_address)
  );

  wire [31:0] rom_data;
  wire [7:0] rom_address;

  rom rom(
    .address(rom_address),
    .data(rom_data)
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
    
    $monitor("%h %d %d", cpu.Fetch.pc, cpu.Execute.alu.a, cpu.Execute.alu.b);
    #600;

    // $monitor("%h %h %h %h", cpu.Fetch.pc, cpu.Memory._load, cpu.Memory.mem_done, cpu.Writeback.mem_done);

    #600;

    $display("RAM");
    for (i = 0; i < 5; i++)
      $display("%d: %h", i, cpu.Ram.storage[i]);
    $display("Registers");
    for (i = 1; i < 31; i++)
      $display("%d: %h", i, cpu.RegisterBank.register[i]);

    $finish;
  end

endmodule
