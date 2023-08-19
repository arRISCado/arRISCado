module test_register;
    reg clk;
    reg i;
    wire o;
    reg w;
    
    Register reg1(clk, i, w, o);
    defparam reg1.n = 1;

    initial begin
        
        w <= 0;
        i <= 0;
        
        clk <= 0;
        #50;
        
        // $display("x %0b", o);
        w <= 1;
        
        clk <= 1;
        #50;
        
        // $display("0 %0b", o);
        i <= 1;
        
        clk <= 0;
        #50;
        
        // $display("0 %0b", o);
        
        clk <= 1;
        #50;
        
        // $display("1 %0b", o);
        w <= 0;
        i <= 0;
        
        clk <= 0;
        #50;
        clk <=1;
        #50;
        
        // $display("1 %0b", o);
        
        
        // $finish;
    end
endmodule
