module divider(
    input           clk,
    input           reset,
    input [31:0]    dividend,
    input [31:0]    divisor,

    output [31:0]   Q,
    output [31:0]   R,
    output          ready // 1 quando a divisão estiver completa será usado como stall
);

    reg [31:0] _Q;

    reg [63:0] dividend_copy, divisor_copy, diff;

    wire [31:0] remainder = dividend_copy[31:0];

    reg [63:0] bit;
    initial bit = 0;

    assign ready = !bit;

    assign Q = _Q;

    always @ (posedge clk) 
        begin
            if (ready)
            begin
                bit = 32;
                _Q = 0;
                dividend_copy = {32'b0, dividend};
                divisor_copy = {1'b0, divisor, 31'b0};
            end
            else
            begin
                diff = dividend_copy - divisor_copy;

                _Q = _Q << 1;

            if(!diff[63])
            begin
                dividend_copy = diff;
                _Q[0] = 1'd1;
            end

            divisor_copy= divisor_copy >> 1;
            bit = bit - 1;
            end
        end

    assign R = remainder;

endmodule
