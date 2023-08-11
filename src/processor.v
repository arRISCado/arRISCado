module Processor();

    wire clk;
    wire step_clk;

    wire [63:0] mem_branch_target;
    wire mem_pc_src;
    wire [63:0] if_pc;
    wire [31:0] if_instr;

    wire [63:0] id_pc; //Ligar no ID
    wire [31:0] id_instr; //Ligar no ID

    Stage_if stage1_if(clk, step_clk, mem_branch_target, mem_pc_src, if_pc, if_instr);
    Bar_if_id bar1_if_id(step_clk, if_pc, id_pc, if_instr, id_instr);


endmodule