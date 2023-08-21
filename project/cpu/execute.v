`include "alu.v"

// Execute Stage
module execute (
    input [3:0] op, //sinal de controle sobre qual operação será feita
    input [1:0] op_type, // sinal de controle sobre o tipo de operação(R, I, U, B)
    input [7:0] rd,
    input [7:0] rs1,
    input [7:0] rs2,
    input [31:0] imm,
    output [31:0] result
);

wire [31:0] alu_result;
wire [3:0] alu_op; //talvez n prescise

Alu alu(op, a, b, alu_result); 

    always @(*)
    begin
        case(op_type)
        // exemplo hipotetico: op_type 000 são operações do tipo R
        3'b000 :
        begin
            alu(op, rs1, rs2, alu_result);
            //como que passa o RD pra escrever no banco de REGs dps?
        end

        // Tipo I
        3'b001 :
        begin
            alu(op, rs1, imm, alu_result);
            //como que passa o RD pra escrever no banco de REGs dps?
        end

        // Tipo S
        3'b010:
        begin
            alu(op, rs1, rs2, alu_result);
            //tem imeidato nessa tbm, mas n sei onde colocar
        end

        // Tipo B
        3'b011:
        begin
            alu(op, rs1, rs2, alu_result);
            //tem imediato, mas n sei onde colocar
        end

        // Tipo U
        3'b100:
        begin
            alu(op, rd, imm, alu_result);
            // nessa só tem rd e immediato, entao n sei como se encaixa nesse caso
        end

        // Tipo J
        3'b101:
        begin
            alu(op, rd, imm, alu_result);
            //isso pula pra um endereço X, então acho q o mais certo é usar o PC pra fazer os cálculos
        end
        endcase

    // nao acho q tudo tenha resultado a ser passado adiante
    result <= alu_result;
    
    end
    
endmodule