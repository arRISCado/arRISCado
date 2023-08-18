module DataMemory(address, write_data, read_data, mem_write, mem_read,
    mem_addr, mem_w_data, mem_r_data, mem_w_enable, mem_r_enable);
    
    input [31:0] address, write_data;
    output read_data;
    input mem_write;
    input mem_read;

    output [31:0] mem_addr;
    output [31:0] mem_w_data;
    input  [31:0] mem_r_data;
    output mem_w_enable;
    output mem_r_enable;

endmodule