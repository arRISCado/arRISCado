module InstructionMemory(clk, current_pc, next_instr);
    input clk;
    input [31:0] current_pc;
    output reg [31:0] next_instr;

    reg [31:0] memory[0:1023];

    always @ (posedge clk) begin
        next_instr <= memory[current_pc];
    end
endmodule