// FROM https://learn.lushaylabs.com/tang-nano-9k-sharing-resources/

module ram (
    input clk,
    input reset,
    input [31:0] address,
    input [31:0] data_in,
    input write_enable,
    output reg [31:0] data_out
);

    // Array of registers to represent memory cells
    reg [255:0] storage [31:0];

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            storage[i] = 0;
        end
    end

    always @(reset)
    begin
        for (i = 0; i < 256; i = i + 1) begin
            storage[i] = 0;
        end
    end

    always @(posedge clk)
    begin
        if(addr[31:29] == 3'b000) begin

            if (write_enable)
                storage[address] = data_in; // Write data to the selected memory location

            data_out = storage[address]; // Read data from the selected memory location
        end
    end

endmodule
