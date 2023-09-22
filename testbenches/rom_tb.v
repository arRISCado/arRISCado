`include "../../testbenches/utils/imports.v"

module test;
    // Outputs
    wire [31:0] rom_data;
    reg [31:0] rom_address;

    rom rom(
        .address(rom_address),
        .data(rom_data)
    );

    // Testbench procedure
    initial begin
        $display("Test Case 1: mem[0]");
        rom_address = 32'b0;
        #10;
        $display("Addr: %h, Data: %h", rom_address, rom_data);
        
        $display("Test Case 2: mem[1]");
        rom_address = 32'b1;
        #10;
        $display("Addr: %h, Data: %h", rom_address, rom_data);
        
        $display("Test Case 3: mem[2]");
        rom_address = 32'b10;
        #10;
        $display("Addr: %h, Data: %h", rom_address, rom_data);
        
        $display("Test Case 4: mem[3]");
        rom_address = 32'b11;
        #10;
        $display("Addr: %h, Data: %h", rom_address, rom_data);

        $finish;
    end

endmodule
