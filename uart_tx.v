module uart_tx (
    input clk,              // Clock signal
    input reset,            // Reset signal
    input [7:0] data_in,    // Data to be transmitted
    input tx_start,         // Start transmission signal
    output reg tx,          // Transmitted data line
    output reg tx_done      // Transmission complete flag
);

    parameter IDLE = 0, START = 1, DATA = 2, STOP = 3;
    reg [1:0] state;
    reg [2:0] bit_index;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx <= 1;  // Idle state of UART line is high
            tx_done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx_done <= 0;
                    if (tx_start) begin
                        shift_reg <= data_in;
                        state <= START;
                    end
                end
                START: begin
                    tx <= 0;  // Start bit
                    state <= DATA;
                    bit_index <= 0;
                end
                DATA: begin
                    tx <= shift_reg[bit_index];
                    bit_index <= bit_index + 1;
                    if (bit_index == 7) state <= STOP;
                end
                STOP: begin
                    tx <= 1;  // Stop bit
                    state <= IDLE;
                    tx_done <= 1;
                end
            endcase
        end
    end
endmodule
