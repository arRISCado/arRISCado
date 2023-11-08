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
    input [4:0] AluControl,     // Exact operation ALU will perform
    input in_MemWrite,          // True or False depending if the operation Writes in the Memory or not
    input Branch,              // True or False depending if the instruction is a Branch
    input in_MemRead,          // True or False depending if the operation Reads from the Memory or not
    input in_RegWrite,         // True or False depending if the operation writes in a Register or not
    input [4:0] in_RegDest,    // Determines which register to write the ALU result
    input in_MemToReg,         // True or False depending if the operation writes from the Memory into the Resgister Bank
    input in_RegDataSrc,       // Determines where the register data to be writen will come from: memory or ALU result
    input in_PCSrc,            // Determines if the PC will come from the PC+4 or from a Branch calculation
    input [2:0] in_BranchOp,       // Determines what type of branch is being done
    input [31:0] in_BranchOffset,



    // Possible Fowarding Data
    input ex_mem_RegWrite,
    input [4:0] ex_mem_RegDest,
    input [4:0] rb_read_address1,
    input [4:0] rb_read_address2,
    input [31:0] in_result,
    input mem_wb_RegWrite,
    input [4:0] mem_wb_RegDest,
    input [31:0] mem_wb_data_out,
    input [31:0] mem_wb_AluResult,
    input [31:0] rb_write_value,
    input rb_write_enable,
    input [4:0] rb_write_address,

    output reg out_MemWrite,         // True or False depending if the operation Writes in the Memory or not
    output reg out_MemRead,          // True or False depending if the operation Reads from the Memory or not
    output reg out_RegWrite,         // True or False depending if the operation writes in a Register or not
    output reg [4:0] out_RegDest,    // Determines which register to write the ALU result
    output reg out_MemToReg,         // True or False depending if the operation writes from the Memory into the Resgister Bank
    output reg out_RegDataSrc,       // Determines where the register data to be writen will come from: memory or ALU result
    output reg out_PCSrc,            // Determines if the PC will come from the PC+4 or from a Branch calculation
    output reg [31:0] out_BranchOffset,
    output reg [31:0] _rs2_value,

    output [31:0] result,
    output reg [31:0] a,
    output reg [31:0] b
);
    reg [31:0] _rs1_value, _imm, _PC;
    reg [2:0] _AluOp, _BranchOp;
    reg _AluSrc;

    reg [4:0] _AluControl;
    reg [4:0] _RegDest;
    reg _MemWrite, _MemRead, _RegWrite, _MemToReg, _RegDataSrc, _PCSrc;

    wire zero;
    wire negative;
    wire borrow;

    alu alu(_AluControl, a, b, result, zero, negative, borrow);

    localparam BEQ = 3'b000;
    localparam BNE = 3'b001;
    localparam BLT = 3'b100;
    localparam BGE = 3'b101;
    localparam BLTU = 3'b110;
    localparam BGEU = 3'b111;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            _rs1_value  <= 0;
            _rs2_value  <= 0;
            _imm        <= 0;
            _PC         <= 0;
            _AluSrc     <= 0;
            _AluOp      <= 0;
            _AluControl <= 0;

            out_MemWrite   <= 0;
            out_MemRead    <= 0;
            out_RegWrite   <= 0;
            out_RegDest    <= 0;
            out_MemToReg   <= 0;
            out_RegDataSrc <= 0;
            out_BranchOffset <= 0;
            out_PCSrc      <= 0;
        end
        else
        begin
            if(ex_mem_RegWrite && (ex_mem_RegDest != 0) && (rb_read_address1 == ex_mem_RegDest))
                _rs1_value  <= in_result;
            else if(mem_wb_RegWrite && (mem_wb_RegDest != 0) && (rb_read_address1 == mem_wb_RegDest))
                _rs1_value = mem_wb_AluResult;
            else
                _rs1_value <= rs1_value;


            if(ex_mem_RegWrite && (ex_mem_RegDest != 0) && (rb_read_address2 == ex_mem_RegDest))
                _rs2_value  <= in_result;
            else if(mem_wb_RegWrite && (mem_wb_RegDest != 0) && (rb_read_address2 == mem_wb_RegDest))
                _rs2_value = mem_wb_AluResult;
            else
                _rs2_value <= rs2_value;

            _imm        <= imm;
            _PC         <= PC;
            _AluSrc     <= AluSrc;
            _AluOp      <= AluOp;
            _AluControl <= AluControl;
            _BranchOp <= in_BranchOp;
            
            out_MemWrite   <= in_MemWrite;
            out_MemRead    <= in_MemRead;
            out_RegWrite   <= in_RegWrite;
            out_RegDest    <= in_RegDest;
            out_MemToReg   <= in_MemToReg;
            out_RegDataSrc <= in_RegDataSrc;
            out_PCSrc      <= in_PCSrc;
            out_BranchOffset <= in_BranchOffset;
        end
    end

    always @(*)
    begin
        case(_AluOp)
            // Tipo Load ou Store
            3'b000 :
            begin
                a <= rs1_value;
                b <= _imm;
            end

        // Tipo B
        3'b001 :
        begin
            a <= _rs1_value;
            b <= _rs2_value;
            case (_BranchOp)  // eu acho que é o func3
                BEQ:
                begin
                    out_PCSrc = zero && in_PCSrc;
                end
                BNE:
                begin
                    out_PCSrc = !(zero) && in_PCSrc;
                end
                BLT:
                begin
                    out_PCSrc = result[31] && in_PCSrc;
                end
                BGE:
                begin
                    out_PCSrc = !(result[31]) && in_PCSrc;
                end
                BLTU:
                begin
                    out_PCSrc = borrow && in_PCSrc;
                end
                BGEU:
                begin
                    out_PCSrc = !(borrow) && in_PCSrc;
                end
                default: 
                begin
                    $display("INSTRUÇÃO INVÁLIDA! INSTRUÇÃO INVÁLIDA!");
                end
            endcase
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
            b <= 0;
        end

        // Tipo U AUIPC
        3'b101:
        begin
            a <= _PC;
            b <= _imm;
        end

        // Tipo J
        3'b011:
        begin
            a <= _PC;
            b <= _imm;
        end

        // TODO: JALR
        3'b111:
        begin
            a <= _PC;
            b <= _imm;
        end
        default:
        begin
            a <= 0;
            b <= 0;
        end
    endcase
end    
endmodule
`endif
