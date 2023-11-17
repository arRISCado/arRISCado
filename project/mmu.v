// Memory Management Unit
module mmu (
  // Core
  input [31:0]      c_address,
  input [31:0]      c_data_in,
  input             c_write_enable,
  output reg        c_data_ready,
  output reg [31:0] c_data_out,

  // Memory
  output reg [31:0] m_address,
  output reg [31:0] m_data_in,
  output reg        m_write_enable,
  input             m_data_ready,
  input [31:0]      m_data_out,

  // Peripheral
  output reg [31:0] p_address,
  output reg [31:0] p_data_in,
  output reg        p_write_enable,
  input             p_data_ready,
  input [31:0]      p_data_out

);
  always @(*)
  begin
    case (c_address[31:27])
      'b00000: // Memory
      begin
        p_address      <= 0;
        p_data_in      <= 0;
        p_write_enable <= 0;

        m_address      <= c_address;
        m_data_in      <= c_data_in;
        m_write_enable <= c_write_enable;
        c_data_ready   <= m_data_ready;
        c_data_out     <= m_data_out;
      end
      default: // Peripheral
      begin
        m_address      <= 0;
        m_data_in      <= 0;
        m_write_enable <= 0;

        p_address      <= c_address;
        p_data_in      <= c_data_in;
        p_write_enable <= c_write_enable;
        c_data_ready   <= p_data_ready;
        c_data_out     <= p_data_out;
      end
    endcase
  end
endmodule
