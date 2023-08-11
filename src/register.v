module Register(clk, in, w_enable, out);
    parameter n = 1;
    input clk, w_enable;
    input [n-1:0] in;
    output reg [n-1:0] out;
    
    integer i;

    always @(posedge clk) begin
        if(w_enable)
            for(i = 0; i<n; i++) begin
                out[i] <= in[i];
            end
    end

endmodule