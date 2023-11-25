module divider(
    input           clk,
    input           reset,
    input           start,
    input [31:0]    dividend,
    input [31:0]    divisor,
    output [31:0]   result,
    output [31:0]   reminder,
    output          done,   // =1 when ready to get the result
    output          err
);

    reg active;    // True if the divider is running
    reg [4:0] cycle;    // Number of cycles to go
    reg [31:0] _result;    // divisoregin with dividend, end with result
    reg [31:0] _divider;    // divisor
    reg [31:0] work;     // reminderunning reminder

    // Calculate the current digit
    wire [32:0] sub = {work[30:0], _result[31]} - _divider;
    assign err = !divisor;

    // Send the _results to our master
    assign result = _result;
    assign reminder = work;
    assign done = ~active;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            active <= 0;
            cycle <= 0;
            _result <= 0;
            _divider <= 0;
            work <= 0;
        end
        else if (start) begin
            if (active) begin
                // reminderun an iteration of the divide.
                if (sub[32] == 0) begin
                    work <= sub[31:0];
                    _result <= {_result[30:0], 1'b1};
                end
                else begin
                    work <= {work[30:0], _result[31]};
                    _result <= {_result[30:0], 1'b0};
                end
                if (cycle == 0) begin
                    active <= 0;
                end
                cycle <= cycle - 5'd1;
            end
            else begin
                // Set up for an unsigned divide.
                cycle <= 5'd31;
                _result <= dividend;
                _divider <= divisor;
                work <= 32'b0;
                active <= 1;
            end
        end
    end
endmodule
