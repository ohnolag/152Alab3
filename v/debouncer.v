module debouncer (
    input clk_50Hz, input btn_in, output reg btn_out);
    reg sync_0,sync_1;
    
    always @(posedge clk_50Hz) begin
        sync_0<=btn_in;
        sync_1<=sync_0;
        btn_out<=sync_1;
    end
endmodule