module cache (
  input clk,
  input reset,

  // CPU
  input [31:0] address,
  input [31:0] data_in,
  input write_enable,
  input read_enable,
  output reg data_ready = 0,
  output reg [31:0] data_out = 0,

  // Memory Bus
  output reg [31:0] fetch_address = 0,
  output reg [31:0] fetch_write_data = 0,
  output reg        fetch_write_enable = 0,
  input      [31:0] fetch_read_data
);
  localparam IDLE  = 'b00;
  localparam READ  = 'b01;
  localparam WRITE = 'b10;

  reg [1:0] current_state;

  reg [26:0] tag  [4:0];
  reg [31:0] data [4:0];
  reg        valid [4:0]; // TODO: Create channel to invalid positons, like when DCache changes something in ICache
  reg incomplete = 0;

  reg [31:0] _address, _data_in;
  wire [29:0] n_addr       = {_address[31:2] + 1'b1};
  wire [4:0]  n_addr_index = {addr_index[4:2] + 1'b1};
  wire [4:0]  addr_index = _address[4:0];
  wire [26:0] addr_tag   = _address[31:5];

  always @(posedge clk or posedge reset)
  begin
    if (reset)
    begin
      current_state <= IDLE;
      _address <= 0;
      _data_in <= 0;
    end
    else
    begin
      case (current_state)
        IDLE:
        begin
          data_ready <= 0; // Maybe move to inside of the following if
          fetch_write_enable <= 0;
          _address <= address;
          _data_in <= data_in;
          if (write_enable)
            current_state <= WRITE;
          else if(read_enable)
            current_state <= READ;
        end
        READ:
        begin
          if (~incomplete)
          begin
            if (tag[{addr_index[4:2], 2'b00}] == addr_tag && valid[{addr_index[4:2], 2'b00}])
            begin
              case (_address[1:0])
                2'b01:
                begin
                  data_out   <= {8'b0, data[{addr_index[4:2], 2'b00}][31:8]};
                  data_ready <= 0;
                  incomplete <= 1;
                end
                2'b10:
                begin
                  data_out   <= {16'b0, data[{addr_index[4:2], 2'b00}][31:16]};
                  data_ready <= 0;
                  incomplete <= 1;
                end
                2'b11:
                begin
                  data_out   <= {24'b0, data[{addr_index[4:2], 2'b00}][31:24]};
                  data_ready <= 0;
                  incomplete <= 1;
                end
                default:
                begin
                  data_out      <= data[{addr_index[4:2], 2'b00}];
                  data_ready    <= 1;
                  current_state <= IDLE;
                end
              endcase
            end
            else
            begin
              if (fetch_address == {_address[31:2], 2'b00})
              begin
                data [{addr_index[4:2], 2'b00}] <= fetch_read_data;
                tag  [{addr_index[4:2], 2'b00}] <= addr_tag;
                valid[{addr_index[4:2], 2'b00}] <= 1;
                case (_address[1:0])
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
                    current_state <= IDLE;
                  end
                endcase
              end
              else
              begin
                fetch_address <= {_address[31:2], 2'b00};
                data_ready    <= 0;
              end
            end
          end
          else
          begin
            if (tag[{n_addr_index, 2'b00}] == addr_tag && valid[{n_addr_index, 2'b00}])
            begin
              case (_address[1:0])
                2'b01:
                begin
                  data_out   <= {data[{n_addr_index, 2'b00}][7:0], data_out[23:0]};
                  data_ready <= 1;
                  current_state <= IDLE;
                end
                2'b10:
                begin
                  data_out   <= {data[{n_addr_index, 2'b00}][15:0], data_out[15:0]};
                  data_ready <= 1;
                  current_state <= IDLE;
                end
                2'b11:
                begin
                  data_out   <= {data[{n_addr_index, 2'b00}][23:0], data_out[7:0]};
                  data_ready <= 1;
                  current_state <= IDLE;
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
              if (fetch_address == {n_addr, 2'b00})
              begin
                data [addr_index] <= fetch_read_data;
                tag  [addr_index] <= addr_tag;
                valid[addr_index] <= 1;
                case (address[1:0])
                  2'b01:
                  begin
                    data_out   <= {fetch_read_data[7:0], data_out[23:0]};
                    data_ready <= 1;
                    current_state <= IDLE;
                  end
                  2'b10:
                  begin
                    data_out   <= {fetch_read_data[15:0], data_out[15:0]};
                    data_ready <= 1;
                    current_state <= IDLE;
                  end
                  2'b11:
                  begin
                    data_out   <= {fetch_read_data[23:0], data_out[7:0]};
                    data_ready <= 1;
                    current_state <= IDLE;
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
                fetch_address <= {n_addr, 2'b00};
                data_ready    <= 0;
              end
            end
          end
        end
        WRITE:
        begin
          if (~incomplete)
          begin
            if (tag[{addr_index[4:2], 2'b00}] == addr_tag && valid[{addr_index[4:2], 2'b00}])
            begin
              case (_address[1:0])
                2'b01:
                begin
                  data [{addr_index[4:2], 2'b00}] <= {_data_in[23:0], data[{addr_index[4:2], 2'b00}][7:0]};
                  tag  [{addr_index[4:2], 2'b00}] <= addr_tag;
                  valid[{addr_index[4:2], 2'b00}] <= 1;

                  fetch_write_data   <= {_data_in[23:0], data[{addr_index[4:2], 2'b00}][7:0]};
                  fetch_write_enable <= 1;
                  fetch_address      <= {_address[31:2], 2'b00};

                  data_ready <= 0;
                  incomplete <= 1;
                end
                2'b10:
                begin
                  data [{addr_index[4:2], 2'b00}] <= {_data_in[15:0], data[{addr_index[4:2], 2'b00}][15:0]};
                  tag  [{addr_index[4:2], 2'b00}] <= addr_tag;
                  valid[{addr_index[4:2], 2'b00}] <= 1;

                  fetch_write_data   <= {_data_in[15:0], data[{addr_index[4:2], 2'b00}][15:0]};
                  fetch_write_enable <= 1;
                  fetch_address      <= {_address[31:2], 2'b00};

                  data_ready <= 0;
                  incomplete <= 1;
                end
                2'b11:
                begin
                  data [{addr_index[4:2], 2'b00}] <= {_data_in[7:0], data[{addr_index[4:2], 2'b00}][23:0]};
                  tag  [{addr_index[4:2], 2'b00}] <= addr_tag;
                  valid[{addr_index[4:2], 2'b00}] <= 1;

                  fetch_write_data   <= {_data_in[7:0], data[{addr_index[4:2], 2'b00}][23:0]};
                  fetch_write_enable <= 1;
                  fetch_address      <= {_address[31:2], 2'b00};

                  data_ready <= 0;
                  incomplete <= 1;
                end
                default:
                begin
                  data [{addr_index[4:2], 2'b00}] <= _data_in;
                  tag  [{addr_index[4:2], 2'b00}] <= addr_tag;
                  valid[{addr_index[4:2], 2'b00}] <= 1;
                  
                  fetch_write_data   <= _data_in;
                  fetch_write_enable <= 1;
                  fetch_address      <= {_address[31:2], 2'b00};

                  current_state <= IDLE;
                end
              endcase
            end
            else
            begin
              if (fetch_address == {_address[31:2], 2'b00})
              begin
                case (_address[1:0])
                  2'b01:
                  begin
                    data [{addr_index[4:2], 2'b00}] <= {_data_in[23:0], fetch_read_data[7:0]};
                    tag  [{addr_index[4:2], 2'b00}] <= addr_tag;
                    valid[{addr_index[4:2], 2'b00}] <= 1;

                    fetch_write_data   <= {_data_in[23:0], fetch_read_data[7:0]};
                    fetch_write_enable <= 1;
                    fetch_address      <= {_address[31:2], 2'b00};

                    data_ready <= 0;
                    incomplete <= 1;
                  end
                  2'b10:
                  begin
                    data [{addr_index[4:2], 2'b00}] <= {_data_in[15:0], fetch_read_data[15:0]};
                    tag  [{addr_index[4:2], 2'b00}] <= addr_tag;
                    valid[{addr_index[4:2], 2'b00}] <= 1;

                    fetch_write_data   <= {_data_in[15:0], fetch_read_data[15:0]};
                    fetch_write_enable <= 1;
                    fetch_address      <= {_address[31:2], 2'b00};

                    data_ready <= 0;
                    incomplete <= 1;
                  end
                  2'b11:
                  begin
                    data [{addr_index[4:2], 2'b00}] <= {_data_in[7:0], fetch_read_data[23:0]};
                    tag  [{addr_index[4:2], 2'b00}] <= addr_tag;
                    valid[{addr_index[4:2], 2'b00}] <= 1;

                    fetch_write_data   <= {_data_in[7:0], fetch_read_data[23:0]};
                    fetch_write_enable <= 1;
                    fetch_address      <= {_address[31:2], 2'b00};

                    data_ready <= 0;
                    incomplete <= 1;
                  end
                  default:
                  begin
                    data [{addr_index[4:2], 2'b00}] <= _data_in;
                    tag  [{addr_index[4:2], 2'b00}] <= addr_tag;
                    valid[{addr_index[4:2], 2'b00}] <= 1;

                    fetch_write_data   <= {_data_in};
                    fetch_write_enable <= 1;
                    fetch_address      <= {_address[31:2], 2'b00};

                    data_ready <= 1;
                    incomplete <= 0;
                    current_state <= IDLE;
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
            if (tag[{n_addr_index, 2'b00}] == addr_tag && valid[{n_addr_index, 2'b00}])
            begin
              case (address[1:0])
                2'b01:
                begin
                  data [{n_addr_index, 2'b00}] <= {data[{n_addr_index, 2'b00}][31:8], _data_in[31:24]};
                  tag  [{n_addr_index, 2'b00}] <= addr_tag;
                  valid[{n_addr_index, 2'b00}] <= 1;

                  fetch_write_data   <= {data_in[7:0], data[{n_addr_index, 2'b00}][23:0]};
                  fetch_write_enable <= 1;
                  fetch_address      <= {n_addr, 2'b00};

                  data_ready <= 1;
                  current_state <= IDLE;
                end
                2'b10:
                begin
                  data [{n_addr_index, 2'b00}] <= {data[{n_addr_index, 2'b00}][31:16], _data_in[31:16]};
                  tag  [{n_addr_index, 2'b00}] <= addr_tag;
                  valid[{n_addr_index, 2'b00}] <= 1;

                  fetch_write_data   <= {data[{n_addr_index, 2'b00}][31:16], _data_in[31:16]};
                  fetch_write_enable <= 1;
                  fetch_address      <= {n_addr, 2'b00};

                  data_ready <= 1;
                  current_state <= IDLE;
                end
                2'b11:
                begin
                  data [{n_addr_index, 2'b00}] <= {data[{n_addr_index, 2'b00}][31:24], _data_in[31:08]};
                  tag  [{n_addr_index, 2'b00}] <= addr_tag;
                  valid[{n_addr_index, 2'b00}] <= 1;

                  fetch_write_data   <= {data[{n_addr_index, 2'b00}][31:24], _data_in[31:08]}
                  fetch_write_enable <= 1;
                  fetch_address      <= {n_addr, 2'b00};

                  data_ready <= 1;
                  current_state <= IDLE;
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
              if (fetch_address == {n_addr, 2'b00})
              begin
                case (_address[1:0])
                  2'b01:
                  begin
                    data [{n_addr_index, 2'b00}] <= {fetch_read_data[31:8], _data_in[31:24]};
                    tag  [{n_addr_index, 2'b00}] <= addr_tag;
                    valid[{n_addr_index, 2'b00}] <= 1;

                    fetch_write_data   <= {fetch_read_data[31:8], _data_in[31:24]};
                    fetch_write_enable <= 1;
                    fetch_address      <= {n_addr, 2'b00};

                    data_ready <= 1;
                    current_state <= IDLE;
                  end
                  2'b10:
                  begin
                    data [{n_addr_index, 2'b00}] <= {fetch_read_data[31:16], _data_in[31:16]};
                    tag  [{n_addr_index, 2'b00}] <= addr_tag;
                    valid[{n_addr_index, 2'b00}] <= 1;

                    fetch_write_data   <= {fetch_read_data[31:16], _data_in[31:16]};
                    fetch_write_enable <= 1;
                    fetch_address      <= {n_addr, 2'b00};

                    data_ready <= 1;
                    current_state <= IDLE;
                  end
                  2'b11:
                  begin
                    data [{n_addr_index, 2'b00}] <= {fetch_read_data[31:24], _data_in[31:08]};
                    tag  [{n_addr_index, 2'b00}] <= addr_tag;
                    valid[{n_addr_index, 2'b00}] <= 1;

                    fetch_write_data   <= {fetch_read_data[31:24], _data_in[31:08]};
                    fetch_write_enable <= 1;
                    fetch_address      <= {n_addr, 2'b00};

                    data_ready <= 1;
                    current_state <= IDLE;
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
                fetch_address <= {n_addr, 2'b00};
                data_ready    <= 0;
              end
            end
          end
        end
        default: current_state <= IDLE;
      endcase
    end
  end
endmodule
