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
    // output reg [31:0] _rs2_value,
    output [31:0] _rs2_value,

    output [31:0] result,
    output reg [31:0] a,
    output [31:0] b
);
    reg [31:0] _rs1_value, _imm, _PC;
    reg [2:0] _AluOp;
    reg _AluSrc;

    reg [3:0] _AluControl;
    reg [4:0] _RegDest;
    reg _MemWrite, _MemRead, _RegWrite, _MemToReg, _RegDataSrc, _PCSrc;

    wire zero;
    alu alu(_AluControl, a, b, result, zero);

    assign _rs2_value = rs2_value;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            _rs1_value <= 0;
            // _rs2_value <= 0;
            _imm <= 0;
            _PC <= 0;
            _AluSrc <= 0;
            _AluOp <= 0;
            _AluControl <= 0;
        end
        else
        begin
            _rs1_value <= rs1_value;
            // _rs2_value <= rs2_value;
            _imm <= imm;
            _PC <= PC;
            _AluSrc <= AluSrc;
            _AluOp <= AluOp;
            _AluControl <= AluControl;
            
            out_MemWrite <= in_MemWrite;
            out_MemRead <= in_MemRead;
            out_RegWrite <= in_RegWrite;
            out_RegDest <= in_RegDest;
            out_MemToReg <= in_MemToReg;
            out_RegDataSrc <= in_RegDataSrc;
            out_PCSrc <= in_PCSrc;
        end
    end

    assign b = DataSrc == 'b00 ? imm : 
               DataSrc == 'b01 ? rs2_value :
               DataSrc == 'b10 ? AluSrcValue : 12;

    wire [31:0] AluSrcValue;
    assign AluSrcValue = _AluSrc ? _imm : rs2_value;

    reg [2:0] DataSrc = 0;
    // 00 = imm
    // 01 = rs2_value
    // 10 = AluSrcValue
    // 11 = 12
    
    always @(*)
    begin
        case(AluOp)
            // Tipo Load ou Store
            3'b000 :
            begin
                a <= rs1_value;
                // b <= imm;
                DataSrc <= 'b00;
            end

            // Tipo B
            3'b001 :
            begin
                a <= rs1_value;
                // b <= rs2_value;
                DataSrc <= 'b01;
            end

            // Tipo R OU I
            3'b010 :
            begin
                a <= rs1_value;
                // b <= (_AluSrc ? _imm : _rs2_value);
                DataSrc <= 'b10;
            end

            // Tipo U LUI
            3'b100:
            begin
                a <= imm;
                // b <= 12;
                DataSrc <= 'b11;
            end

            // Tipo U AUIPC
            3'b101:
            begin
                a <= PC;
                // b <= imm;
                DataSrc <= 'b00;
            end

            // Tipo J
            3'b011:
            begin
                a <= PC;
                DataSrc <= 'b00;
            end

            // TODO: JALR
            3'b111:
            begin
                a <= PC;
                DataSrc <= 'b00;
            end

            default:
            begin
                a <= 0;
                DataSrc <= 'b00;
            end
        endcase
    end
endmodule

`endif