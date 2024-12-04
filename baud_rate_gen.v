module baud_rate_gen (
    input clk,                // Clock signal
    input reset,              // Reset signal
    output reg baud_tick      // Baud rate clock tick
);

    parameter CLOCK_FREQ = 50000000; // 50 MHz clock
    parameter BAUD_RATE = 9600;      // Desired baud rate
    parameter BAUD_DIV = CLOCK_FREQ / BAUD_RATE;

    reg [31:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            baud_tick <= 0;
        end else if (counter == BAUD_DIV / 2) begin
            baud_tick <= ~baud_tick;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule
