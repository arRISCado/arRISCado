module test_mux;
    reg s;
    
    reg [1:0] i1_1, i2_1;
    wire [1:0] o1;
    
    reg i1_2, i2_2;
    wire o2;
    

    Mux mux1 (s, i1_1, i2_1, o1);
    defparam mux1.n = 2;
    
    Mux mux2 (s, i1_2, i2_2, o2);
    defparam mux2.n = 1;

    initial begin
        s = 0;
        i1_1[0] = 0;
        i1_1[1] = 0;
        
        i2_1[0] = 0;
        i2_1[1] = 1;
        
        i1_2 = 0;
        i2_2 = 1;
        
        #50;
        // $display("o1 = %b", o1);
        // $display("o2 = %b", o2);
        
        // $finish;
    end
endmodule