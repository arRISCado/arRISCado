// Decode Stage
module decode (
    input instruction[31:0],
    input clock,
    output opcode,
    output imm,
    output rd,
    output rs1,
    output rs2,
    output func3
    output func7
);

always @(posedge clock) begin

    opcode = instruction[6:0]

    case (opcode)
        // LUI: Load Upper Immediate
        2'b0110111 : 
            begin        
                assign rd = instruction[11:7]
                assign imm = instruction[31:12]
            end
        
        // AUIPC: Add U-Immediate with PC
        2'b0010111 :
            begin
                assign rd = instruction[11:7]
                assign imm = instruction[31:12]
            end

        // JAL: Jump And Link
        2'b110111 : 
        begin
            assign rd = instruction[11:7]
            assign imm = {instruction[31], instruction[30:21], instruction[20], instruction[19:12]} 
        end

        //JARL: Jump And Link Register
        2'b1100111 :
        begin
            assign func3 = instruction[14:12]
            

            case (func3)
            2'b000 :
                begin
                    assign rd = instruction[11:7]
                    assign rs1 = instruction[19:15]
                    assign imm = instruction[31:20]
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
            assign func3 = instruction[14:12]

            assign imm = {instruction[8:11], instruction[25:30], instruction[7], instruction[31]}
            assign rs1 = instruction[25:19]
            assign rs2 = instruction[20:24]
        end

        // Instruções dos tipos de Loads: dependem do func3
        2'b0000011 :
            begin
                // Esse sinal irá indicar pra ALU/MEM qual o tipo de Load
                assign func3 = instruction[14:12]

                assign rd = instruction[11:7]
                assign rs1 = instruction[19:15]
                assign imm = instruction[31:20]
            end
        
        // Instruções pros tipos de Save: dependem do func3
        // TODO
        default: 
    endcase

end
    
endmodule
