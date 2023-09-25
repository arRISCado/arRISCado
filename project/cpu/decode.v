`ifndef DECODE
`define DECODE

// Decode Stage
module decode (
    input clk,                // Clock signal
    input rst,                // Reset signal

    input [31:0] next_instruction,

    // TODO: Clean unused outputs
    output reg [31:0] imm,
    output [4:0] rs1, rs2,
    output [5:0] shamt,
    output [2:0] func3,
    output [6:0] func7,
    output [6:0] opcode,
   
    // output sinais de controle
    output reg MemWrite,        // True or False depending if the operation Writes in the Memory or not
    output reg MemRead,         // True or False depending if the operation Reads from the Memory or not
    output reg RegWrite,        // True or False depending if the operation writes in a Register or not
    output [4:0] RegDest,   // Determines which register to write the ALU result
    output reg AluSrc,          // Determines if the value comes from the Register Bank or is an IMM
    output reg [2:0] AluOp,     // Operation type ALU will perform
    output reg [4:0] AluControl,// Exact operation ALU will perform
    output reg MemToReg,        // True or False depending if the operation writes from the Memory into the Resgister Bank
    output reg RegDataSrc,      // Determines where the register data to be writen will come from: memory or ALU result
    output reg [2:0] BranchOp,    // Determines what type of branch is being done
    output reg PCSrc = 0        // Determines where the PC will come from
);

reg [31:0] _instruction;


// Macros dos opcodes:

localparam CODE_LUI = 5'b01101;
localparam CODE_AUIPC = 5'b00101;
localparam CODE_JAL = 5'b11011;
localparam CODE_JARL = 5'b11001;
localparam CODE_B_TYPE = 5'b11000;
localparam CODE_LOAD_TYPE = 5'b00000;
localparam CODE_SAVE_TYPE = 5'b01000;
localparam CODE_I_TYPE = 5'b00100;
localparam CODE_R_TYPE = 5'b01100;
localparam CODE_SYS_CALL = 5'b11100;
localparam CODE_MUL_DIV = 5'b01100;
// localparam CODE_ = 5'b;
// localparam CODE_ = 5'b;
// localparam CODE_ = 5'b;
// localparam CODE_ = 5'b;
// localparam CODE_ = 5'b;
// localparam CODE_ = 5'b;
// localparam CODE_ = 5'b;
// localparam CODE_ = 5'b;
// localparam CODE_ = 5'b;
// localparam CODE_ = 5'b;
// localparam CODE_ = 5'b;





always @(posedge clk or posedge rst) 
begin
    if (rst)
        _instruction = 0;
    else
        _instruction = next_instruction;
end

// Divide each possible part of an instruction
assign opcode = _instruction[6:0];
assign RegDest = _instruction[11:7];
assign rs1 = _instruction[19:15];
assign rs2 = _instruction[24:20];
assign shamt = _instruction[24:20];
assign func3 = _instruction[14:12];
assign func7 = _instruction[31:25];

