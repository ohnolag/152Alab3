module debouncer #(
    parameter CLK_FREQ = 50_000_000,
    parameter DEBOUNCE_TIME_MS = 20
)(
    input  wire clk,
    input  wire btn_in,
    output reg  btn_out,
    output wire btn_pulse
);

    localparam integer COUNT_MAX = (CLK_FREQ / 1000) * DEBOUNCE_TIME_MS;
    localparam integer COUNT_W   = $clog2(COUNT_MAX);

    reg [COUNT_W-1:0] timer;
    reg sync_0, sync_1;
    reg btn_out_last;

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