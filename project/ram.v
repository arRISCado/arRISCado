// INSPIRED BY https://learn.lushaylabs.com/tang-nano-9k-sharing-resources/

`ifndef RAM
`define RAM

module ram (
    input clk,
    input reset,
    input [31:0] address,
    input [31:0] data_in,
    input write_enable,
    output [5:0] led,
    output reg [31:0] data_out
);
    reg [31:0] storage [255:0];

    assign led = {clk, address[4:0]};

    integer i;
    initial
    begin
        for (i = 0; i <= 255; i = i + 1)
            storage[i] <= 0;
        
        data_out <= 0;
    end

    always @(posedge reset)
    begin
        for (i = 0; i <= 255; i = i + 1)
            storage[i] <= 0;

        data_out <= 0;
    end

    always @(posedge clk)
    begin
        if(address[31:29] == 3'b000) begin
            data_out <= 0;

            if (write_enable)
                storage[address] <= data_in;
            
            if (address <= 255)
                data_out <= storage[address];
        end
    end

endmodule
`endif
