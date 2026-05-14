module debouncer #(
    // This module is clocked by clk50Hz in top, so the default clock rate is 50 Hz.
    // With an 80 ms debounce window, the input must be stable for about 4 samples.
    parameter CLK_FREQ = 50,
    parameter DEBOUNCE_TIME_MS = 80
)(
    // Slow sampling clock used for both synchronizing and debouncing.
    input  wire clk,
    // Raw button or switch signal from the board.
    input  wire btn_in,
    // Debounced held value. Use this for switches like ADJ and SEL.
    output reg  btn_out = 0,
    // One-clock pulse on the rising edge of btn_out. Use this for toggle buttons.
    output wire btn_pulse
);

    // Convert debounce time from milliseconds to clock samples.
    // The +999 rounds up so short debounce times do not truncate to 0 samples.
    localparam integer COUNT_MAX = ((CLK_FREQ * DEBOUNCE_TIME_MS) + 999) / 1000;
    // Timer width must be at least 1 bit even when COUNT_MAX is tiny.
    localparam integer COUNT_W   = (COUNT_MAX < 2) ? 1 : $clog2(COUNT_MAX);

    // Counts how long the synchronized input has disagreed with btn_out.
    reg [COUNT_W-1:0] timer = 0;
    // Two flip-flops reduce metastability from the asynchronous input.
    reg sync_0 = 0, sync_1 = 0;
    // Previous debounced output, used to detect a rising edge.
    reg btn_out_last = 0;

    // 1. Synchronize the raw input into this clock domain.
    always @(posedge clk) begin
        sync_0<=btn_in;
        sync_1<=sync_0;
    end

    // 2. Debounce. Only accept a new value after it stays different long enough.
    always @(posedge clk) begin
        // If the input matches the accepted output, there is no pending change.
        if (sync_1 == btn_out) begin
            timer <= 0;
        end else begin
            // If the new input value has stayed stable long enough, accept it.
            if (timer == COUNT_MAX - 1) begin
                btn_out <= sync_1;
                timer   <= 0;
            end else begin
                // Otherwise keep waiting to make sure it was not bounce/noise.
                timer <= timer + 1'b1;
            end
        end
    end

    // 3. Edge detection. Store the old debounced value for pulse generation.
    always @(posedge clk) begin
        btn_out_last <= btn_out;
    end

    // btn_pulse is high for one clk cycle when btn_out changes from 0 to 1.
    assign btn_pulse = btn_out & ~btn_out_last;

endmodule
