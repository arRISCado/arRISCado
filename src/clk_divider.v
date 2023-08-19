module Clk_divider(clk_in, clk_out);
    parameter n_bit = 32;
    parameter [n_bit-1 : 0] divisor = 3'd2;
    input clk_in;
    output reg clk_out;
    reg [n_bit-1:0] counter = 1'd0;

    always @(posedge clk_in) begin
        count <= count + n_bit'd1;

        if(counter >= divisor-1)
            counter <= n_bit'd0;

        if (counter < divisor/2)
            clk_out <= 1'b1;
        else
            clk_out <= 1'b0;
    end


endmodule