module Bar_mem_wb(step_clk, 
                read_data_in, read_data_out,
                alu_result_in, alu_result_out,
                write_reg_in, write_reg_out,
                wb_in, wb_out);

    input step_clk;
    
    input [31:0]  read_data_in;
    output reg [31:0] read_data_out;

    input [31:0]  alu_result_in;
    output [31:0] alu_result_out;

    input [3:0] write_reg_in;
    output[3:0] write_reg_out;

    input [1:0] wb_in;
    output [1:0] wb_out;

    always @(posedge step_clk)
    begin
        read_data_out <= read_data_in;
    end

    Register read_data(step_clk, read_data_in, 1, read_data_out);
    defparam read_data.n = 32;

    Register alu_result(step_clk, alu_result_in, 1, alu_result_out);
    defparam alu_result.n = 32;

    Register write_reg(step_clk, write_reg_in, 1, write_reg_out);
    defparam write_reg.n = 64;

    Register wb(step_clk, wb_in, 1, wb_out);
    defparam wb.n = 2;

endmodule