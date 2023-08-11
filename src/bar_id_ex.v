`include "bar_if_id.v"

module Bar_id_ex(step_clk, pc_in, pc_out, 
                read_data1_in, read_data1_out, 
                read_data2_in, read_data2_out,
                imm_in, imm_out,
                wb_in, wb_out,
                m_in, m_out,
                ex_in, ex_out);

    input step_clk;
    
    input [63:0] pc_in;
    output[63:0] pc_out;

    input [31:0] read_data1_in, read_data2_in;
    output [31:0] read_data1_out, read_data2_out;

    input [63:0] imm_in;
    output[63:0] imm_out;

    Register pc(step_clk, pc_in, 1, pc_out);
    pc.n = 64;

    Register read_data_1(step_clk, read_data1_in, 1, read_data1_out);
    read_data_1.n = 32;

    Register read_data_2(step_clk, read_data2_in, 1, read_data2_out);
    read_data_2.n = 32;

    Register imm(step_clk, imm_in, 1, imm_out);
    pc.n = 64;

    Register wb(step_clk, wb_in, 1, wb_out);
    wb.n = 1;

    Register ex(step_clk, ex_in, 1, ex_out);
    ex.n = 1;

endmodule