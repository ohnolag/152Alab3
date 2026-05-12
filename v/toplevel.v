module top(
    input clk,
    input ADJ,
    input SEL,
    input RESET,
    input PAUSE,
    output AN0,
    output AN1,
    output AN2,
    output AN3,
    output CA,
    output CB,
    output CC,
    output CD,
    output CE,
    output CF,
    output CG
);

reg clk1Hz;
reg clk2Hz;
reg clk50Hz;
reg blink;

reg adj_pulse;
reg sel_pulse;
reg reset_pulse;
reg pause_pulse;

reg running;
reg do_reset;
reg adj_mode;
reg sel_seconds;

clock u_clock(
    .clk(clk),
    .clk1Hz(clk1Hz),
    .clk2Hz(clk2Hz),
    .clk50Hz(clk50Hz),
    .blink(blink)
);

debouncer u_ADJ(
    .clk(clk50Hz),
    .btn_in(ADJ),
    .btn_pulse(adj_pulse)
);

debouncer u_SEL(
    .clk(clk50Hz),
    .btn_in(SEL),
    .btn_pulse(sel_pulse)
);

debouncer u_RESET(
    .clk(clk50Hz),
    .btn_in(RESET),
    .btn_pulse(reset_pulse)
);

debouncer u_PAUSE(
    .clk(clk50Hz),
    .btn_in(PAUSE),
    .btn_pulse(pause_pulse)
);

fsm u_fsm(
    .clk(clk50Hz),
    .pause_pulse(pause_pulse),
    .reset_pulse(reset_pulse),
    .adj_level(adj_pulse),
    .sel_level(sel_pulse),
    .running(running),
    .do_reset(do_reset),
    .adj_mode(adj_mode),
    .sel_seconds(sel_seconds)
);

segDisplay u_segDisplay(
    .running(running),
    .do_reset(do_reset),
    .adj_mode(adj_mode),
    .sel_seconds(sel_seconds),
    .clk1Hz(clk1Hz),
    .clk2Hz(clk2Hz),
    .clk50Hz(clk50Hz),
    .blink(blink),
    .AN0(AN0),
    .AN1(AN1),
    .AN2(AN2),
    .AN3(AN3),
    .CA(CA),
    .CB(CB),
    .CC(CC),
    .CD(CD),
    .CE(CE),
    .CF(CF),
    .CG(CG)
);

endmodule