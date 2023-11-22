// Multicycle Divider

module divider(
  input clk,
  input div_op,
  input [31:0] dividend,
  input [31:0] divisor,
  output reg [31:0] quotient,
  output reg [31:0] remainder,
  output reg busy = 0
);

  reg [31:0] count;
  reg [31:0] a, b;
  reg [31:0] q, r;

  always @(posedge clk && div_op)
    begin
        if(div_op && ~busy)
        begin
            busy = 1;
            count = 0;
            a = 32'b0;
            b = divisor;
            q = 32'b0;
            r = dividend;
        end
        else 
        begin
            count = count+1;
            a = {a, dividend[32-count]};
            if (a >= b)
            begin
                q = q << 1;
                q = q+1;
                a = a-b;
                r = a;
            end
            else
            begin
                q = q << 1;
                r = a;
            end
            
            if(count == 32)
            begin
                busy = 0;
                quotient = q;
                remainder = r;
            end
        end
    end

endmodule
