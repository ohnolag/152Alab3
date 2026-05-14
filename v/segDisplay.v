module segDisplay (
    input running,
    input do_reset,
    input adj_mode,
    input sel_seconds,
    input clk1Hz,
    input clk2Hz,
    input clk50Hz,
    input blink,
    output reg AN0,
    output reg AN1,
    output reg AN2,
    output reg AN3,
    output reg CA,
    output reg CB,
    output reg CC,
    output reg CD,
    output reg CE,
    output reg CF,
    output reg CG
);

reg [3:0] sec_ones = 0;
reg [3:0] sec_tens = 0;
reg [3:0] min_ones = 0;
reg [3:0] min_tens = 0;

reg [1:0] active = 0;
reg clk1Hz_last = 0;
reg clk2Hz_last = 0;

wire tick_1hz = clk1Hz & ~clk1Hz_last;
wire tick_2hz = clk2Hz & ~clk2Hz_last;

function [6:0] seven_seg;
    input [3:0] numeral;
    begin
        case (numeral)
            4'd0: seven_seg = 7'b1000000;
            4'd1: seven_seg = 7'b1111001;
            4'd2: seven_seg = 7'b0100100;
            4'd3: seven_seg = 7'b0110000;
            4'd4: seven_seg = 7'b0011001;
            4'd5: seven_seg = 7'b0010010;
            4'd6: seven_seg = 7'b0100000;
            4'd7: seven_seg = 7'b1111000;
            4'd8: seven_seg = 7'b0000000;
            4'd9: seven_seg = 7'b0010000;
            default: seven_seg = 7'b1111111;
        endcase
    end
endfunction

task increment_seconds;
    begin
        if (sec_ones == 9) begin
            sec_ones <= 0;
            if (sec_tens == 5) begin
                sec_tens <= 0;
                if (min_ones == 9) begin
                    min_ones <= 0;
                    if (min_tens == 9)
                        min_tens <= 0;
                    else
                        min_tens <= min_tens + 1;
                end else begin
                    min_ones <= min_ones + 1;
                end
            end else begin
                sec_tens <= sec_tens + 1;
            end
        end else begin
            sec_ones <= sec_ones + 1;
        end
    end
endtask

task increment_minutes;
    begin
        if (min_ones == 9) begin
            min_ones <= 0;
            if (min_tens == 9)
                min_tens <= 0;
            else
                min_tens <= min_tens + 1;
        end else begin
            min_ones <= min_ones + 1;
        end
    end
endtask

task adjust_seconds;
    begin
        if (sec_ones == 9) begin
            sec_ones <= 0;
            if (sec_tens == 5)
                sec_tens <= 0;
            else
                sec_tens <= sec_tens + 1;
        end else begin
            sec_ones <= sec_ones + 1;
        end
    end
endtask

reg [3:0] current_numeral;
reg [3:0] anodes;
reg display_off;
reg [6:0] segments;

always @(posedge clk50Hz) begin
    clk1Hz_last <= clk1Hz;
    clk2Hz_last <= clk2Hz;

    if (do_reset) begin
        sec_ones <= 0;
        sec_tens <= 0;
        min_ones <= 0;
        min_tens <= 0;
    end else if (adj_mode && tick_2hz) begin
        if (sel_seconds)
            adjust_seconds;
        else
            increment_minutes;
    end else if (running && tick_1hz) begin
        increment_seconds;
    end

    case (active)
        2'd0: begin
            current_numeral = sec_ones;
            anodes = 4'b1110;
            display_off = adj_mode && sel_seconds && blink;
        end
        2'd1: begin
            current_numeral = sec_tens;
            anodes = 4'b1101;
            display_off = adj_mode && sel_seconds && blink;
        end
        2'd2: begin
            current_numeral = min_ones;
            anodes = 4'b1011;
            display_off = adj_mode && !sel_seconds && blink;
        end
        default: begin
            current_numeral = min_tens;
            anodes = 4'b0111;
            display_off = adj_mode && !sel_seconds && blink;
        end
    endcase

    if (display_off) begin
        {AN3, AN2, AN1, AN0} <= 4'b1111;
        segments = 7'b1111111;
    end else begin
        {AN3, AN2, AN1, AN0} <= anodes;
        segments = seven_seg(current_numeral);
    end

    {CG, CF, CE, CD, CC, CB, CA} <= segments;
    active <= active + 1;
end

endmodule
