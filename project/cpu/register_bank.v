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

    reg [31:0] register [31:1]
    // TODO: Add other registers (PC, SP etc)

    always @(posedge clk)
    begin
        // Write to memory
        if (write_enable) begin
            if (write_address) begin
                register[write_address] = write value;
            end
        end

        // Update outputs
        if (rst) begin
            register <= 32'b0;
        end
        else begin
            if (read_address1 = 0) begin
                value1 <= 32'b0;
            end
            else begin
                value1 <= register[read_address1];
            end
            if (read_address2 = 0) begin
                value1 <= 32'b0;
            end
            else begin
                value1 <= register[read_address2];
            end
        end
    end

endmodule