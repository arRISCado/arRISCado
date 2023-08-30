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
    input [31:0] PC,
    output [31:0] result,

    // Sinais de controle
    input [2:0] AluOp, // Define os operandos a e b
    input AluSrc, // Define se b é rs2 ou imediato
    input [7:0] rd            // Destination register
);

    wire [31:0] alu_result;
    wire [3:0] alu_op; //talvez n prescise

    reg [31:0] a;
    reg [31:0] b;

    alu alu(AluSrc, a, b, alu_result); 

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
        case(AluOp)
        // Tipo Load ou Store
        3'b000 :
        begin
            a = rs1_value;
            b = imm;
        end

        // Tipo B
        3'b001 :
        begin
            a = rs1_value;
            b = rs2_value;
            //como que passa o RD pra escrever no banco de REGs dps?
        end

        // Tipo R OU I
        3'b010 :
        begin
            a = rs1_value;
            case(AluSrc)
            1'b1 :
            begin
                b = imm;
            end
            1'b0 :
            begin
                b = rs2_value;
            end
            endcase
        end

        // Tipo U LUI
        3'b100:
        begin
            a = rd;
            b = imm;
            // é Literalmente isso o LUI, coloca isso no rd direto
        end

        // Tipo U AUIPC
        3'b101:
        begin
            a = PC;
            b = imm;
            // é Literalmente isso o AIUPC, coloca isso no PC direto
        end

        // Tipo J
        3'b011:
        begin
            a = PC;
            b = imm;
            //isso pula pra um endereço X, então acho q o mais certo é usar o PC pra fazer os cálculos
        end

        3'b111 :
        begin
            a = PC;
            b = 3'b100;
            // rd recebe Pc + 4
            PC = rs1_value + imm; //dá pra fazer isso aqui?
            // Sets PC = Reg[rs1] + immediate COMO????
        end
    endcase

end

    assign result = alu_result;
    
endmodule