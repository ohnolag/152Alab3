`timescale 1ns/1ps

module fsm_tb;
    reg clk;
    reg srst;
    reg pause_pulse;
    reg reset_pulse;
    reg adj_level;
    reg sel_level;

    wire running;
    wire paused;
    wire do_reset;
    wire adj_mode;
    wire [1:0] sel_digit;

    fsm dut (
        .clk(clk),
        .srst(srst),
        .pause_pulse(pause_pulse),
        .reset_pulse(reset_pulse),
        .adj_level(adj_level),
        .sel_level(sel_level),
        .running(running),
        .paused(paused),
        .do_reset(do_reset),
        .adj_mode(adj_mode),
        .sel_digit(sel_digit)
    );

    always #5 clk = ~clk;

    task expect_outputs;
        input exp_running;
        input exp_paused;
        input exp_reset;
        input exp_adj_mode;
        input [1:0] exp_sel_digit;
        input [127:0] label;
        begin
            #1;
            if (running !== exp_running ||
                paused !== exp_paused ||
                do_reset !== exp_reset ||
                adj_mode !== exp_adj_mode ||
                sel_digit !== exp_sel_digit) begin
                $display("FAIL: %0s", label);
                $display("  got      running=%b paused=%b do_reset=%b adj_mode=%b sel_digit=%b",
                    running, paused, do_reset, adj_mode, sel_digit);
                $display("  expected running=%b paused=%b do_reset=%b adj_mode=%b sel_digit=%b",
                    exp_running, exp_paused, exp_reset, exp_adj_mode, exp_sel_digit);
                $fatal(1);
            end
        end
    endtask

    task pulse_pause;
        begin
            pause_pulse = 1'b1;
            @(posedge clk);
            pause_pulse = 1'b0;
        end
    endtask

    task pulse_reset;
        begin
            reset_pulse = 1'b1;
            @(posedge clk);
            reset_pulse = 1'b0;
        end
    endtask

    task step_sel;
        begin
            sel_level = 1'b1;
            @(posedge clk);
            sel_level = 1'b0;
        end
    endtask

    initial begin
        clk         = 1'b0;
        srst        = 1'b1;
        pause_pulse = 1'b0;
        reset_pulse = 1'b0;
        adj_level   = 1'b0;
        sel_level   = 1'b0;

        $dumpfile("fsm_tb.vcd");
        $dumpvars(0, fsm_tb);

        @(posedge clk);
        srst = 1'b0;
        expect_outputs(1'b1, 1'b0, 1'b0, 1'b0, 2'b00, "reset -> NORMAL");

        pulse_pause();
        expect_outputs(1'b0, 1'b1, 1'b0, 1'b0, 2'b00, "pause from NORMAL -> PAUSE");

        pulse_pause();
        expect_outputs(1'b1, 1'b0, 1'b0, 1'b0, 2'b00, "pause from PAUSE -> NORMAL");

        adj_level = 1'b1;
        @(posedge clk);
        expect_outputs(1'b0, 1'b0, 1'b0, 1'b1, 2'b00, "enter DIGIT0");

        step_sel();
        expect_outputs(1'b0, 1'b0, 1'b0, 1'b1, 2'b01, "DIGIT0 -> DIGIT1");

        step_sel();
        expect_outputs(1'b0, 1'b0, 1'b0, 1'b1, 2'b10, "DIGIT1 -> DIGIT2");

        step_sel();
        expect_outputs(1'b0, 1'b0, 1'b0, 1'b1, 2'b11, "DIGIT2 -> DIGIT3");

        step_sel();
        expect_outputs(1'b0, 1'b0, 1'b0, 1'b1, 2'b00, "DIGIT3 -> DIGIT0");

        adj_level = 1'b0;
        @(posedge clk);
        expect_outputs(1'b1, 1'b0, 1'b0, 1'b0, 2'b00, "leave adjust mode -> NORMAL");

        pulse_reset();
        expect_outputs(1'b0, 1'b0, 1'b1, 1'b0, 2'b00, "reset pulse -> RESET");

        @(posedge clk);
        expect_outputs(1'b1, 1'b0, 1'b0, 1'b0, 2'b00, "RESET -> NORMAL");

        $display("fsm_tb passed");
        $finish;
    end
endmodule
