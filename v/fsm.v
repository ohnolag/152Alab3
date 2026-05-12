module fsm (
    input wire clk,
    input wire srst,

    input wire pause_pulse,
    input wire reset_pulse,
    input wire adj_level,
    input wire sel_level,

    output reg running,
    output reg paused,
    output reg do_reset,
    output reg adj_mode,
    output reg sel_seconds
);

    parameter NORMAL = 1'b0;
    parameter PAUSE  = 1'b1;

    reg state;
    reg next_state;

    // State register: srst returns the controller to 
    // normal running mode.
    
    always @(posedge clk or posedge srst) begin
        if (srst)
            state <= NORMAL;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;

        if (pause_pulse)
            next_state = (state == NORMAL) ? PAUSE : NORMAL;
    end

    always @(*) begin
        running     = (state == NORMAL) && !adj_level;
        paused      = (state == PAUSE);
        do_reset    = reset_pulse;
        adj_mode    = adj_level;
        sel_seconds = sel_level;
    end
endmodule
