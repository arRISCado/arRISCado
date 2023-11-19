module cache (
  input clk,
  input reset,

  // CPU
  input [31:0] address,
  input [31:0] data_in,
  input write_enable,
  output reg data_ready = 0,
  output reg [31:0] data_out = 0,

  // Memory Bus
  output reg [31:0] fetch_address,
  output reg [31:0] fetch_write_data,
  output reg        fetch_write_enable,
  input      [31:0] fetch_read_data
);
  localparam IDLE   = 'b00;
  localparam READ   = 'b01;
  localparam WRITE  = 'b10;

  reg [1:0] current_state, next_state;
  reg [31:0] previous_address = 'hffffff;

  reg [26:0] tag  [4:0];
  reg [31:0] data [4:0];
  reg       valid [4:0]; // TODO: Create channel to invalid positons, like when DCache changes something in ICache

  wire [4:0] addr_tag = address[4:0];
  wire [26:0] addr_index = address[31:5];

  always @(posedge clk or posedge reset)
  begin
    if (reset)
    begin
      current_state <= IDLE;
    end
    else
    begin
      current_state <= next_state;
    end
  end

  always @(posedge clk)
  begin
    case (current_state)
      IDLE:
      begin
        fetch_write_enable <= 0;
        if (address != previous_address)
          // TODO: Check for peripherals
          if (write_enable)
            next_state <= WRITE;
          else
            next_state <= READ;
        previous_address <= address;
      end
      READ:
      begin
        if (address[1:0] == 'b00)
        begin
          if (tag[addr_index] == addr_tag && valid[addr_index])
          begin
            data_out <= data[addr_index];
            data_ready <= 1;
            next_state <= IDLE;
          end
          else
          begin
            if (fetch_address == address)
            begin
              data [addr_index] <= fetch_read_data;
              tag  [addr_index] <= addr_tag;
              valid[addr_index] <= 1;
              data_ready        <= 1;
              next_state  <= IDLE;
            end
            else
            begin
              fetch_address <= address;
              data_ready <= 0;
              next_state <= READ;
            end
          end
        end
        else
        begin
          // MISALIGNED
        end
      end
      WRITE:
      begin
        if (address[1:0] == 'b00)
        begin
          data [addr_index] <= data_in;
          tag  [addr_index] <= addr_tag;
          valid[addr_index] <= 1;
          
          fetch_write_data   <= data_in;
          fetch_write_enable <= 1;
          fetch_address      <= address;

          next_state <= IDLE;
        end
        else
        begin
          // MISALIGNED
        end
      end
      default: next_state <= IDLE;
    endcase
  end
endmodule
