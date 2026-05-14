module fsm (
    // FSM updates on the same slow clock used for debounced controls.
    input wire clk,

    // Pulses are one-clock events. PAUSE and RESET are push buttons, so this is OK.
    input wire pause_pulse,
    input wire reset_pulse,

    // Levels stay high while the switch is on. 
    // ADJ and SEL must be levels, not pulses.
    input wire adj_level,
    input wire sel_level,

    // running tells the display/counter logic whether 
    // normal counting is enabled.
    output reg running,
    // paused is mostly a status output for the current pause state.
    output reg paused,
    // do_reset forwards the reset pulse to the counter/display logic.
    output reg do_reset,
    // adj_mode and sel_seconds directly follow the debounced switch levels.
    output reg adj_mode,
    output reg sel_seconds
);

    // Two-state machine: normal counting state or paused state.
    parameter NORMAL = 1'b0;
    parameter PAUSE  = 1'b1;

    // state is the current registered state; next_state is combinational.
    reg state = NORMAL;
    reg next_state = NORMAL;

    // State register. The FSM takes on next_state once per clk edge.
    always @(posedge clk) begin
        state <= next_state;
    end

    // Next-state logic.
    always @(*) begin
        // Default: stay in the current state unless a button event changes it.
        next_state = state;

        // Reset has priority so pressing RESET clears the pause state too.
        // Without this, reset could clear the time but leave the stopwatch paused.
        if (reset_pulse)
            next_state = NORMAL;
        // Pause is a toggle button: one pulse switches NORMAL <-> PAUSE.
        else if (pause_pulse)
            next_state = (state == NORMAL) ? PAUSE : NORMAL;
    end

    // Output logic.
    always @(*) begin
        // Normal counting runs only when not paused and not in adjustment mode.
        running     = (state == NORMAL) && !adj_level;
        paused      = (state == PAUSE);
        do_reset    = reset_pulse;
        adj_mode    = adj_level;
        sel_seconds = sel_level;
    end
endmodule
