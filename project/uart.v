// MODIFIED FROM https://learn.lushaylabs.com/tang-nano-9k-debugging

module uart
#(
    parameter DELAY_FRAMES = 234  // Delay frames expecting a 115200 Baud rate
)
(
    input clk,
    input uart_rx,
    output reg [5:0] led,
    output reg cpu_enable = 0,
    input wire [31:0] address,
    output wire [31:0] data
);

reg [31:0] memory[255:0];
reg [7:0] currentInst = 0;
reg [2:0] dataInCount = 0;
reg [7:0] fullsize = 0;

localparam HALF_DELAY_WAIT = (DELAY_FRAMES / 2);

reg [7:0] dataIn = 0;
reg [2:0] rxState = 0;
reg [12:0] rxCounter = 0;
reg [2:0] rxBitNumber = 0;

localparam RX_STATE_IDLE = 0;
localparam RX_STATE_START_BIT = 1;
localparam RX_STATE_READ_WAIT = 2;
localparam RX_STATE_READ = 3;
localparam RX_STATE_STOP_BIT = 4;

localparam ROM_WRITE_1 = 0;
localparam ROM_WRITE_2 = 1;
localparam ROM_WRITE_3 = 2;
localparam ROM_WRITE_4 = 3;
localparam RECEIVE_SIZE = 4;
localparam RECEIVE_DONE = 5;

reg [2:0] romWriteState = RECEIVE_SIZE;

always @(posedge clk) begin
    if (address <= 32'd255)
        data <= memory[address];
    else
        data <= 32'b10011;
    led[5:0] <= ~memory[0][5:0];
    case (rxState)
        RX_STATE_IDLE: begin
            if (uart_rx == 0) begin
                rxState <= RX_STATE_START_BIT;
                rxCounter <= 1;
                rxBitNumber <= 0;
            end
        end 
        RX_STATE_START_BIT: begin
            if (rxCounter == HALF_DELAY_WAIT) begin
                rxState <= RX_STATE_READ_WAIT;
                rxCounter <= 1;
            end else 
                rxCounter <= rxCounter + 1;
        end
        RX_STATE_READ_WAIT: begin
            rxCounter <= rxCounter + 1;
            if ((rxCounter + 1) == DELAY_FRAMES) begin
                rxState <= RX_STATE_READ;
            end
        end
        RX_STATE_READ: begin
            rxCounter <= 1;
            //dataIn <= {uart_rx, dataIn[7:1]};
            if(dataInCount == 0)
                dataIn = 0;
            dataIn[dataInCount] <= uart_rx;
            if(dataInCount == 7)
                dataInCount = 0;
            else
                dataInCount = dataInCount + 1;
            rxBitNumber <= rxBitNumber + 1;
            if (rxBitNumber == 3'b111)
                rxState <= RX_STATE_STOP_BIT;
            else
                rxState <= RX_STATE_READ_WAIT;
        end
        RX_STATE_STOP_BIT: begin
            rxCounter <= rxCounter + 1;
            if ((rxCounter + 1) == DELAY_FRAMES) begin
                rxState <= RX_STATE_IDLE;
                rxCounter <= 0;
                case(romWriteState)
                    RECEIVE_SIZE: begin
                        fullsize[7:0] = dataIn[7:0];
                        romWriteState <= ROM_WRITE_1;
                    end
                    ROM_WRITE_1: begin
                        memory[currentInst][31:24] <= dataIn[7:0];
                        romWriteState <= ROM_WRITE_2;
                    end
                    ROM_WRITE_2: begin
                        memory[currentInst][23:16] <= dataIn[7:0];
                        romWriteState <= ROM_WRITE_3;
                    end
                    ROM_WRITE_3: begin
                        memory[currentInst][15:8] <= dataIn[7:0];
                        romWriteState <= ROM_WRITE_4;
                    end
                    ROM_WRITE_4: begin
                        memory[currentInst][7:0] <= dataIn[7:0];
                        currentInst = currentInst + 1;
                        if(currentInst == fullsize) begin
                            cpu_enable = 1;
                            romWriteState <= RECEIVE_DONE;
                        end
                        else
                            romWriteState <= ROM_WRITE_1;
                    end
                endcase
            end
        end
    endcase
end

initial begin
    $readmemh(`UART_FILE, memory, 0, 255);
    led[5:0] <= 6'b111111;
end


endmodule