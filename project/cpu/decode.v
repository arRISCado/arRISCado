`ifndef DECODE
`define DECODE

// Decode Stage
module decode (
    input clk,                // Clock signal
    input rst,                // Reset signal

    input [31:0] next_instruction,
    input [31:0] PC,
    input [31:0] regbank_value1,
    input [31:0] regbank_value2,

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
    output [4:0] RegDest,       // Determines which register to write the ALU result
    output reg AluSrc,          // Determines if the value comes from the Register Bank or is an IMM
    output reg [2:0] AluOp,     // Operation type ALU will perform
    output reg [4:0] AluControl,// Exact operation ALU will perform
    output reg Branch,          // True or False depending if the instruction is a Branch
    output reg MemToReg,        // True or False depending if the operation writes from the Memory into the Resgister Bank
    output reg RegDataSrc,      // Determines where the register data to be writen will come from: memory or ALU result
    output [2:0] BranchOp,      // Determines what type of branch is being done
    output [31:0] BranchOffset,
    output reg PCSrc,       // Determines where the PC will come from
    output reg [2:0] BranchType,
    output reg [31:0] PC_out,
    output reg [31:0] value1,
    output reg [31:0] value2
);

    // Macros dos opcodes:
    localparam CODE_LUI         = 7'b0110111;
    localparam CODE_AUIPC       = 7'b0010111;
    localparam CODE_JAL         = 7'b1101111;
    localparam CODE_JARL        = 7'b1100111;
    localparam CODE_B_TYPE      = 7'b1100011;
    localparam CODE_LOAD_TYPE   = 7'b0000011;
    localparam CODE_SAVE_TYPE   = 7'b0100011;
    localparam CODE_I_TYPE      = 7'b0010011;
    localparam CODE_R_TYPE      = 7'b0110011;
    localparam CODE_SYS_CALL    = 7'b1110011;
    localparam CODE_MUL_DIV     = 7'b0110011;


    reg [31:0] _instruction;
    reg [31:0] _value1;
    reg [31:0] _value2;

    // Divide each possible part of an instruction
    assign opcode = _instruction[6:0];
    assign RegDest = _instruction[11:7];
    assign rs1 = _instruction[19:15];
    assign rs2 = _instruction[24:20];
    assign shamt = _instruction[24:20];
    assign func3 = _instruction[14:12];
    assign func7 = _instruction[31:25];

    always @(posedge clk or posedge rst)
    begin
        if (rst) 
        begin
            _instruction <= 0;
            _value1 <= 0;
            _value2 <= 0;
        end
        else
        begin
            _instruction <= next_instruction;
            _value1 <= regbank_value1;
            _value2 <= regbank_value2;
        end
    end

    always @(*) 
    begin
        // Standart Value for PCSrc
        imm <= 0;
        MemWrite   <= 0;
        MemRead    <= 0;
        RegWrite   <= 0;
        AluSrc     <= 0;
        AluOp      <= 0;
        AluControl <= 0;  
        Branch     <= 0;
        MemToReg   <= 0; 
        RegDataSrc <= 0;    
        PCSrc      <= 0;
        PC_out <= PC-4;
        value1 <= _value1;
        value2 <= _value2;

        case (opcode)
            // LUI: Load Upper Immediate (Tipo U)
            CODE_LUI : 
                begin
                    AluOp <= 3'b100;
                    AluSrc <= 1;
                    MemToReg <= 0;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    PCSrc <= 0;
                    AluControl <= 5'b00010;
                    imm <= {_instruction[31:12], 12'b0};
                end
            
            // AUIPC: Add U-Immediate with PC (Tipo U)
            CODE_AUIPC : begin
                    AluOp <= 3'b101;
                    AluSrc <= 1;
                    MemToReg <= 0;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    PCSrc <= 0;
                    AluControl <= 5'b00010;
                    imm <= {_instruction[31:12], 12'b0};
                end

            // JAL: Jump And Link (Tipo J)
            CODE_JAL : 
            begin
                AluOp <= 3'b011;
                AluSrc <= 1;
                MemToReg <= 1;
                RegWrite <= 0;
                MemRead <= 0;
                MemWrite <= 0;
                PCSrc <= 1;
                AluControl <= 5'b00010;
                imm <= {12'b0, _instruction[31:12]};
            end

            //JARL: Jump And Link Register (Tipo I)
            // Essa intrução é bizarra, verificar dps
            CODE_JARL :
            begin
                AluOp <= 3'b111;
                AluSrc <= 1;
                MemToReg <= 1;
                RegWrite <= 0;
                MemRead <= 0;
                MemWrite <= 0;
                PCSrc <= 1;
                AluControl <= 5'b00010;
                case (func3)
                7'b000 :
                    begin
                        imm <= {20'b0, _instruction[31:20]};
                    end

                endcase
            end

            // Instruções de Branch: dependedem de func3 (Tipo B)
            CODE_B_TYPE :
            begin
                $display("quero me matar usando um facão enferrujado");
                AluOp <= 3'b001;
                AluSrc <= 0;
                RegWrite <= 0;
                MemRead <= 0;
                MemWrite <= 0;
                PCSrc <= 1;
                AluControl <= 5'b00100; // Branch performa uma subtração na ALU pra fazer a comparação
                // inverter esse imediato
                // imm <= {2'b0, _instruction[31], _instruction[7], _instruction[30:25], _instruction[11:8]}; // Imediato usado pra somar no PC

                imm <= {_instruction[31] ? 19'b1111111111111111111 : 19'b0, _instruction[31], _instruction[7], _instruction[30:25], _instruction[11:8], 1'b0}; // Imediato usado pra somar no PC
                BranchType <= func3;
            end

            // Instruções dos tipos de Loads: dependem do func3
            CODE_LOAD_TYPE :
                begin
                    AluOp <= 3'b000;
                    AluSrc <= 1;
                    MemToReg <= 1;
                    RegWrite <= 1;
                    MemRead <= 1;
                    MemWrite <= 0;
                    PCSrc <= 0;
                    AluControl <= 5'b00010; // LW performa uma soma na ALU pra calculcar endereço
                    imm <= {20'b0, _instruction[31:20]};
                end
            
            // Instruções pros tipos de Save: dependem do func3 (Tipo S)
            CODE_SAVE_TYPE :
                begin
                    AluOp <= 3'b000;
                    AluSrc <= 1;
                    RegWrite <= 0;
                    MemRead <= 0;
                    MemWrite <= 1;
                    PCSrc <= 0;
                    AluControl <= 5'b00010; // SW performa uma soma na ALU pra calculcar endereço
                    imm <= {20'b0, _instruction[31:25], _instruction[11:7]};
                    
                    // Esse sinal irá indicar pra ALU/MEM qual o tipo de store
                    // (Não sei oq fazer pra diferenciar os tipos de store ainda, então o padrão vai ser SW por hora)
                    // if (func3 == 010) 
                end
            
            // Instruções para operações com Imediato (Tipo I)
            CODE_I_TYPE :
                begin
                    $display("quero me matar usando um facão de cobre enferrujado");
                    AluOp <= 3'b010;
                    AluSrc  <= 1;
                    MemToReg <= 0;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    PCSrc <= 0;
                    imm <= {21'b0, _instruction[31:20]};

                    case (func3)
                        // ADDI
                        3'b000:
                        begin
                            AluControl <= 5'b00010;
                        end
                        // SLTI
                        3'b010:
                        begin
                            AluControl <= 5'b01001;
                        end
                        // SLTIU
                        3'b011:
                        begin
                            AluControl <= 5'b01010;    
                        end
                        // XORI
                        3'b100:
                        begin
                            AluControl <= 5'b00011;    
                        end
                        // ORI
                        3'b110:
                        begin
                            AluControl <= 5'b00001;    
                        end
                        // ANDI
                        3'b111:
                        begin
                            AluControl <= 5'b00000;
                        end
                        // SLLI
                        // dar um jeito no execute pra pegar o SHAMT
                        3'b001:
                        begin
                            AluControl <= 5'b00110;
                        end
                        // SRLI, SRAI
                        3'b101:
                        begin
                            if (func7 == 7'b0000000) 
                            begin
                                AluControl <= 5'b00111;
                            end
                            else if (func7 == 7'b0100000)
                            begin
                                AluControl <= 5'b01000;
                            end
                        end
                    endcase
                    
                end

        
            // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND (Tipo R)
            CODE_R_TYPE :
                begin
                    AluOp <= 3'b010;
                    AluSrc  <= 0;
                    MemToReg <= 0;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    PCSrc <= 0;
                
                    case(func3)
                        3'b000 :
                        begin
                            case (func7)
                                // ADD
                                7'b0000000 :
                                begin
                                    AluControl <= 5'b00010;
                                end
                                // SUB
                                7'b0100000 :
                                begin
                                    AluControl <= 5'b00100;
                                end
                            endcase
                        end
                        // AND
                        3'b111 :
                        begin
                            AluControl <= 5'b00000;
                        end
                        // OR
                        3'b110:
                        begin
                            AluControl <= 5'b00001;
                        end
                        // XOR
                        3'b100:
                        begin
                            AluControl <= 5'b00011;
                        end
                        // SLL
                        3'b001:
                        begin
                            AluControl <= 5'b00110;
                        end
                        // SRL, SRA
                        3'b101 :
                        begin
                            // SLR
                            if (func7 == 7'b0000000)
                            begin
                                AluControl <= 5'b00111;
                            end
                            // SRA
                            else if (func7 == 7'b0100000) 
                            begin
                                AluControl <= 5'b01000;
                            end
                        end
                        // SLT
                        3'b010:
                        begin
                            AluControl <= 5'b01001;
                        end
                        // SLTU
                        3'b011:
                        begin
                            AluControl <= 5'b01010;
                        end
                    endcase
                end


            // // FENCE: Synch Thread
            // 7'b000111 :
            // begin
                        // RegDest <= instruction[11:7];
            //     func3= instruction[14:12];
            //     rs1 <= instruction[19:15];
            //     succ <= instruction[22:20];
            //     pred <= instruction[26:23];
            //     fm <= instruction[27:31];        
                        // RegDest <= instruction[11:7];
            //     func3= instruction[14:12];
            //     rs1 <= instruction[19:15];
            //     succ <= instruction[22:20];
            //     pred <= instruction[26:23];
            //     fm <= instruction[27:31];        
            // end

            // // FENCE.TSO : não faço ideia do que é isso
            // 7'b0001111 :
            // begin
            //     // RegDest <= instruction[11:7];
            //     func3= instruction[14:12];
            //     // rs1 <= instruction[19:15];
            //     // succ <= instruction[22:20];
            //     // pred <= instruction[26:23];
            //     // fm <= instruction[27:31];        
            //     // RegDest <= instruction[11:7];
            //     func3= instruction[14:12];
            //     // rs1 <= instruction[19:15];
            //     // succ <= instruction[22:20];
            //     // pred <= instruction[26:23];
            //     // fm <= instruction[27:31];        
            // end

            // ECALL and EBREAK: chamada de sistema (Tipo I)
            CODE_SYS_CALL :
            begin
                AluOp <= 3'b001;
                imm <= {20'b0, _instruction[31:20]};
            end

            CODE_MUL_DIV :
            begin
                AluOp <= 3'b010;
                AluSrc  <= 0;
                MemToReg <= 0;
                RegWrite <= 1;
                MemRead <= 0;
                MemWrite <= 0;

                case(func3)
                    // mul: Place result in lower part of rd
                    3'b000: 
                        AluControl <= 5'b01011;
                    // mulh: Place result in higher part of rd
                    3'b001:
                        AluControl <= 5'b01100;
                    // mulhsu: mulh with signed rs1 and unsigned rs2
                    3'b010:
                        AluControl <= 5'b01101;
                    // mulhu: mulh with unsigned rs1 and unsigned rs2
                    3'b011:
                        AluControl <= 5'b01110;
                    // div: divide signed rs1 by signed rs2
                    3'b100:
                        AluControl <= 5'b01111;
                    // divu: unsigned div
                    3'b101:
                        AluControl <= 5'b10000;    
                    // rem: reminder(resto) of the division rs1 by rs2
                    3'b110:
                        AluControl <= 5'b10001;
                    // remu: unsigned rem
                    3'b111:
                        AluControl <= 5'b10010;
                endcase
            end


            // Should traslate to NOP
            default :
            begin
                // isso tem que virar sinal de controle
                AluSrc  <= 0;
                MemToReg <= 0;
                RegWrite <= 0;
                MemRead <= 0;
                MemWrite <= 0;
                PCSrc <= 0;
                // synthesis translate_off
                $display("INSTRUÇÃO INVÁLIDA! INSTRUÇÃO INVÁLIDA!");
                // synthesis translate_on
            end
            
        endcase
    end
    
endmodule

`endif