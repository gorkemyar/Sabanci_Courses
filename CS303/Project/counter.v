`timescale 1ns / 1ps

module counter(
    input rst,
    input clk,
    input start,
    output endd);
    
    reg [9:0] cnt;
    
    assign endd = (cnt==0);
    
    always @(posedge clk, negedge rst)
    begin
        if (~rst)
        begin
            cnt <= 0;
        end
        else
        begin
            if (start)
                cnt <= 999;  // need to check this number
            else if (~endd)
                cnt <= cnt-1;
        end
    end // always
endmodule
