// INSPIRED BY https://learn.lushaylabs.com/tang-nano-9k-sharing-resources/

`ifndef RAM
`define RAM

module ram (
    input clk,
    input reset,
    input [31:0] address,
    input [31:0] data_in,
    input write_enable,
    // output [5:0] led,
    output [31:0] data_out
);
    reg [7:0] storage [255:0];

    // assign led = {address[5:0]};

    assign data_out[7:0] = storage[address];
    assign data_out[15:8] = storage[address+1];
    assign data_out[23:16] = storage[address+2];
    assign data_out[31:24] = storage[address+3];

    /*assign data_out[31:24] = storage[address];
    assign data_out[23:16] = storage[address+1];
    assign data_out[15:8] = storage[address+2];
    assign data_out[7:0] = storage[address+3];*/

    integer i;
    initial
        for (i = 0; i <= 255; i = i + 1)
            storage[i] <= 0;

    always @(posedge clk)
    begin
        if (write_enable)
            storage[address] <= data_in;

    end

endmodule
`endif