module jdoodle;
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
        
        $display("x %b", o);
        w <= 1;
        
        clk <= 1;
        #50;
        
        $display("0 %b", o);
        i <= 1;
        
        clk <= 0;
        #50;
        
        $display("0 %b", o);
        
        clk <= 1;
        #50;
        
        $display("1 %b", o);
        w <= 0;
        i <= 0;
        
        clk <= 0;
        #50;
        clk <=1;
        #50;
        
        $display("1 %b", o);
        
        
        $finish;
    end
endmodule