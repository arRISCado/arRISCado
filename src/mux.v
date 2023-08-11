module Mux(select, in1, in2, out);
    parameter n = 1;
    input select;
    input [n-1:0] in1, in2;
    output reg [n-1:0] out;
    integer i;

    always @(select, in1, in2) begin
        if(select == 0)
            for(i = 0; i<n; i++) begin
                out[i] <= in1[i];
            end
        else
            for(i = 0; i<n; i++) begin
                out[i] <= in2[i];
            end
    end
endmodule