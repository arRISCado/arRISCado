`ifndef BUTTONS
`define BUTTONS

module buttons(
    input clk, //Main clk
    input btn1,
    input btn2,
    input read_btn1,
    input read_btn2,
    output reg [31:0] buttons_output, //The output from the buttons
    output [5:0] debug_led
);

assign debug_led[5] = btn1_counter[0];
assign debug_led[4] = btn2_counter[0];
assign debug_led[3:0] = 3'd0;

reg [31:0] btn1_counter = 32'd0;
reg [31:0] btn2_counter = 32'd0;

`ifdef TESTBENCH
initial begin
    btn1_counter <= 32'd6348;
    btn2_counter <= 32'd123456;
end
`endif


always @(posedge btn1) begin
    btn1_counter <= btn1_counter+1;
end

always @(posedge btn2) begin
    btn2_counter <= btn2_counter+1;
end

always @(posedge clk) begin
    if(read_btn1) begin
        buttons_output <= btn1_counter;
    end
    
    if(read_btn2) begin
        buttons_output <= btn2_counter;
    end

end

endmodule

`endif