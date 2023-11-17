//PWM port
//
//PWM modulates the output to make appear it's an analog signal
//It keeps the output on for a % of a duty cycle, and repeat it at each cycle  

`ifndef PWM
`define PWM

module pwm_port(
    input clk, //Main clk
    input mem_write, //If the data from memory changed
    input mem_write2, //If the data from memory changed
    input [31:0] mem_data, //Data from memory: cycles on
    input [31:0] mem_data2, //Data from memory: cycles in one duty cycle
    output port_output //The port output
);
    //Number of clk in one duty cycle
    //More clk in one duty cycle gives more resolution, but it worsens the perception of an analog signal
    reg [31:0] clk_per_cycle = 32'd1024;  

    //reg [31:0] clk_on = 32'd0; //Number of cycles to keep on
    reg [31:0] counter = 32'd0; //Number of clk that passed

    reg [31:0] last_mem_data = 32'd0;
    
    reg [31:0] clk_on = 32'd0;
    

    //PWM keeps on for clk_on cycles 
    //clk_on = max(mem_data, clk_per_cycle)
    //clk_off = clk_per_cycle - clk_on

    //Update data from memory
    always @(posedge mem_write) begin
        last_mem_data = mem_data;
    end

    always @(posedge mem_write2) begin
        clk_per_cycle = mem_data2;
    end

    //Update clk_on and counter
    always @(posedge clk) begin
        //Update clk_on

        if(last_mem_data>clk_per_cycle) begin
            clk_on = clk_per_cycle;
        end
        else begin
            clk_on = last_mem_data;
        end

        //Update counter
        if(counter >= clk_per_cycle) begin
            counter = 32'd0;
        end
        
        counter = counter + 32'd1;
    end

    //Update the port output
    assign port_output = (counter >= clk_on) ? 0 : 1;

endmodule

`endif