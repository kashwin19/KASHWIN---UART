module uart_tb;

    reg clk, reset;
    reg [7:0] tx_data;
    reg tx_start;
    wire tx, rx;
    wire tx_done, rx_done;
    wire [7:0] rx_data;

    // Instantiate Baud Rate Generator
    wire baud_tick;
    baud_rate_gen #(.CLOCK_FREQ(50000000), .BAUD_RATE(9600)) baud_gen (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick)
    );

    // Instantiate UART TX
    uart_tx tx_inst (
        .clk(baud_tick),
        .reset(reset),
        .data_in(tx_data),
        .tx_start(tx_start),
        .tx(tx),
        .tx_done(tx_done)
    );

    // Instantiate UART RX
    uart_rx rx_inst (
        .clk(baud_tick),
        .reset(reset),
        .rx(tx),  // Loopback
        .data_out(rx_data),
        .rx_done(rx_done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // 50 MHz clock
    end

    // Test sequence
    initial begin
        reset = 1;
        tx_start = 0;
        tx_data = 8'b10101010;
        #50;
        reset = 0;

        // Send data
        #100;
        tx_start = 1;
        #20;
        tx_start = 0;

        // Wait for TX and RX to complete
        wait (tx_done);
        wait (rx_done);

        #100;
        $display("Received Data: %b", rx_data);

        $finish;
    end
endmodule
