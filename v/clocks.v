module clock (
    input clk, //basys master clock 500MHz
    output clk1Hz = 0,
    output clk2Hz = 0,
    output clk50Hz = 0,
    output blink = 0 //0.5hz
);

localparam CLK_FREQ = 100_000_000;
localparam COUNT1 = CLK_FREQ/2;
localparam COUNT2 = CLK_FREQ/4;
localparam COUNT50 = CLK_FREQ/100;
localparam COUNTSLOW = CLK_FREQ;

reg [31:0] count1 = 0;
reg [31:0] count2 = 0;
reg [31:0] count50 = 0;
reg [31:0] countSlow = 0;

always @(posedge clk) begin
    if (count1 == COUNT1 - 1) begin
        clk1Hz <= ~clk1Hz;
        count1 <= 0;
    end else begin
        count1 <= count1 + 1;
    end

    if (count2 == COUNT2 - 1) begin
        clk2Hz <= ~clk2Hz;
        count2 <= 0;
    end else begin
        count2 <= count2 + 1;
    end

    if (count50 == COUNT50 - 1) begin
        clk50Hz <= ~clk50Hz;
        count50 <= 0;
    end else begin
        count50 <= count50 + 1;
    end

    if (countSlow == COUNTSLOW - 1) begin
        blink <= ~blink;
        countSlow <= 0;
    end else begin
        countSlow <= countSlow + 1;
    end


end
    
endmodule