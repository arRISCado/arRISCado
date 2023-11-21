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

  wire [4:0]  addr_index = address[4:0];
  wire [26:0] addr_tag   = address[31:5];
  
  reg incomplete;

  always @(posedge clk or posedge reset)
  begin
    if (reset)
      current_state <= IDLE;
    else
      current_state <= next_state;
  end

  always @(posedge clk)
  begin
    case (current_state)
      IDLE:
      begin
        data_ready <= 0;
        fetch_write_enable <= 0;
        if (address != previous_address)
          if (write_enable)
            next_state <= WRITE;
          else
            next_state <= READ;
        previous_address <= address;
      end
      READ:
      begin
        if (~incomplete)
        begin
          if (tag[{addr_index[4:2], 2'b00}] == addr_tag && valid[{addr_index[4:2], 2'b00}])
          begin
            case (address[1:0])
              2'b01:
              begin
                data_out <= {8'b0, data[{addr_index[4:2], 2'b00}][31:8]};
                data_ready <= 0;
                incomplete   <= 1;
              end
              2'b10:
              begin
                data_out <= {16'b0, data[{addr_index[4:2], 2'b00}][31:16]};
                data_ready <= 0;
                incomplete   <= 1;
              end
              2'b11:
              begin
                data_out <= {24'b0, data[{addr_index[4:2], 2'b00}][31:24]};
                data_ready <= 0;
                incomplete   <= 1;
              end
              default:
              begin
                data_out   <= data[{addr_index[4:2], 2'b00}];
                data_ready <= 1;
                next_state <= IDLE;
              end
            endcase
          end
          else
          begin
            if (fetch_address == {address[31:2], 2'b00})
            begin
              data [{addr_index[4:2], 2'b00}] <= fetch_read_data;
              tag  [{addr_index[4:2], 2'b00}] <= addr_tag;
              valid[{addr_index[4:2], 2'b00}] <= 1;
              case (address[1:0])
                2'b01:
                begin
                  data_out   <= {8'b0, fetch_read_data[31:8]};
                  data_ready <= 0;
                  incomplete <= 1;
                end
                2'b10:
                begin
                  data_out   <= {16'b0, fetch_read_data[31:16]};
                  data_ready <= 0;
                  incomplete <= 1;
                end
                2'b11:
                begin
                  data_out   <= {24'b0, fetch_read_data[31:24]};
                  data_ready <= 0;
                  incomplete <= 1;
                end
                default:
                begin
                  data_out   <= fetch_read_data;
                  data_ready <= 1;
                  next_state <= IDLE;
                end
              endcase
            end
            else
            begin
              fetch_address <= {address[31:2], 2'b00};
              data_ready    <= 0;
            end
          end
        end
        else
        begin
          if (tag[{addr_index[4:2] + 1, 2'b00}] == addr_tag && valid[{addr_index[4:2] + 1, 2'b00}])
          begin
            case (address[1:0])
              2'b01:
              begin
                data_out   <= {data[{addr_index[4:2] + 1, 2'b00}][7:0], data_out[23:0]};
                data_ready <= 1;
                incomplete <= 0;
              end
              2'b10:
              begin
                data_out   <= {data[{addr_index[4:2] + 1, 2'b00}][15:0], data_out[15:0]};
                data_ready <= 1;
                incomplete <= 0;
              end
              2'b11:
              begin
                data_out   <= {data[{addr_index[4:2] + 1, 2'b00}][23:0], data_out[7:0]};
                data_ready <= 1;
                incomplete <= 0;
              end
              default:
              begin
                // synthesis translate_off
                $display("Unexpected cache error.");
                // synthesis translate_on
              end
            endcase
          end
          else
          begin
            if (fetch_address == {address[31:2] + 1, 2'b00})
            begin
              data [addr_index] <= fetch_read_data;
              tag  [addr_index] <= addr_tag;
              valid[addr_index] <= 1;
              case (address[1:0])
                2'b01:
                begin
                  data_out   <= {fetch_read_data[7:0], data_out[23:0]};
                  data_ready <= 1;
                  incomplete <= 0;
                end
                2'b10:
                begin
                  data_out   <= {fetch_read_data[15:0], data_out[15:0]};
                  data_ready <= 1;
                  incomplete <= 0;
                end
                2'b11:
                begin
                  data_out   <= {fetch_read_data[23:0], data_out[7:0]};
                  data_ready <= 1;
                  incomplete <= 0;
                end
                default:
                begin
                  // synthesis translate_off
                  $display("Unexpected cache error.");
                  // synthesis translate_on
                end
              endcase
            end
            else
            begin
              fetch_address <= {address[31:2] + 1, 2'b00};
              data_ready    <= 0;
            end
          end
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
