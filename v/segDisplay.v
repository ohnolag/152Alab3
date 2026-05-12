module segDisplay (
    input running,
    input do_reset,
    input adj_mode,
    input sel_seconds,
    input clk1Hz,
    input clk2Hz,
    input clk50Hz,
    input blink,
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

localparam [6:0] digits [0:10] = '{
    7'b1111110, //0
    7'b0110000, //1
    7'b1101101, //2
    7'b1111001, //3
    7'b0110011, //4
    7'b1011011, //5
    7'b1111101, //6
    7'b1110000, //7
    7'b1111111, //8
    7'b1111011, //9
    7'b0000000 //off
};

localparam [3:0] anodes [0:3] = '{
    4'b0001, //digit 0
    4'b0010,
    4'b0100,
    4'b1000 //digit 3
};

reg [3:0] counter [0:3];
wire [2:0] state = 0;

initial begin
    counter[0] = 0;
    counter[1] = 0;
    counter[2] = 0;
    counter[3] = 0;
end

//render counter on display
reg [1:0] active = 0; //which digit on the display are we rendering
reg [3:0] current_numeral;
reg [3:0] current_digit;
always @(posedge clk50Hz) begin
    current_numeral <= counter[active];
    current_digit <= anodes[active];

    begin if(blink && adj_mode && sel_seconds)
        AN0 <= 0;
        AN1 <= 0;
    end else begin
        AN0 <= current_digit[0];
        AN1 <= current_digit[1];
    end

    begin if(blink && adj_mode && ~sel_seconds)
        AN2 <= 0;
        AN3 <= 0;
    end else begin
        AN2 <= current_digit[2];
        AN3 <= current_digit[3];
    end

    CA <= digits[current_numeral][0];
    CB <= digits[current_numeral][1];
    CC <= digits[current_numeral][2];
    CD <= digits[current_numeral][3];
    CE <= digits[current_numeral][4];
    CF <= digits[current_numeral][5];
    CG <= digits[current_numeral][6];

    active <= active + 1;

    begin if(do_reset) //reset
        counter[0] <= 0;
        counter[1] <= 0;
        counter[2] <= 0;
        counter[3] <= 0;
    end
end

always @(posedge clk1Hz) begin
    begin if(running) //Normal mode
        begin if(counter[0] == 9)
            begin if(counter[1] == 5)
                begin if(counter[2] == 9)
                    begin if(counter[3] == 9)
                        counter[3] <= 0;
                    end else begin
                        counter[3] <= counter[3] + 1;
                    end
                    counter[2] <= 0;
                end else begin
                    counter[2] <= counter[2] + 1;
                end
                counter[1] <= 0;
            end else begin
                counter[1] <= counter[1] + 1;
            end
            counter[0] <= 0;
        end else begin
            counter[0] <= counter[0] + 1;
        end
    end

end

always @(posedge clk2Hz) begin
    begin if(adj_mode && sel_seconds)
        begin if(counter[0] == 9)
            begin if(counter[1] == 5)
                counter[1] <= 0;
            end else begin
                counter[1] <= counter[1] + 1;
            end
            counter[0] <= 0;
        end else begin
            counter[0] <= counter[0] + 1;
        end
    end 

    begin if(adj_mode && ~sel_seconds)
        begin if(counter[2] == 9)
            begin if(counter[3] == 9)
                counter[3] <= 0;
            end else begin
                counter[3] <= counter[3] + 1;
            end
            counter[2] <= 0;
        end else begin
            counter[2] <= counter[2] + 1;
        end
    end
end

    
endmodule