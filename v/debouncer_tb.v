`timescale 1ns/1ps

module debouncer_tb;
    reg clk;
    reg btn_in;

    wire btn_out;
    wire btn_pulse;

    debouncer #(
        .CLK_FREQ(1000),
        .DEBOUNCE_TIME_MS(4)
    ) dut (
        .clk_50Hz(clk),
        .btn_in(btn_in),
        .btn_out(btn_out),
        .btn_pulse(btn_pulse)
    );

    always #5 clk = ~clk;

    integer pulse_count;

    initial begin
        clk = 1'b0;
        btn_in = 1'b0;
        pulse_count = 0;
        dut.timer = 0;
        dut.sync_0 = 1'b0;
        dut.sync_1 = 1'b0;
        dut.btn_out_last = 1'b0;
        dut.btn_out = 1'b0;

        $dumpfile("debouncer_tb.vcd");
        $dumpvars(0, debouncer_tb);

        // Short pulse that should not remain stable long enough to debounce high.
        @(posedge clk);
        btn_in = 1'b1;
        @(posedge clk);
        btn_in = 1'b0;
        repeat (6) @(posedge clk);

        if (btn_out !== 1'b0) begin
            $display("FAIL: btn_out changed during short bounce burst");
            $fatal(1);
        end

        // Long stable press should produce one debounced high and one pulse.
        btn_in = 1'b1;
        repeat (8) @(posedge clk);

        if (btn_out !== 1'b1) begin
            $display("FAIL: btn_out did not debounce high");
            $fatal(1);
        end

        // Hold the press to ensure we do not get extra pulses.
        repeat (4) @(posedge clk);

        // Release and debounce back low.
        btn_in = 1'b0;
        repeat (8) @(posedge clk);

        if (btn_out !== 1'b0) begin
            $display("FAIL: btn_out did not debounce low");
            $fatal(1);
        end

        if (pulse_count !== 1) begin
            $display("FAIL: expected 1 pulse, got %0d", pulse_count);
            $fatal(1);
        end

        $display("debouncer_tb passed");
        $finish;
    end

    always @(posedge clk) begin
        if (btn_pulse)
            pulse_count <= pulse_count + 1;
    end
endmodule
