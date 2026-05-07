module fsm( 
    input clk, 
    input srst, 

    input pause_pulse,
    input reset_pulse,
    input adj_level,
    input sel_level, 

    output reg running, 
    output reg paused,
    output reg do_reset, 
    output reg adj_mode, 
    output reg [1:0] sel_digit
); 

    parameter DIGIT0 = 3'b000;
    parameter DIGIT1 = 3'b001;
    parameter DIGIT2 = 3'b010;
    parameter DIGIT3 = 3'b011;
    parameter NORMAL = 3'b100;
    parameter PAUSE  = 3'b101;
    parameter RESET  = 3'b110;

    reg[2:0] state;
    reg[2:0] next_state;

    // state register
    always @(posedge clk or posedge srst) begin
        if (srst)
            state <= NORMAL;
        else
            state <= next_state;
    end

    // next-state logic
    always @(*) begin
        next_state = state;

        // highest-priority button action
        if (reset_pulse) begin
            next_state = RESET;
        end else begin
            case (state)
                NORMAL: begin
                    if (pause_pulse)
                        next_state = PAUSE;
                    else if (adj_level)
                        next_state = DIGIT0;
                end

                PAUSE: begin
                    if (pause_pulse)
                        next_state = NORMAL;
                    else if (adj_level)
                        next_state = DIGIT0;
                end

                RESET: begin
                    if (adj_level)
                        next_state = DIGIT0;
                    else
                        next_state = NORMAL;
                end

                DIGIT0: begin
                    if (!adj_level)
                        next_state = NORMAL;
                    else if (sel_level)
                        next_state = DIGIT1;
                end

                DIGIT1: begin
                    if (!adj_level)
                        next_state = NORMAL;
                    else if (sel_level)
                        next_state = DIGIT2;
                end

                DIGIT2: begin
                    if (!adj_level)
                        next_state = NORMAL;
                    else if (sel_level)
                        next_state = DIGIT3;
                end

                DIGIT3: begin
                    if (!adj_level)
                        next_state = NORMAL;
                    else if (sel_level)
                        next_state = DIGIT0;
                end

                default: begin
                    next_state = NORMAL;
                end
            endcase
        end
    end

    // output logic
    always @(*) begin
        running     = 1'b0;
        paused      = 1'b0;
        do_reset    = 1'b0;
        adj_mode    = 1'b0;
        sel_digit   = 2'b00;

        case (state)
            NORMAL: begin
                running = 1'b1;
            end

            PAUSE: begin
                paused = 1'b1;
            end

            RESET: begin
                do_reset = 1'b1;
            end

            DIGIT0: begin
                adj_mode  = 1'b1;
                sel_digit   = 2'b00;
            end

            DIGIT1: begin
                adj_mode  = 1'b1;
                sel_digit   = 2'b01;
            end

            DIGIT2: begin
                adj_mode  = 1'b1;
                sel_digit   = 2'b10;
            end

            DIGIT3: begin
                adj_mode  = 1'b1;
                sel_digit   = 2'b11;
            end
        endcase
    end
endmodule







