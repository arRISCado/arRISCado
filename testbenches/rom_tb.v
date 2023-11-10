`include "../../testbenches/utils/imports.v"

module test;
    // Outputs
    wire [31:0] rom_data;
    reg [31:0] rom_address;

    rom rom(
        .address(rom_address),
        .data(rom_data)
    );

    integer i;

    // Testbench procedure
    initial begin

        for (i = 0; i < 6; i = i + 1)
        begin
            $display("Test Case %0d: mem[%0d]", i+1, i);
            rom_address = i;
            #10;
            $display("Addr: %h, Data: %h", rom_address, rom_data);
        end

        $finish;
    end

endmodule
