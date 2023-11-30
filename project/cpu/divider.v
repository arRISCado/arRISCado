module divider (
  input clk,
  input reset,

  input [31:0] dividend,
  input [31:0] divisor,

  output [31:0] Q,
  output [31:0] R,
  output ready
);
  localparam IDLE = 'b0;
  localparam DOING = 'b1;

  assign ready = state;
  reg [31:0] p_a = 0;
  reg [31:0] p_b = 0; 
  reg [63:0] inner_a, inner_b, diff;
  reg [31:0] inner_q = 0;

  reg state;
  initial state = 0;
  reg [6:0] bit = 32;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      // Reset logic here
    end
    else begin
      case (state)
        IDLE: begin
          if ((p_a != dividend) || (p_b != divisor)) begin
            state = DOING;
            p_a = dividend;
            p_b = divisor;
            inner_a  = {32'b0, dividend};
            inner_b = {1'b0, divisor, 31'b0};
            bit = 33;
            inner_q = 0;
          end
        end
        DOING: begin
            diff = inner_a - inner_b;
            inner_q = inner_q << 1;

            if(!diff[63])
            begin
                inner_a = diff;
                inner_q[0] = 1'd1;
            end

            inner_b = inner_b >> 1;
            bit = bit - 1;
          
          if (bit <= 1) begin
            state <= IDLE;
          end
        end
      endcase
    end
  end
  assign Q = inner_q;
  assign R = inner_a;
endmodule;