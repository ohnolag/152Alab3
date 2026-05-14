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

wire clk1Hz;
wire clk2Hz;
wire clk50Hz;
wire blink;

wire adj_level;
wire sel_level;
wire reset_pulse;
wire pause_pulse;

wire running;
wire do_reset;
wire adj_mode;
wire sel_seconds;

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
    .btn_out(adj_level)
);

debouncer u_SEL(
    .clk(clk50Hz),
    .btn_in(SEL),
    .btn_out(sel_level)
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
    .adj_level(adj_level),
    .sel_level(sel_level),
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
