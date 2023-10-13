`ifndef EXECUTE
`define EXECUTE

// Execute Stage
module execute (
    input clk,                 // Clock signal
    input rst,                 // Reset signal
    
    input [31:0] rs1_value,
    input [31:0] rs2_value,
    input [31:0] imm,
    input [31:0] PC,

    // Sinais de controle
    input AluSrc,               // Determines if the value comes from the Register Bank or is an IMM
    input [2:0] AluOp,          // Operation type ALU will perform
    input [3:0] AluControl,     // Exact operation ALU will perform
    input in_MemWrite,          // True or False depending if the operation Writes in the Memory or not
    input Branch,              // True or False depending if the instruction is a Branch
    input in_MemRead,          // True or False depending if the operation Reads from the Memory or not
    input in_RegWrite,         // True or False depending if the operation writes in a Register or not
    input [4:0] in_RegDest,    // Determines which register to write the ALU result
    input in_MemToReg,         // True or False depending if the operation writes from the Memory into the Resgister Bank
    input in_RegDataSrc,       // Determines where the register data to be writen will come from: memory or ALU result
    input in_PCSrc,            // Determines if the PC will come from the PC+4 or from a Branch calculation

    output reg out_MemWrite,         // True or False depending if the operation Writes in the Memory or not
    output reg out_MemRead,          // True or False depending if the operation Reads from the Memory or not
    output reg out_RegWrite,         // True or False depending if the operation writes in a Register or not
    output reg [4:0] out_RegDest,    // Determines which register to write the ALU result
    output reg out_MemToReg,         // True or False depending if the operation writes from the Memory into the Resgister Bank
    output reg out_RegDataSrc,       // Determines where the register data to be writen will come from: memory or ALU result
    output reg out_PCSrc,            // Determines if the PC will come from the PC+4 or from a Branch calculation
    output reg [31:0] _rs2_value,

    output [31:0] result,
    output reg [31:0] a,
    output reg [31:0] b
);

    reg [31:0] _rs1_value, _imm, _PC;
    reg [2:0] _AluOp;
    reg _AluSrc;

    reg [3:0] _AluControl;
    reg [4:0] _RegDest;
    reg _MemWrite, _MemRead, _RegWrite, _MemToReg, _RegDataSrc, _PCSrc;

    wire zero;
    alu alu(_AluControl, a, b, result, zero);

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            _rs1_value <= 0;
            _rs2_value <= 0;
            _imm <= 0;
            _PC <= 0;
            _AluSrc <= 0;
        end
        else
        begin
            _rs1_value <= rs1_value;
            _rs2_value <= rs2_value;
            _imm <= imm;
            _PC <= PC;
            _AluSrc <= AluSrc;
            _AluOp <= AluOp;
            _AluControl <= AluControl;
            
            _MemWrite <= in_MemWrite;
            _MemRead <= in_MemRead;
            _RegWrite <= in_RegWrite;
            _RegDest <= in_RegDest;
            _MemToReg <= in_MemToReg;
            _RegDataSrc <= in_RegDataSrc;
            _PCSrc <= in_PCSrc;
        end
    end

    always @(*)
    begin
        a <= 0;
        b <= 0;

        case(_AluOp)
        // Tipo Load ou Store
        3'b000 :
        begin
            a <= _rs1_value;
            b <= _imm;
        end

        // Tipo B
        3'b001 :
        begin
            a <= _rs1_value;
            b <= _rs2_value;
            //como que passa o RD pra escrever no banco de REGs dps?
        end

        // Tipo R OU I
        3'b010 :
        begin
            a <= _rs1_value;
            case(_AluSrc)
            1'b1 :
            begin
                b <= _imm;
            end
            1'b0 :
            begin
                b <= _rs2_value;
            end
            endcase
        end

        // Tipo U LUI
        3'b100:
        begin
            a <= _imm;
            b <= 12;
            // é Literalmente isso o LUI, coloca isso no rd direto
        end

        // Tipo U AUIPC
        3'b101:
        begin
            a <= _PC;
            b <= _imm;
            // é Literalmente isso o AIUPC, coloca isso no PC direto
        end

        // Tipo J
        3'b011:
        begin
            a <= _PC;
            b <= _imm;
            //isso pula pra um endereço X, então acho q o mais certo é usar o PC pra fazer os cálculos
        end

        // TODO: JALR
        3'b111:
        begin
            a <= _PC;
            b <= _imm;
            // TODO: Set rd target
            // rd recebe Pc + 4
            // PC <= rs1_value + imm; //dá pra fazer isso aqui?
            // TODO: Isso tem que virar um sinal de controle
            // Sets PC <= Reg[rs1] + immediate COMO????
        end
    endcase

    out_MemWrite <= _MemWrite;
    out_MemRead <= _MemRead;
    out_RegWrite <= _RegWrite;
    out_RegDest <= _RegDest;
    out_MemToReg <= _MemToReg;
    out_RegDataSrc <= _RegDataSrc;
    out_PCSrc <= _PCSrc;
end
    
endmodule

`endif