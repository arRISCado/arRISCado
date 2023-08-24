// Decode Stage
module decode (
    instruction,
    // clock,
    opcode, // serve pra depurar, mas nao é saida de fato
    imm,
    rd,
    rs1,
    rs2,
    shamt,
    func3,  // serve pra depurar, mas nao é saida de fato
    func7,  // serve pra depurar, mas nao é saida de fato
   
    // output sinais de controle 
    MemWrite,
    MemRead,
    RegWrite,
    RegDest,
    AluSrc,
    AluOp,
    Branch,
    MemToReg,
    RegDataSrc,
    AluControl,
    PCSrc
);


input [31:0] instruction;
input [6:0] opcode;
input [20:0] imm;
input [5:0] rd, rs1, rs2;
input [5:0] shamt;
input [2:0] func3;
input [6:0] func7;


output MemWrite;         // True or False depending if the operation Writes in the Memory or not
output MemRead;          // True or False depending if the operation Reads from the Memory or not
output RegWrite;         // True or False depending if the operation writes in a Register or not
output [4:0] RegDest;    // Determines which register to write the ALU result
output AluSrc;           // Determines if the value comes from the Register Bank or is an IMM
output [1:0] AluOp;      // Operation type ALU will perform
output [3:0] AluControl; // Exact operation ALU will perform
output branch;           // True or False depending if the instruction is a Branch
output MemToReg;         // True or False depending if the operation writes from the Memory into the Resgister Bank
output RegDataSrc;       // Determines where the register data to be writen will come from: memory or ALU result
output PCSrc;            // Determines if the PC will come from the PC+4 or from a Branch calculation

always @* begin

    // Definição default de todos os sinais de controle
    opcode <= instruction[6:0];
    imm <= instruction[31:12]; // definindo o tipo de imediato mais comum
    rd <= instruction[11:7];
    rs1 <= instruction[19:15];
    rs2 <= instruction[24:20];
    shamt <= instruction[24:20];
    func3 <= instruction[14:12];
    func7 <= instruction[31:25];

    // Eventualmente, com as instruções de 16 bits, vai ter que
    // separar a instrução de 32 bits em 2 intruções de 16 bits

    // Pelo que o professor falou, os 2 primeiros bits da instrução
    // definem se é 32, 16 ou 64 bits.


    case (opcode)
        // LUI: Load Upper Immediate (Tipo U)
        7'b0110111 : 
            begin
                AluOp <= 3'b100;
                imm <= instruction[31:12];
            end
        
        // AUIPC: Add U-Immediate with PC (Tipo U)
        7'b0010111 : begin
                AluOp <= 3'b100;
                imm <= instruction[31:12];
            end

        // JAL: Jump And Link (Tipo J)
        7'b1101111 : 
        begin
            AluOp <= 3'b011;
            imm <= {instruction[31], instruction[30:21], instruction[20], instruction[19:12]};
        end

        //JARL: Jump And Link Register (Tipo I)
        7'b1100111 :
        begin
            AluOp <= 3'b001;
            case (func3)
            7'b000 :
                begin
                    imm <= instruction[31:20];
                end

            endcase
        end

        // Instruções de Branch: dependedem de func3 (Tipo B)
        7'b1100011 :
        begin
            AluOp <= 3'b011;
            // Esse sinal irá indicar pra ALU qual o tipo de Branch
            imm <= {instruction[11:8], instruction[30:25], instruction[7], instruction[31]};
        end

        // Instruções dos tipos de Loads: dependem do func3 (Tipo I)
        7'b0000011 :
            begin
                AluOp <= 2'b00;
                AluSrc <= 1;
                MemToReg <= 1;
                RegWrite <= 1;
                MemRead <= 1;
                MemWrite <= 0;
                Branch <= 0;
                AluControl <= 4'b0010; // LW performa uma soma na ALU pra calculcar endereço
                imm <= instruction[31:20];

                // Esse sinal irá indicar pra ALU/MEM qual o tipo de Load
                // (Não sei oq fazer pra diferenciar os tipos de Load ainda, então o padrão vai ser LW por hora)
                // if (func3 == 010) 
                begin
                    
                end
            end
        
        // Instruções pros tipos de Save: dependem do func3 (Tipo S)
        7'b0100011 :
            begin
                AluOp <= 2'b00;
                AluSrc <= 1;
                // MemToReg <= 1; Don't Care
                RegWrite <= 1;
                MemRead <= 1;
                MemWrite <= 0;
                Branch <= 0;
                AluControl <= 4'b0010; // SW performa uma soma na ALU pra calculcar endereço
                imm <= {instruction[11:7], instruction[31:25]};
                
                // Esse sinal irá indicar pra ALU/MEM qual o tipo de store
                // (Não sei oq fazer pra diferenciar os tipos de store ainda, então o padrão vai ser SW por hora)
                // if (func3 == 010) 
            end
        
        // Instruções para operações com Imediato (Tipo I)
        7'b0010011 :
            begin
                aluSrc  <= 1;
                MemToReg <= 0;
                RegWrite <= 1;
                MemRead <= 0;
                MemWrite <= 0;
                Branch <= 0;
                AluOp <= 2'b10;
                imm <= instruction[31:20];

                // ADDI
                if (func3 == 000)
                begin
                    AluControl <= 4'b0010;
                end

                // SLTI
                else if (func3 == 010)
                    begin
                    end

                // SLLI, SRLI, SRAI (Tipo I)
                else if ((func3 == 3'b001) || (func3 == 3'b101)) begin
                    AluOp <= 3'b001;
                end
                
            end
       
        // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND (Tipo R)
        7'b0110011 :
            begin

            end

        // // FENCE: Synch Thread
        // 7'b000111 :
        // begin
				    // rd <= instruction[11:7];
        //     func3<= instruction[14:12];
        //     rs1 <= instruction[19:15];
        //     succ <= instruction[22:20];
        //     pred <= instruction[26:23];
        //     fm <= instruction[27:31];        
        // end

        // // FENCE.TSO : não faço ideia do que é isso
        // 7'b0001111 :
        // begin
        //     // rd <= instruction[11:7];
        //     func3<= instruction[14:12];
        //     // rs1 <= instruction[19:15];
        //     // succ <= instruction[22:20];
        //     // pred <= instruction[26:23];
        //     // fm <= instruction[27:31];        
        // end

        // ECALL and EBREAK: chamada de sistema (Tipo I)
        7'b1110011 :
        begin
            AluOp <= 3'b001;
            imm <= instruction[31:20];
        end

        default :
        begin
            // isso tem que virar sinal de controle
        end
        
    endcase

end
    
endmodule
