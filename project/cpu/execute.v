// Execute Stage
module execute (
    input clk,                 // Clock signal
    input rst,                 // Reset signal
    input enable,
    output reg stop_behind,

    input [31:0] rd,
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

    output reg [4:0] rd_out,
    output [31:0] result,
    output reg [31:0] a,
    output reg [31:0] b
);

    reg [31:0] _rd;
    reg [31:0] _rs1_value;
    reg [31:0] _rs2_value;
    reg [31:0] _imm;
    reg [31:0] _PC;
    reg _AluSrc;
    reg [2:0] _AluOp;

    alu alu(AluControl, a, b, result);

    always @(posedge clk or posedge rst)
    begin
        if (enable) begin
            if (rst)
            begin
                stop_behind = 0;
                
                a = 0;
                b = 0;
                rd_out = 0;
                _rd = 0;
                _rs1_value = 0;
                _rs2_value = 0;
                _imm = 0;
                _PC = 0;
                _AluSrc = 0;
            end
            else
            begin
                out_MemWrite = in_MemWrite;
                out_MemRead = in_MemRead;
                out_RegWrite = in_RegWrite;
                out_RegDest = in_RegDest;
                out_MemToReg = in_MemToReg;
                out_RegDataSrc = in_RegDataSrc;
                out_PCSrc = in_PCSrc;
                rd_out = rd;
                _rd = rd;
                _rs1_value = rs1_value;
                _rs2_value = rs2_value;
                _imm = imm;
                _PC = PC;
                _AluSrc = AluSrc;
            end
        end
    end

    always @(*)
    begin
        if (enable) begin
            case(AluOp)
            // Tipo Load ou Store
            3'b000 :
            begin
                a = _rs1_value;
                b = _imm;
            end

            // Tipo B
            3'b001 :
            begin
                a = _rs1_value;
                b = _rs2_value;
                //como que passa o RD pra escrever no banco de REGs dps?
            end

            // Tipo R OU I
            3'b010 :
            begin
                a = _rs1_value;
                case(_AluSrc)
                1'b1 :
                begin
                    b = _imm;
                end
                1'b0 :
                begin
                    b = _rs2_value;
                end
                endcase
            end

            // Tipo U LUI
            3'b100:
            begin
                a = _rd;
                b = _imm;
                // é Literalmente isso o LUI, coloca isso no rd direto
            end

            // Tipo U AUIPC
            3'b101:
            begin
                a = _PC;
                b = _imm;
                // é Literalmente isso o AIUPC, coloca isso no PC direto
            end

            // Tipo J
            3'b011:
            begin
                a = _PC;
                b = _imm;
                //isso pula pra um endereço X, então acho q o mais certo é usar o PC pra fazer os cálculos
            end

            // TODO: JALR
            3'b111:
            begin
                a = _PC;
                b = _imm;
                // TODO: Set rd target
                // rd recebe Pc + 4
                // PC = rs1_value + imm; //dá pra fazer isso aqui?
                // TODO: Isso tem que virar um sinal de controle
                // Sets PC = Reg[rs1] + immediate COMO????
            end
        endcase
    end

end
    
endmodule