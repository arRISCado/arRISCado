module Processor(clk,
    mem_addr, mem_w_data, mem_r_data, mem_w_enable, mem_r_enable);

    input clk;

    output [31:0] mem_addr;
    output [31:0] mem_w_data;
    input  [31:0] mem_r_data;
    output mem_w_enable;
    output mem_r_enable;


    wire step_clk;

    wire [63:0] mem_branch_target;
    wire [63:0] if_pc;
    wire [31:0] if_instr;

    wire [63:0] id_pc; //Ligar no ID
    wire [31:0] id_instr; //Ligar no ID

    wire mem_alu_zero;
    wire [31:0] mem_alu_result;
    wire mem_read_data_2;
    wire mem_m;
    wire mem_pc_src;

    wire id_wb; //Ligar no ID 
    wire id_m; //Ligar no ID
    wire id_ex; //Ligar no ID
    

    wire ex_wb; //Ligar no EX
    wire ex_m; //Ligar no EX
    wire ex_ex; //Ligar no EX
    
    wire [31:0] mem_read_data;
    wire [31:0] mem_alu_result;
    wire [3:0] mem_write_reg;
    wire [1:0] mem_wb;

    wire [31:0] wb_read_data;
    wire [31:0] wb_alu_result;
    wire [1:0] wb_wb;
    wire [31:0] wb_write_data; //Ligar no ID
    wire [3:0] wb_write_reg; //Ligar no ID

    Clk_generator clk_generator(clk);
    Clk_divider clk_divider(clk, step_clk);
    clk_divider.n_bit = 3;
    clk_divider.divisor = 4'd4; //1 clk = lê 1 byte -> min 4 clk ??

    Stage_if stage1_if(clk, step_clk, mem_branch_target, mem_pc_src, if_pc, if_instr,
        mem_addr, mem_w_data, mem_r_data, mem_w_enable, mem_r_enable);
    
    Bar_if_id bar1_if_id(step_clk, if_pc, id_pc, if_instr, id_instr);

    //ID

    //Substituir tudo que tem ?
    Bar_id_ex bar2_id_ex(step_clk, pc_in, pc_out, 
                ?read_data1_in, ?read_data1_out, 
                ?read_data2_in, ?read_data2_out,
                ?imm_in, ?imm_out,
                ?alu_op_in, ?alu_op_out,
                ?write_reg_in, ?write_reg_out,
                id_wb, ex_wb,
                id_m, ex_m,
                id_ex, ex_ex);


    //EX

    Bar_ex_mem bar3_ex_mem(step_clk, 
                ?alu_result_in, mem_alu_result,
                ?alu_zero_in, mem_alu_zero,
                ?read_data2_in, mem_read_data_2,
                ?write_reg_in, mem_write_reg,
                ex_wb, mem_wb,
                ex_m, mem_m);

    Stage_mem stage4_mem(clk, step_clk, mem_alu_zero, mem_alu_result, mem_read_data_2, mem_m, mem_read_data, mem_pc_src,
        mem_addr, mem_w_data, mem_r_data, mem_w_enable, mem_r_enable);
    
    Bar_mem_wb bar4_mem_wb(step_clk, 
                mem_read_data, wb_read_data,
                mem_alu_result, wb_alu_result,
                mem_write_reg, wb_write_reg,
                mem_wb, wb_wb);

    Stage_wb stage5_wb(clk, step_clk, wb_read_data, wb_alu_result, wb_wb, wb_write_data);

endmodule
*/
