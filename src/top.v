module top(clk);
    input clk;

    wire [31:0] mem_addr;
    wire [31:0] mem_w_data;
    wire [31:0] mem_r_data;
    wire mem_w_enable;
    wire mem_r_enable;

    Processor processor(clk, mem_addr, mem_w_data, mem_r_data, mem_w_enable, mem_r_enable);

    Memory memory(mem_addr, mem_w_data, mem_r_data, mem_w_enable, mem_r_enable);

endmodule