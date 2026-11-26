module uart (
  input clk,
  input rx,
  input rtx,
  input [7:0] data,
  input rst_n,
  output tx
);
  typedef enum logic [3:0] {
      SAMPLE  = 2'b0000,
      START   = 2'b0001,
      DATA_0  = 2'b0010,
      DATA_1  = 2'b0011,
      DATA_2  = 2'b0100,
      DATA_3  = 2'b0101,
      DATA_4  = 2'b0110,
      DATA_5  = 2'b0111,
      DATA_6  = 2'b1000,
      DATA_7  = 2'b1001,
      PARITY  = 2'b1010,
      STOP    = 2'b1011
  } state_t;

  state_t state, next_state;
  logic next_tx;

  logic [7:0] data_buf;

  // 1. Sequential Process: Registers both state and outputs
  always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
          state <= SAMPLE;
          tx    <= 1'b1;
      end else begin
          state <= next_state;
          tx    <= next_tx;

          if (state == SAMPLE) {
            data_buf <= data;
          }
      end
  end

  // 2. Combinational Process: Computes next state & next outputs
  always_comb begin
      // Default assignments prevent inferred latches
      next_state = state;
      next_tx    = 1'b1;

      case (state)
          SAMPLE: begin
            next_state = START;
            next_tx = 1'b0;
          end

          START: begin
            next_state = DATA_0;
            next_tx = data_buf[0];
          end

          DATA_0: begin
            next_state = DATA_1;
            next_xt = data_buf[1];
          end

          DATA_1: begin
            next_state = DATA_2;
            next_xt = data_buf[2];
          end

          DATA_2: begin
            next_state = DATA_3;
            next_xt = data_buf[3];
          end

          DATA_3: begin
            next_state = DATA_4;
            next_xt = data_buf[4];
          end

          DATA_4: begin
            next_state = DATA_5;
            next_xt = data_buf[5];
          end

          DATA_5: begin
            next_state = DATA_6;
            next_xt = data_buf[6];
          end

          DATA_6: begin
            next_state = DATA_7;
            next_xt = data_buf[7];
          end

          DATA_7: begin
            next_state = PARITY;
            next_xt = ^data_buf; // Even parity
          end

          PARITY: begin
            next_state = STOP;
            next_tx = 1'b1;
          end

          STOP: begin
              next_state = SAMPLE;
              next_tx = 1'b1;
          end

          default: begin
              next_state = SAMPLE;
              next_tx = 1'b1;
          end
      endcase
  end

endmodule
