`timescale 1ns / 1ps

module clk_divider(
    input clk,
    input rst,
    output reg c1khz
    );
    reg [15:0] cnt1k;
    
    always @(posedge clk, negedge rst)
    begin
        if (rst==0) begin
            c1khz <= 0;
            cnt1k <= 0;
        end
        else
        begin
        	if (cnt1k == 49999)
        	begin
                c1khz <= ~c1khz;
                cnt1k <= 0;
        	end
        	else
                cnt1k <= cnt1k +1;
        end
    end // always
endmodule

   
