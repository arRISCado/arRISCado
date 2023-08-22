// Register Bank
module register_bank(
    input clk,
    input reset,
    input write_enable,
    input [31:0] write_address,
    input [31:0] write_value,
    input [31:0] read_address1,
    input [31:0] read_address2,
    output [31:0] value1,
    output [31:0] value2,
);

    reg [31:0] register [31:1];
    // TODO: Add other registers (PC, SP etc)

    integer i;
    
    always @(posedge clk)
    begin
        // Write to memory
        if (write_enable)
            if (write_address)
                register[write_address] = write_value;

        // Update outputs
        if (rst)
            for (i = 1; i < 32; i = i + 1)
                register[i] = 0;
        else begin
            if (read_address1 == 32'b0)
                value1 <= 32'b0;
            else
                value1 <= register[read_address1];
            if (read_address2 == 0)
                value1 <= 32'b0;
            else
                value1 <= register[read_address2];
        end
    end

endmodule