`include "alu.v"

// Execute Stage
module execute (
    input clk,                 // Clock signal
    input rst,                 // Reset signal
    
    // input [3:0] op,            // Instruction
    // input [1:0] op_type,
    input [31:0] rs1_value,
    input [31:0] rs2_value,
    input [31:0] imm,
    input [31:0] PC,
    output [31:0] result,

    // Sinais de controle
    input AluSrc,           // Determines if the value comes from the Register Bank or is an IMM
    input [2:0] AluOp,      // Operation type ALU will perform
    input in_MemWrite,         // True or False depending if the operation Writes in the Memory or not
    input in_MemRead,          // True or False depending if the operation Reads from the Memory or not
    input in_RegWrite,         // True or False depending if the operation writes in a Register or not
    input [4:0] in_RegDest,    // Determines which register to write the ALU result
    input [3:0] in_AluControl, // Exact operation ALU will perform
    input in_Branch,           // True or False depending if the instruction is a Branch
    input in_MemToReg,         // True or False depending if the operation writes from the Memory into the Resgister Bank
    input in_RegDataSrc,       // Determines where the register data to be writen will come from: memory or ALU result
    input in_PCSrc,            // Determines if the PC will come from the PC+4 or from a Branch calculation

    output out_MemWrite,         // True or False depending if the operation Writes in the Memory or not
    output out_MemRead,          // True or False depending if the operation Reads from the Memory or not
    output out_RegWrite,         // True or False depending if the operation writes in a Register or not
    output [4:0] out_RegDest,    // Determines which register to write the ALU result
    output [3:0] out_AluControl, // Exact operation ALU will perform
    output out_Branch,           // True or False depending if the instruction is a Branch
    output out_MemToReg,         // True or False depending if the operation writes from the Memory into the Resgister Bank
    output out_RegDataSrc,       // Determines where the register data to be writen will come from: memory or ALU result
    output out_PCSrc             // Determines if the PC will come from the PC+4 or from a Branch calculation

    output [31:0] result
);

    reg [31:0] a;
    reg [31:0] b;

    alu alu(AluSrc, a, b, result); 

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
    
endmodule