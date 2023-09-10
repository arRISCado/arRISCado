module writeback (
    input clk,                  // Clock signal
    input rst,                  // Reset signal
    input mem_done,             // Memory operation done signal from the memory stage
    input [31:0] data_mem,      // Data read from memory
    input [31:0] result_alu,    // Result of ALU operation

    // Control Signals
    input MemToReg,
    input RegDataSrc, // sinal para definir se os dados vem da memoria ou da alu
    input in_RegWrite,
    input [4:0] in_RegDest,
    input in_PCSrc,

    output reg rb_write_en,
    output reg [31:0] data_wb,   // Data to be written back

    // Control Signal
    output out_RegWrite,
    output reg [4:0] out_RegDest,
    output reg out_PCSrc
);


    // TODO: Pensar como carregar o dado de entrada
    reg _mem_done, _MemToReg;
    reg [4:0] _rd;
    reg [31:0] _data_mem, _result_alu;

    always @(posedge clk or posedge rst) 
    begin
        if (rst)
        begin
            _mem_done = 0;
            _mem_to_reg_ctrl = 0;
            _data_mem = 0;
            _result_alu = 0;
            _rd = 0;
            out_RegDest = 0;
            rb_write_en = 0;
        end
        else begin
            _mem_done = mem_done;
            _mem_to_reg_ctrl = mem_to_reg_ctrl;
            _data_mem = data_mem;
            _result_alu = result_alu;
            _rd = in_RegDest;
            out_RegDest = 0;
            rb_write_en = 0;

            // Control Signal
            out_RegDest = in_RegDest;
            out_PCSrc = in_PCSrc;
            out_RegWrite = in_RegWrite;
        end
    end

    always @(*)
    begin
        // TODO: There is probably a case when there is nothing to be written to in_RegDest.
        out_RegDest = _rd;
        rb_write_en = 1;
        if (_mem_done && _mem_to_reg_ctrl)
            data_wb = _data_mem;
        else
            data_wb = _result_alu;
    end

endmodule
