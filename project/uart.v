// MODIFIED FROM https://learn.lushaylabs.com/tang-nano-9k-debugging
//`default_nettype none

module uart
#(
    parameter DELAY_FRAMES = 234  // Delay frames expecting a 115200 Baud rate
)
(
    input clk,
    input uart_rx,
    output reg [5:0] led,
    output reg cpu_enable = 0
);


localparam HALF_DELAY_WAIT = (DELAY_FRAMES / 2);

reg [7:0] dataIn = 0;
reg [2:0] rxState = 0;
reg [12:0] rxCounter = 0;
reg [2:0] rxBitNumber = 0;
reg byteReady = 0;

localparam RX_STATE_IDLE = 0;
localparam RX_STATE_START_BIT = 1;
localparam RX_STATE_READ_WAIT = 2;
localparam RX_STATE_READ = 3;
localparam RX_STATE_STOP_BIT = 4;

always @(posedge clk) begin
    case (rxState)
        RX_STATE_IDLE: begin
            if (uart_rx == 0) begin
                rxState <= RX_STATE_START_BIT;
                rxCounter <= 1;
                rxBitNumber <= 0;
                byteReady <= 0;
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
            dataIn <= {uart_rx, dataIn[7:1]};
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
                byteReady <= 1;
            end
        end
    endcase
end


reg [31:0] memory[255:0];
localparam currentInst = 0;

initial begin
    repeat (256) begin
        memory[currentInst] <= 32'b00000000000100000000000000010011;
        currentInst = currentInst + 1;
    end
    currentInst = 0;
end

reg [2:0] romWriteState = 0;
reg [31:0] instructionBits = 0;

localparam ROM_WRITE_1 = 0;
localparam ROM_WRITE_2 = 1;
localparam ROM_WRITE_3 = 2;
localparam ROM_WRITE_4 = 3;
integer fullbits = 32'b11111111111111111111111111111111;

always @(posedge clk) begin
    if (byteReady) begin
        // Should be changed to use byte transmitted for something
        // Currently changes LEDs for testing purposes
        led[5:2] <= ~dataIn[5:2];
        led[1] <= ~byteReady;
        led[0] <= ~cpu_enable;
        case(romWriteState)
            ROM_WRITE_1: begin
                instructionBits[7:0] <= data_in[7:0];
                romWriteState <= ROM_WRITE_2;
            end
            ROM_WRITE_2: begin
                instructionBits[15:8] <= data_in[7:0];
                romWriteState <= ROM_WRITE_3;
            end
            ROM_WRITE_3: begin
                instructionBits[23:16] <= data_in[7:0];
                romWriteState <= ROM_WRITE_4;
            end
            ROM_WRITE_4: begin
                instructionBits[31:24] <= data_in[7:0];
                //cpu_enable = 1;
                if(instructionBit[31:0] == fullbits) begin
                    cpu_enable = 1;
                end
                else begin
                    memory[currentInst] <= instructionBits;
                    currentInst = currentInst + 1;
                end
                romWriteState <= ROM_WRITE_1;
            end
        endcase
    end
end

endmodule