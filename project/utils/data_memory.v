module DataMemory(address, write_data, read_data, mem_write, mem_read);
    input [31:0] address, write_data;
    output reg [31:0] read_data;
    input mem_write, mem_read;

    reg [31:0] memory [0:1023];

    always @ (mem_write or mem_read) begin
        if (mem_write) begin
            memory[address] <= write_data;
        end
        if (mem_read) begin
            read_data <= memory[address];
        end
    end
endmodule