always @(*) 
begin

    // Standart Value for PCSrc
    PCSrc = 0;
    
     /// Most common Immediate
    imm = {_instruction[31:20], 21'b0};
    
    // Eventualmente, com as instruções de 16 bits, vai ter que
    // separar a instrução de 32 bits em 2 intruções de 16 bits

    // Pelo que o professor falou, os 2 primeiros bits da instrução
    // definem se é 32, 16 ou 64 bits.

    // Intruções dos tipos RV32IMA
    if(opcode[1:0] == 11) 
    begin
        case (opcode[6:2])
            // LUI: Load Upper Immediate (Tipo U)
            CODE_LUI : 
                begin
                    AluOp = 3'b100;
                    AluSrc = 1;
                    MemToReg = 0;
                    RegWrite = 1;
                    MemRead = 0;
                    MemWrite = 0;
                    Branch = 0;
                    AluControl = 5'b00110;
                    imm = {_instruction[31:12], 12'b0};
                end
            
            // AUIPC: Add U-Immediate with PC (Tipo U)
            // Modificar isso pq tá tudo errado
            CODE_AUIPC : 
                begin
                    AluOp = 3'b101;
                    AluSrc = 1;
                    MemToReg = 1;
                    RegWrite = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    Branch = 1;
                    AluControl = 5'b00110;
                    imm = {_instruction[31:12], 12'b0};
                end

            // JAL: Jump And Link (Tipo J)
            CODE_JAL : 
            begin
                AluOp = 3'b011;
                AluSrc = 1;
                MemToReg = 1;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 1;
                AluControl = 5'b00110;
                imm = {_instruction[31:12], 12'b0};
            end

            //JARL: Jump And Link Register (Tipo I)
            CODE_JARL :
            begin
                AluOp = 3'b111;
                case (func3)
                7'b000 :                   
                    begin
                        imm = {_instruction[31:20], 20'b0};
                    end

                endcase
            end

            // Instruções de Branch: dependedem de func3 (Tipo B)
            CODE_B_TYPE :
            begin
                AluOp = 3'b001;
                AluSrc = 0;
                // MemToReg = 1; Don't Care
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 1;
                AluControl = 5'b00100; // Branch performa uma subtração na ALU pra fazer a comparação
                imm = {_instruction[11:8], _instruction[30:25], _instruction[7], _instruction[31], 2'b0}; // Imediato usado pra somar no PC

                BranchOp = func3;
            end

            // Instruções dos tipos de Loads: dependem do func3
            CODE_LOAD_TYPE :
                begin
                    AluOp = 3'b000;
                    AluSrc = 1;
                    MemToReg = 1;
                    RegWrite = 1;
                    MemRead = 1;
                    MemWrite = 0;
                    Branch = 0;
                    AluControl = 5'b00010; // LW performa uma soma na ALU pra calculcar endereço
                    imm = {_instruction[31:20], 20'b0};

                    // Esse sinal irá indicar pra ALU/MEM qual o tipo de Load
                    // (Não sei oq fazer pra diferenciar os tipos de Load ainda, então o padrão vai ser LW por hora)
                    // if (func3 == 010) 
                    begin
                        
                    end
                end
            
            // Instruções pros tipos de Save: dependem do func3 (Tipo S)
            CODE_SAVE_TYPE :
                begin
                    AluOp = 3'b000;
                    AluSrc = 1;
                    // MemToReg = 1; Don't Care
                    RegWrite = 0;
                    MemRead = 0;
                    MemWrite = 1;
                    Branch = 0;
                    AluControl = 5'b00010; // SW performa uma soma na ALU pra calculcar endereço
                    imm = {_instruction[11:7], _instruction[31:25], 20'b0};
                    
                    // Esse sinal irá indicar pra ALU/MEM qual o tipo de store
                    // (Não sei oq fazer pra diferenciar os tipos de store ainda, então o padrão vai ser SW por hora)
                    // if (func3 == 010) 
                end
            
            // Instruções para operações com Imediato (Tipo I)
            // ADDI, SLTI, SLTIU, XORI, ORI(muito bom jogo), ANDI, SLLI, SRLI, SRAI
            CODE_I_TYPE :
                begin
                    AluOp = 3'b010;
                    AluSrc  = 1;
                    MemToReg = 0;
                    RegWrite = 1;
                    MemRead = 0;
                    MemWrite = 0;
                    Branch = 0;
                    imm = {_instruction[31:20], 20'b0};

                    case (func3)
                        // ADDI
                        3'b000:
                        begin
                            AluControl = 5'b00010;
                        end
                        // SLTI
                        3'b010:
                        begin
                            AluControl = 5'b01001;
                        end
                        // SLTIU
                        3'b011:
                        begin
                            AluControl = 5'b01010;    
                        end
                        // XORI
                        3'b100:
                        begin
                            AluControl = 5'b00011;    
                        end
                        // ORI
                        3'b110:
                        begin
                            AluControl = 5'b00001;    
                        end
                        // ANDI
                        3'b111:
                        begin
                            AluControl = 5'b00000;
                        end
                        // SLLI
                        // dar um jeito no execute pra pegar o SHAMT
                        3'b001:
                        begin
                            AluControl = 5'b00110;
                        end
                        // SRLI, SRAI
                        3'b101:
                        begin
                            if (func7 == 7'b0000000) 
                            begin
                                AluControl = 5'b00111;
                            end
                            else if (func7 == 7'b0100000)
                            begin
                                AluControl = 5'b01000;
                            end
                        end
                endcase
                    
                end
        
            // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND (Tipo R)
            CODE_R_TYPE :
                begin
                    AluOp = 3'b010;
                    AluSrc  = 0;
                    MemToReg = 0;
                    RegWrite = 1;
                    MemRead = 0;
                    MemWrite = 0;
                    Branch = 0;
                
                    case(func3)
                        3'b000 :
                        begin
                            case (func7)
                                // ADD
                                7'b0000000 :
                                begin
                                    AluControl = 5'b00010;
                                end
                                // SUB
                                7'b0100000 :
                                begin
                                    AluControl = 5'b00100;
                                end
                            endcase
                        end
                        // AND
                        3'b111 :
                        begin
                            AluControl = 5'b00000;
                        end
                        // OR
                        3'b110:
                        begin
                            AluControl = 5'b00001;
                        end
                        // XOR
                        3'b100:
                        begin
                            AluControl = 5'b00011;
                        end
                        // SLL
                        3'b001:
                        begin
                            AluControl = 5'b00110;
                        end
                        // SRL, SRA
                        3'b101 :
                        begin
                            // SLR
                            if (func7 == 7'b0000000)
                            begin
                                AluControl = 5'b00111;
                            end
                            // SRA
                            else if (func7 == 7'b0100000) 
                            begin
                                AluControl = 5'b01000;
                            end
                        end
                        // SLT
                        3'b010:
                        begin
                            AluControl = 5'b01001;
                        end
                        // SLTU
                        3'b011:
                        begin
                            AluControl = 5'b01010;
                        end
                    endcase
                end

        // // FENCE: Synch Thread
        // 7'b000111 :
        // begin
				    // RegDest = instruction[11:7];
        //     func3= instruction[14:12];
        //     rs1 = instruction[19:15];
        //     succ = instruction[22:20];
        //     pred = instruction[26:23];
        //     fm = instruction[27:31];        
				    // RegDest = instruction[11:7];
        //     func3= instruction[14:12];
        //     rs1 = instruction[19:15];
        //     succ = instruction[22:20];
        //     pred = instruction[26:23];
        //     fm = instruction[27:31];        
        // end

        // // FENCE.TSO : não faço ideia do que é isso
        // 7'b0001111 :
        // begin
        //     // RegDest = instruction[11:7];
        //     func3= instruction[14:12];
        //     // rs1 = instruction[19:15];
        //     // succ = instruction[22:20];
        //     // pred = instruction[26:23];
        //     // fm = instruction[27:31];        
        //     // RegDest = instruction[11:7];
        //     func3= instruction[14:12];
        //     // rs1 = instruction[19:15];
        //     // succ = instruction[22:20];
        //     // pred = instruction[26:23];
        //     // fm = instruction[27:31];        
        // end

            // ECALL and EBREAK: chamada de sistema (Tipo I)
            CODE_SYS_CALL :
            begin
                AluOp = 3'b001;
                imm = {_instruction[31:20], 20'b0};
            end

            // Multiplication/Division instructions
            CODE_MUL_DIV :
            begin
                AluOp = 3'b010;
                AluSrc  = 0;
                MemToReg = 0;
                RegWrite = 1;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;

                // mul: Place result in lower part of rd
                if (func3 == 3'b000) 
                begin
                    AluControl = 5'b01011;
                end
                // mulh: Place result in higher part of rd
                else if (func3 == 3'b001)
                begin
                    AluControl = 5'b01100;
                end
                // mulhsu: mulh with signed rs1 and unsigned rs2
                else if (func3 == 3'b010)
                begin
                    AluControl = 5'b01101;
                end
                // mulhu: mulh with unsigned rs1 and unsigned rs2
                else if (func3 == 3'b011)
                begin
                    AluControl = 5'b01110;
                end
                // div: divide signed rs1 by signed rs2
                else if (func3 == 3'b100)
                begin
                    AluControl = 5'b01111;
                end
                // divu: unsigned div
                else if (func3 == 3'b101)
                begin
                    AluControl = 5'b10000;    
                end
                // rem: reminder(resto) of the division rs1 by rs2
                else if (func3 == 3'b110)
                begin
                    AluControl = 5'b10001;
                end
                // remu: unsigned rem
                else if (func3 == 3'b111)
                begin
                    AluControl = 5'b10010;
                end
            end

        // Should traslate to NOP
        default :
        begin
            // isso tem que virar sinal de controle
            AluSrc  = 0;
            MemToReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            PCSrc = 0;
            $display("Instrução %h inválida!", _instruction);
        end
        
        endcase
    end
end
    
endmodule

`endif