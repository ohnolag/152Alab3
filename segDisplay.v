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

reg [6:0] digits [0:10];

reg [3:0] anodes [0:3];

reg [3:0] counter [0:3];

initial begin
    counter[0] = 0;
    counter[1] = 0;
    counter[2] = 0;
    counter[3] = 0;
    
    anodes[0] = 4'b1110;//digit 0
    anodes[1] = 4'b1101;
    anodes[2] = 4'b1011;
    anodes[3] = 4'b0111;//digit 3
    
    digits[0] = 7'b1000000; //0
    digits[1] = 7'b1111001; //1 
    digits[2] = 7'b0100100;//2
    digits[3] = 7'b0110000; //3
    digits[4] = 7'b0011001; //4
    digits[5] = 7'b0010010; //5
    digits[6] = 7'b0100000; //6
    digits[7] = 7'b1111000; //7
    digits[8] = 7'b0000000; //8
    digits[9] = 7'b0010000; //9
    digits[10] = 7'b1111111; //off
end

//render counter on display
reg [1:0] active = 0; //which digit on the display are we rendering
reg [3:0] current_numeral;
reg [3:0] current_digit;
always @(posedge clk50Hz) begin
    //current_numeral <= counter[active];
    current_numeral <= counter[3];
    current_digit <= anodes[active];

//    if (blink && adj_mode && sel_seconds) begin
//        AN0 <= 0;
//        AN1 <= 0;
//    end else begin
//        AN0 <= current_digit[0];
//        AN1 <= current_digit[1];
//    end

//    if (blink && adj_mode && ~sel_seconds) begin
//        AN2 <= 0;
//        AN3 <= 0;
//    end else begin
//        AN2 <= current_digit[2];
//        AN3 <= current_digit[3];
//    end

    AN0 <= 0;
    AN1 <= 1;
    AN2 <= 1;
    AN3 <= 1;

    CA <= digits[current_numeral][0];
    CB <= digits[current_numeral][1];
    CC <= digits[current_numeral][2];
    CD <= digits[current_numeral][3];
    CE <= digits[current_numeral][4];
    CF <= digits[current_numeral][5];
    CG <= digits[current_numeral][6];

    active <= active + 1;
end

always @(posedge clk2Hz) begin

//    begin if(do_reset)
//        counter[0] = 0;
//        counter[1] = 0;
//        counter[2] = 0;
//        counter[3] = 0;
//    end

//    begin if(adj_mode && sel_seconds)
//        begin if(counter[0] == 9)
//            begin if(counter[1] == 5)
//                counter[1] <= 0;
//            end else begin
//                counter[1] <= counter[1] + 1;
//            end
//            counter[0] <= 0;
//        end else begin
//            counter[0] <= counter[0] + 1;
//        end
//    end 

//    begin if(adj_mode && ~sel_seconds)
//        begin if(counter[2] == 9)
//            begin if(counter[3] == 9)
//                counter[3] <= 0;
//            end else begin
//                counter[3] <= counter[3] + 1;
//            end
//            counter[2] <= 0;
//        end else begin
//            counter[2] <= counter[2] + 1;
//        end
//    end

    //Normal mode
    begin if(clk1Hz)
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

end

    
endmodule