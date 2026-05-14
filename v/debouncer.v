module debouncer #(
    parameter CLK_FREQ = 400,
    parameter DEBOUNCE_TIME_MS = 80
)(
    input  wire clk,
    input  wire btn_in,
    output reg  btn_out,
    output wire btn_pulse
);

    localparam integer COUNT_RAW = (CLK_FREQ * DEBOUNCE_TIME_MS) / 1000;
    localparam integer COUNT_MAX = (COUNT_RAW < 1) ? 1 : COUNT_RAW;
    localparam integer COUNT_W   = $clog2(COUNT_MAX + 1);

    reg [COUNT_W-1:0] timer = 0;
    reg sync_0 = 0;
    reg sync_1 = 0;
    reg btn_out_last = 0;
    initial btn_out = 0;

    always @(posedge clk) begin
        sync_0<=btn_in;
        sync_1<=sync_0;
    end

    // 2. Debounce
    always @(posedge clk) begin
        if (sync_1 == btn_out) begin
            timer <= 0;
        end else begin
            if (timer == COUNT_MAX - 1) begin
                btn_out <= sync_1;
                timer   <= 0;
            end else begin
                timer <= timer + 1'b1;
            end
        end
    end

    // 3. Edge detection
    always @(posedge clk) begin
        btn_out_last <= btn_out;
    end

    assign btn_pulse = btn_out & ~btn_out_last;

endmodule
