module uart_rx (
    input clk,              // Clock signal
    input reset,            // Reset signal
    input rx,               // Received data line
    output reg [7:0] data_out, // Received data
    output reg rx_done      // Reception complete flag
);

    parameter IDLE = 0, START = 1, DATA = 2, STOP = 3;
    reg [1:0] state;
    reg [2:0] bit_index;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            rx_done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    rx_done <= 0;
                    if (!rx) state <= START;  // Start bit detected
                end
                START: begin
                    state <= DATA;
                    bit_index <= 0;
                end
                DATA: begin
                    shift_reg[bit_index] <= rx;
                    bit_index <= bit_index + 1;
                    if (bit_index == 7) state <= STOP;
                end
                STOP: begin
                    data_out <= shift_reg;
                    rx_done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
