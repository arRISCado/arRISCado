`include "alu.v"

// Execute Stage
module execute (
    input clk,                 // Clock signal
    input rst,                 // Reset signal
    input [3:0] op,            // Instruction
    input [1:0] op_type,
    input [31:0] rs1_value,
    input [31:0] rs2_value,
    input [31:0] imm,
    input [7:0] rd,            // Destination register
    
    output [31:0] result
);

    wire [31:0] alu_result;
    wire [3:0] alu_op; //talvez n prescise

    reg [31:0] a;
    reg [31:0] b;

    alu alu(op, a, b, alu_result); 

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            a = 0;
            b = 0;
        end
        else
        begin

        end
    end

    always @(*)
    begin
        case(op_type)
        // exemplo hipotetico: op_type 000 são operações do tipo R
        3'b000 :
        begin
            a = rs1;
            b = rs2;
            //como que passa o RD pra escrever no banco de REGs dps?
        end

        // Tipo I
        3'b001 :
        begin
            a = rs1_value;
            b = imm;
            // alu(op, mem[rs1], imm, alu_result);
            //como que passa o RD pra escrever no banco de REGs dps?
        end

        // Tipo S
        3'b010:
        begin
            // alu(op, rs1, rs2, alu_result);
            //tem imeidato nessa tbm, mas n sei onde colocar
        end

        // Tipo B
        3'b011:
        begin
            // alu(op, rs1, rs2, alu_result);
            //tem imediato, mas n sei onde colocar
        end

        // Tipo U
        3'b100:
        begin
            // alu(op, rd, imm, alu_result);
            // nessa só tem rd e immediato, entao n sei como se encaixa nesse caso
        end

        // Tipo J
        3'b101:
        begin
            // alu(op, rd, imm, alu_result);
            //isso pula pra um endereço X, então acho q o mais certo é usar o PC pra fazer os cálculos
        end
        endcase

end

    assign result = alu_result;
    
endmodule