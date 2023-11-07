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
    output reg [3:0] AluControl,// Exact operation ALU will perform
    output reg Branch,          // True or False depending if the instruction is a Branch
    output reg MemToReg,        // True or False depending if the operation writes from the Memory into the Resgister Bank
    output reg RegDataSrc,      // Determines where the register data to be writen will come from: memory or ALU result
    output reg PCSrc = 0,       // Determines where the PC will come from
    output reg [2:0] BranchType,
    output reg [31:0] PC_out,
    output reg [31:0] value1,
    output reg [31:0] value2
);

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
        PC_out <= PC-1;
        value1 <= _value1;
        value2 <= _value2;

        case (opcode)
            // LUI: Load Upper Immediate (Tipo U)
            7'b0110111 : 
                begin
                    AluOp <= 3'b100;
                    AluSrc <= 1;
                    MemToReg <= 0;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    Branch <= 0;
                    AluControl <= 4'b0010;
                    imm <= {_instruction[31:12], 12'b0};
                end
            
            // AUIPC: Add U-Immediate with PC (Tipo U)
            7'b0010111 : begin
                    AluOp <= 3'b101;
                    AluSrc <= 1;
                    MemToReg <= 0;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    Branch <= 0;
                    AluControl <= 4'b0010;
                    imm <= {_instruction[31:12], 12'b0};
                end

            // JAL: Jump And Link (Tipo J)
            7'b1101111 : 
            begin
                AluOp <= 3'b011;
                AluSrc <= 1;
                MemToReg <= 1;
                RegWrite <= 0;
                MemRead <= 0;
                MemWrite <= 0;
                Branch <= 1;
                AluControl <= 4'b0110;
                imm <= {12'b0, _instruction[31:12]};
            end

            //JARL: Jump And Link Register (Tipo I)
            7'b1100111 :
            begin
                AluOp <= 3'b111;
                case (func3)
                7'b000 :
                    begin
                        imm <= _instruction[31:20];
                    end

                endcase
            end

            // Instruções de Branch: dependedem de func3 (Tipo B)
            7'b1100011 :
            begin
                AluOp <= 3'b001;
                AluSrc <= 0;
                RegWrite <= 0;
                MemRead <= 0;
                MemWrite <= 0;
                Branch <= 1;
                AluControl <= 4'b0110;
                imm <= {_instruction[31] ? 19'b1111111111111111111 : 19'b0, _instruction[31], _instruction[7], _instruction[30:25], _instruction[11:8], 1'b0}; // Imediato usado pra somar no PC
                BranchType <= func3;
            end

            // Instruções dos tipos de Loads: dependem do func3
            7'b0000011 :
                begin
                    AluOp <= 3'b000;
                    AluSrc <= 1;
                    MemToReg <= 1;
                    RegWrite <= 1;
                    MemRead <= 1;
                    MemWrite <= 0;
                    Branch <= 0;
                    AluControl <= 4'b0010;
                    imm <= {20'b0, _instruction[31:20]};
                end
            
            // Instruções pros tipos de Save: dependem do func3 (Tipo S)
            7'b0100011 :
                begin
                    AluOp <= 3'b000;
                    AluSrc <= 1;
                    RegWrite <= 0;
                    MemRead <= 0;
                    MemWrite <= 1;
                    Branch <= 0;
                    AluControl <= 4'b0010; // SW performa uma soma na ALU pra calculcar endereço
                    imm <= {_instruction[31:25], _instruction[11:7]};
                end
            
            // Instruções para operações com Imediato (Tipo I)
            7'b0010011 :
                begin
                    AluOp <= 3'b010;
                    AluSrc  <= 1;
                    MemToReg <= 0;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    Branch <= 0;
                    imm <= {21'b0, _instruction[31:20]};

                    // ADDI
                    if (func3 == 000)
                    begin
                        AluControl <= 4'b0010;
                    end

                    // SLTI
                    else if (func3 == 010)
                    begin
                        AluControl <= 4'b0010;
                    end

                    // SLLI, SRLI, SRAI (Tipo I)
                    else if ((func3 == 3'b001) || (func3 == 3'b101))
                    begin
                        AluControl <= 4'b0010;
                    end
                    
                end
        
            // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND (Tipo R)
            7'b0110011 :
                begin
                    AluOp <= 3'b010;
                    AluSrc  <= 0;
                    MemToReg <= 0;
                    RegWrite <= 1;
                    MemRead <= 0;
                    MemWrite <= 0;
                    Branch <= 0;
                
                    case(func3)
                        3'b000 :
                        begin
                            case (func7)
                                // ADD
                                7'b0000000 :
                                begin
                                    AluControl <= 4'b0010;
                                end
                                // SUB
                                7'b0100000 :
                                begin
                                    AluControl <= 4'b0110;
                                end
                            endcase
                        end
                        // AND
                        3'b111 :
                        begin
                            AluControl <= 4'b0000;
                        end
                        // OR
                        3'b110:
                        begin
                            AluControl <= 4'b0001;
                        end
                        // SLT
                        3'b010:
                        begin
                            AluControl <= 4'b0111;
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
            7'b1110011 :
            begin
                AluOp <= 3'b001;
                imm <= _instruction[31:20];
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
                Branch <= 0;
                // synthesis translate_off
                $display("INSTRUÇÃO INVÁLIDA! INSTRUÇÃO INVÁLIDA!");
                // synthesis translate_on
            end
            
        endcase
    end
    
endmodule

`endif