//PWM port
//
//PWM modulates the output to make appear it's an analog signal
//It keeps the output on for a % of a duty cycle, and repeat it at each cycle  

`ifndef PWM
`define PWM

module pwm_port(
    input clk, //Main clk
    input physical_clk, // Real FPGA clock for pulse generation
    input mem_write, //If the data from memory changed
    input mem_write2, //If the data from memory changed
    input [31:0] mem_data, //Data from memory: cycles on
    input [31:0] mem_data2, //Data from memory: cycles in one duty cycle
    output [5:0] debug_led, //LEDs for debugging
    output port_output //The port output
);

    assign debug_led[5] = clk;
    assign debug_led[4] = port_output;
    assign debug_led[3] = ~mem_write;
    assign debug_led[2] = ~mem_write2;
    assign debug_led[1] = (clk_per_cycle == 32'd10) ? 0 : 1; //mem_data2, clk_per_cycle
    //assign debug_led[1] = (last_mem_data == 32'd5) ? 0 : 1;
    assign debug_led[0] = (clk_on == 32'd5) ? 0 : 1; //mem_data, clk_on, last_mem_data
    

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


    always @(posedge clk) begin
        //Update data from memory
        if(mem_write) begin
            last_mem_data = mem_data;
        end

        if(mem_write2) begin
            clk_per_cycle = mem_data2;
        end

        //Update clk_on
        if(last_mem_data>clk_per_cycle) begin
            clk_on = clk_per_cycle;
        end
        else begin
            clk_on = last_mem_data;
        end
    end

    always @(posedge physical_clk) begin
        //Update counter
        if(counter >= clk_per_cycle) begin
            counter = 32'd0;
        end
        
        counter = counter + 32'd1;
    end

    //Update the port output
    assign port_output = (counter > clk_on) ? 0 : 1;

endmodule

`endif