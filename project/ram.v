// FROM https://learn.lushaylabs.com/tang-nano-9k-sharing-resources/

`ifndef RAM
`define RAM

module ram (
    input clk,
    input reset,
    input [31:0] address,
    input [31:0] data_in,
    input write_enable,
    output reg [31:0] data_out
);
    reg _write_enable = 0;
    reg [31:0] _address = 0;
    // Array of 32 bit registers to represent memory cells
    reg [31:0] storage [255:0];

    integer i;
    initial
        for (i = 0; i < 256; i = i + 1)
            storage[i] = 0;

    always @(posedge reset)
        for (i = 0; i < 256; i = i + 1)
            storage[i] = 0;

    always @(posedge clk)
    begin
        if(addr[31:29] == 3'b000) begin

            if (write_enable)
                storage[address] = data_in; // Write data to the selected memory location

            data_out = storage[address]; // Read data from the selected memory location
        end

        _write_enable = write_enable;
        _address = address;
    end

    always @(*)
    begin
        if (_write_enable)
            storage[_address] = data_in;
    end

    assign data_out = storage[_address]; // Read data from the selected memory location

endmodule

`endif