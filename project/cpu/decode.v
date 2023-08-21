// Decode Stage
module decode (
    input [31:0] instruction,
    //input clock,
    output [6:0] opcode, // serve pra depurar, mas nao é saida de fato
    output [20:0] imm,
    output [5:0] rd,
    output [5:0] rs1,
    output [5:0] rs2,
    output [5:0] shamt,
    output [2:0] func3, // serve pra depurar, mas nao é saida de fato
    output [6:0] func7 // serve pra depurar, mas nao é saida de fato
    // output sinais de controle 
);


reg [6:0] opcode_in;
reg [20:0] imm_in;
reg [5:0] rd_in;
reg [5:0] rs1_in;
reg [5:0] rs2_in;
reg [5:0] shamt_in;
reg [2:0] func3_in;
reg [6:0] func7_in;

assign imm = imm_in;
assign rd = rd_in;
assign rs1 = rs1_in;
assign rs2 = rs2_in;
assign shamt = shamt_in;

always @* begin

    // Definição default de todos os sinais de controle
    opcode_in <= instruction[6:0];
    imm_in <= instruction[31:12]; // definindo o 
    rd_in <= instruction[11:7];
    rs1_in <= instruction[19:15];
    rs2_in <= instruction[24:20];
    shamt_in <= instruction[24:20];
    func3_in <= instruction[14:12];
    func7_in <= instruction[31:25];

    // Eventualmente, com as instruções de 16 bits, vai ter que
    // separar a instrução de 32 bits em 2 intruções de 16 bits

    // Pelo que o professor falou, os 2 primeiros bits da instrução
    // definem se é 32, 16 ou 64 bits.


    case (opcode_in)
        // LUI: Load Upper Immediate
        7'b0110111 : 
            begin
                imm_in <= instruction[31:12];
            end
        
        // AUIPC: Add U-Immediate with PC
        7'b0010111 :
            begin
                imm_in <= instruction[31:12];
            end

        // JAL: Jump And Link
        7'b110111 : 
        begin
            imm_in <= {instruction[31], instruction[30:21], instruction[20], instruction[19:12]};
        end

        //JARL: Jump And Link Register
        7'b1100111 :
        begin
            case (func3)
            7'b000 :
                begin
                    imm_in <= instruction[31:20];
                end
            
            endcase
        end

        // Instruções de Branch: dependedem de func3
        7'b1100011 :
        begin
            // Esse sinal irá indicar pra ALU qual o tipo de Branch
            imm_in <= {instruction[11:8], instruction[30:25], instruction[7], instruction[31]};
        end

        // Instruções dos tipos de Loads: dependem do func3
        7'b0000011 :
            begin
                // Esse sinal irá indicar pra ALU/MEM qual o tipo de Load
                imm_in <= instruction[31:20];
            end
        
        // Instruções pros tipos de Save: dependem do func3
        7'b0100011 :
            begin
                // Esse sinal irá indicar pra ALU/MEM qual o tipo de Load
                imm_in <= {instruction[11:7], instruction[31:25]}; 
            end
        
        // Instruções para operações com Imediato ou Registrador
        7'b0010011 :
            begin
                // ADDI, SLTI, SLTIU, XORI, ORI, ANDI
                if ((func3_in == 3'b000) || (func3_in== 3'b010) || 
                (func3_in== 3'b011) || (func3_in== 3'b100) ||
                (func3_in== 3'b110) || (func3_in== 3'b111)) begin
                    imm_in <= instruction[31:20];  
                end

                // SLLI, SRLI, SRAI
                else if ((func3_in == 3'b001) || (func3_in == 3'b101)) begin
                // end
                // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
                else begin
                end
            end

        // // FENCE: Synch Thread
        // 7'b000111 :
        // begin
				    // rd <= instruction[11:7];
        //     func3_in<= instruction[14:12];
        //     rs1 <= instruction[19:15];
        //     succ <= instruction[22:20];
        //     pred <= instruction[26:23];
        //     fm <= instruction[27:31];        
        // end

        // // FENCE.TSO : não faço ideia do que é isso
        // 7'b0001111 :
        // begin
        //     // rd <= instruction[11:7];
        //     func3_in<= instruction[14:12];
        //     // rs1 <= instruction[19:15];
        //     // succ <= instruction[22:20];
        //     // pred <= instruction[26:23];
        //     // fm <= instruction[27:31];        
        // end

        // ECALL and EBREAK: chamada de sistema
        7'b1110011 :
        begin
            imm_in <= instruction[31:20];
        end

        default :
        begin
            // isso tem que virar sinal de controle
        end
        
    endcase

end
    
endmodule
