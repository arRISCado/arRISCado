// Decode Stage
module decode (
    input instruction[31:0],
    input clock,
    output opcode,
    output imm,
    output rd,
    output rs1,
    output rs2,
    output shamt,
    output func3,
    output func7
);

always @(posedge clock) begin


    // Definição default de todos os sinais de controle (NOP)
    imm = 2'b000000000000;
    rd = 0;
    rs1 = 0;
    rs2 = 0;
    shamt = 00000;    
    func3 = 000;
    func7 = 000;
    
    // Eventualmente, com as instruções de 16 bits, vai ter que 
    // separar a instrução de 32 bits em 2 intruções de 16 bits 

    // Pelo que o professor falou, os 2 primeiros bits da instrução
    // definem se á 32, 16 ou 64 bits.
    opcode = instruction[6:0];

    case (opcode)
        // LUI: Load Upper Immediate
        2'b0110111 : 
            begin        
                rd = instruction[11:7];
                imm = instruction[31:12];
            end
        
        // AUIPC: Add U-Immediate with PC
        2'b0010111 :
            begin
                rd = instruction[11:7];
                imm = instruction[31:12];
            end

        // JAL: Jump And Link
        2'b110111 : 
        begin
            rd = instruction[11:7];
            imm = {instruction[31], instruction[30:21], instruction[20], instruction[19:12]};
        end

        //JARL: Jump And Link Register
        2'b1100111 :
        begin
            func3 = instruction[14:12];
            

            case (func3)
            2'b000 :
                begin
                    rd = instruction[11:7];
                    rs1 = instruction[19:15];
                    imm = instruction[31:20];
                end
            
            endcase
        end

        // Instruções de Branch: dependedem de func3
        2'b1100011 :
        begin

            // Esse sinal irá indicar pra ALU qual o tipo de Branch
            // quem tá com a ALU que se vire depois
            // ...
            // não pera sou eu...
            // é tenso
            func3 = instruction[14:12];

            imm = {instruction[8:11], instruction[25:30], instruction[7], instruction[31]};
            rs1 = instruction[25:19];
            rs2 = instruction[20:24];
        end

        // Instruções dos tipos de Loads: dependem do func3
        2'b0000011 :
            begin
                // Esse sinal irá indicar pra ALU/MEM qual o tipo de Load
                func3 = instruction[14:12];

                rd = instruction[11:7];
                rs1 = instruction[19:15];
                imm = instruction[31:20];
            end
        
        // Instruções pros tipos de Save: dependem do func3
        2'b0100011 :
            begin
                // Esse sinal irá indicar pra ALU/MEM qual o tipo de Load
                func3 = instruction[14:12];
 
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                imm = {instruction[11:7], instruction[31:25]}; 
            end
        
        // Instruções para operações com Imediato ou Registrador
        2'b0010011 :
            begin
                func3 = instruction[14:12];

                // ADDI, SLTI, SLTIU, XORI, ORI, ANDI
                if ((func3 == 2'b000) || (func3 == 2'b010) || 
                (func3 == 2'b011) || (func3 == 2'b100) ||
                (func3 == 2'b110) || (func3 == 2'b111)) begin
                    rd = instruction[11:7];
                    rs1 = instruction[19:15];
                    imm = instruction[31:20];
                end

                // SLLI, SRLI, SRAI
                else if ((func3 == 001) || (func3 == 101)) begin
                    func7 = instruction[31:25];
                    rd = instruction[11:7];
                    rs1 = instruction[19:15];
                    shamt = instruction[24:20];
                end
                // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
                else begin
                    func7 = instruction[31:25];
                    rd = instruction[11:7];
                    rs1 = instruction[19:15];
                    rs2 = instruction[24:20];
                end

        // // FENCE: Synch Thread
        // 2'b000111 :
        // begin
				    // rd = instruction[11:7];
        //     func3 = instruction[14:12];
        //     rs1 = instruction[19:15];
        //     succ = instruction[22:20];
        //     pred = instruction[26:23];
        //     fm = instruction[27:31];        
        // end

        // // FENCE.TSO : não faço ideia do que é isso
        // 2'b0001111 :
        // begin
        //     // rd = instruction[11:7];
        //     func3 = instruction[14:12];
        //     // rs1 = instruction[19:15];
        //     // succ = instruction[22:20];
        //     // pred = instruction[26:23];
        //     // fm = instruction[27:31];        
        // end

        // ECALL : chamada de sistema
        2'b1110011 :
        begin
            imm = instruction[31:20];
        end

        // EBREAK : chama de sistema de novo?
        2'b1110011 :
        begin
            imm = instruction[31:20];
        end
        default :    
            opcode = 2'b0010011;
        endcase

end
    
endmodule
