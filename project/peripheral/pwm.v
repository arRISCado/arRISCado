//PWM port
//
//PWM modulates the output to make appear it's an analog signal
//It keeps the output on for a % of a duty cycle, and repeat it at each cycle  

module pwm_port(
    input clk; //Main clk
    input mem_write; //If the data from memory changed
    input [31:0] mem_data; //Data from memory
    output reg port_out; //The port output
)
    //Checar se parâmetro com tamanho funciona    
    parameter [31:0] clk_per_cycle = 10; //Number of clk in one duty cycle 

    reg [31:0] clk_on = 1'd0; //Number of cycles to keep on
    reg [31:0] clk_off = 1'd0; //Number of cycles to keep off
    reg [31:0] counter = 1'd0; //Number of clk that passed

    //PWM keeps on for clk_on cycles 
    //clk_on = max(mem_data, clk_per_cycle)
    //clk_off = clk_per_cycle - clk_on

    //Update data from mmemory
    always @(posedge mem_write) begin
        if(clk_per_cycle > mem_data)
            clk_on <= clk_per_cycle;
        else
            clk_on <= mem_data;
        
        clk_off = clk_per_cycle - clk_on;
    end

    //Update the port output
    always @(posedge clk) begin
        if counter > clk_per_cycle
            counter <= 32'd0;

        if counter > clk_on
            port_out <= 0
        else
            port_out <= 1
    end

endmodule