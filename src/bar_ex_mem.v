`include "register.v"

module Bar_ex_mem(step_clk, 
                branch_target_in, branch_target_out,
                alu_result_in, alu_result_out,
                alu_zero_in, alu_zero_out,
                read_data2_in, read_data2_out,
                write_reg_in, write_reg_out,
                wb_in, wb_out,
                m_in, m_out);

    input step_clk;
    
    input [63:0]  branch_target_in;
    output [63:0] branch_target_out;

    input [31:0]  alu_result_in;
    output [31:0] alu_result_out;

    input  alu_zero_in;
    output alu_zero_out;

    input [31:0]  read_data2_in;
    output [31:0] read_data2_out;

    input [3:0] write_reg_in;
    output[3:0] write_reg_out;

    input [1:0] wb_in, [2:0] m_in;
    output [1:0] wb_out, [2:0] m_out;

    Register branch_target(step_clk, branch_target_in, 1, branch_target_out);
    branch_target.n = 64;

    Register alu_result(step_clk, alu_result_in, 1, alu_result_out);
    alu_result.n = 32;

    Register alu_zero(step_clk, alu_zero_in, 1, alu_zero_out);
    alu_zero.n = 32;

    Register read_data_2(step_clk, read_data2_in, 1, read_data2_out);
    read_data_2.n = 32;

    Register write_reg(step_clk, write_reg_in, 1, write_reg_out);
    write_reg.n = 64;

    Register wb(step_clk, wb_in, 1, wb_out);
    wb.n = 2;

    Register m(step_clk, m_in, 1, m_out);
    m.n = 3;

endmodule