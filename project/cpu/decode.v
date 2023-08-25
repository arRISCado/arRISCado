// Decode Stage
module decode (
    input [31:0] instruction,
    // clock,
    output reg [20:0] imm,
    output [5:0] rd, rs1, rs2,
    output [5:0] shamt,
    output [2:0] func3,
    output [6:0] func7,
    output [6:0] opcode,
   
    // output sinais de controle
    output reg MemWrite,         // True or False depending if the operation Writes in the Memory or not
    output reg MemRead,          // True or False depending if the operation Reads from the Memory or not
    output reg RegWrite,         // True or False depending if the operation writes in a Register or not
    output reg [4:0] RegDest,    // Determines which register to write the ALU result
    output reg AluSrc,           // Determines if the value comes from the Register Bank or is an IMM
    output reg [1:0] AluOp,      // Operation type ALU will perform
    output reg [3:0] AluControl, // Exact operation ALU will perform
    output reg Branch,           // True or False depending if the instruction is a Branch
    output reg MemToReg,         // True or False depending if the operation writes from the Memory into the Resgister Bank
    output reg RegDataSrc,       // Determines where the register data to be writen will come from: memory or ALU result
    output reg PCSrc             // Determines if the PC will come from the PC+4 or from a Branch calculation
);

// Definição default de todos os sinais de controle
assign opcode = instruction[6:0];
assign rd = instruction[11:7];
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign shamt = instruction[24:20];
assign func3 = instruction[14:12];
assign func7 = instruction[31:25];

always @(*) begin
    imm = instruction[31:12]; // definindo o tipo de imediato mais comum
    
    // Eventualmente, com as instruções de 16 bits, vai ter que
    // separar a instrução de 32 bits em 2 intruções de 16 bits

    // Pelo que o professor falou, os 2 primeiros bits da instrução
    // definem se é 32, 16 ou 64 bits.

    case (opcode)
        // LUI: Load Upper Immediate (Tipo U)
        7'b0110111 : 
            begin
                AluOp = 3'b100;
                imm = instruction[31:12];
            end
        
        // AUIPC: Add U-Immediate with PC (Tipo U)
        7'b0010111 : begin
                AluOp = 3'b100;
                imm = instruction[31:12];
            end

        // JAL: Jump And Link (Tipo J)
        7'b1101111 : 
        begin
            AluOp = 3'b011;
            imm = {instruction[31], instruction[30:21], instruction[20], instruction[19:12]};
        end

        //JARL: Jump And Link Register (Tipo I)
        7'b1100111 :
        begin
            AluOp = 3'b001;
            case (func3)
            7'b000 :
                begin
                    imm = instruction[31:20];
                end

            endcase
        end

        // Instruções de Branch: dependedem de func3 (Tipo B)
        7'b1100011 :
        begin
            AluOp = 2'b01;
            AluSrc = 0;
            // MemToReg = 1; Don't Care
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 1;
            AluControl = 4'b0110; // Branch performa uma subtração na ALU pra fazer a comparação
            imm = {instruction[11:8], instruction[30:25], instruction[7], instruction[31]}; // Imediato usado pra somar no PC

            // Esse sinal irá indicar pra ALU qual o tipo de Branch
            // (Não sei oq fazer pra diferenciar os tipos de Branch ainda, então o padrão vai ser BGE por hora)
            // if (func3 == 010) 
        end

        // Instruções dos tipos de Loads: dependem do func3 (Tipo I)
        7'b0000011 :
            begin
                AluOp = 2'b00;
                AluSrc = 1;
                MemToReg = 1;
                RegWrite = 1;
                MemRead = 1;
                MemWrite = 0;
                Branch = 0;
                AluControl = 4'b0010; // LW performa uma soma na ALU pra calculcar endereço
                imm = instruction[31:20];

                // Esse sinal irá indicar pra ALU/MEM qual o tipo de Load
                // (Não sei oq fazer pra diferenciar os tipos de Load ainda, então o padrão vai ser LW por hora)
                // if (func3 == 010) 
                begin
                    
                end
            end
        
        // Instruções pros tipos de Save: dependem do func3 (Tipo S)
        7'b0100011 :
            begin
                AluOp = 2'b00;
                AluSrc = 1;
                // MemToReg = 1; Don't Care
                RegWrite = 1;
                MemRead = 1;
                MemWrite = 0;
                Branch = 0;
                AluControl = 4'b0010; // SW performa uma soma na ALU pra calculcar endereço
                imm = {instruction[11:7], instruction[31:25]};
                
                // Esse sinal irá indicar pra ALU/MEM qual o tipo de store
                // (Não sei oq fazer pra diferenciar os tipos de store ainda, então o padrão vai ser SW por hora)
                // if (func3 == 010) 
            end
        
        // Instruções para operações com Imediato (Tipo I)
        7'b0010011 :
            begin
                AluSrc  = 1;
                MemToReg = 0;
                RegWrite = 1;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;
                AluOp = 2'b10;
                imm = instruction[31:20];

                // ADDI
                if (func3 == 000)
                begin
                    AluControl = 4'b0010;
                end

                // SLTI
                else if (func3 == 010)
                    begin
                    end

                // SLLI, SRLI, SRAI (Tipo I)
                else if ((func3 == 3'b001) || (func3 == 3'b101)) begin
                    AluOp = 3'b001;
                end
                
            end
       
        // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND (Tipo R)
        7'b0110011 :
            begin

            end

        // // FENCE: Synch Thread
        // 7'b000111 :
        // begin
				    // rd = instruction[11:7];
        //     func3= instruction[14:12];
        //     rs1 = instruction[19:15];
        //     succ = instruction[22:20];
        //     pred = instruction[26:23];
        //     fm = instruction[27:31];        
        // end

        // // FENCE.TSO : não faço ideia do que é isso
        // 7'b0001111 :
        // begin
        //     // rd = instruction[11:7];
        //     func3= instruction[14:12];
        //     // rs1 = instruction[19:15];
        //     // succ = instruction[22:20];
        //     // pred = instruction[26:23];
        //     // fm = instruction[27:31];        
        // end

        // ECALL and EBREAK: chamada de sistema (Tipo I)
        7'b1110011 :
        begin
            AluOp = 3'b001;
            imm = instruction[31:20];
        end

        default :
        begin
            // isso tem que virar sinal de controle
        end
        
    endcase

end
    
endmodule
