// Multicycle Divider

module divider(
  input [31:0] dividend,
  input [31:0] divisor,
  output reg [31:0] quotient,
  output reg [31:0] remainder,
  output reg done
);

  reg [31:0] p1;
  reg [31:0] count;
  reg [31:0] d1, d2;
  integer i;

  always @(dividend or divisor)
    begin
    done = 0;
    d1 = dividend;
    d2 = divisor;
    p1 = 0;
    for(i = 0; i < 32; i=i+1)
      begin
        p1 = {p1[30:0], d1[31]};
        d1[31:1] = d1[30:0];
        p1 = p1 - d2;
        
        if(p1[31] == 1)
          begin
            d1[0] = 0;
            p1 = p1+d2;
          end
          else
            d1[0] = 1;
      end
      remainder = p1;
      quotient = d1;
      done = 1;
    end

endmodule
