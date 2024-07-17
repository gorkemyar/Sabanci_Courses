`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2022 10:40:36 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input CLK100MHZ,
    input rst,
    output [6:0] SEVEN,
    output reg [7:0] AN
    );

    reg [1:0] digit;

    wire c1hz, c100hz;
    reg [3:0] binarydata;

    wire [3:0] units;
    wire [3:0] tens;
    
    down59n mycounter(c1hz, rst, units, tens);
    clk_divider mydivider(CLK100MHZ, rst, c1hz, c100hz);
    bin2seven myconverter(binarydata, SEVEN);
    
    always @(posedge c100hz, negedge rst)
    begin
        if(rst==0) begin
            digit <=0;
        end
        else begin
            digit <= digit + 1;
        end
    end
    
    always @(digit)
    begin
        case (digit)
            0 :  begin AN <= 8'b11111110; binarydata <= units; end
            1 :  begin AN <= 8'b11111101; binarydata <= tens; end
            2 :  begin AN <= 8'b11111011; binarydata <= 4'b0000; end
            3 :  begin AN <= 8'b11110111; binarydata <= 4'b0000; end
        endcase
    end
    
endmodule

module clk_divider(
    input clk,
    input rst,
    output c1hz,
    output c100hz
    );
    reg [25:0] cnt;
    
    assign c1hz = cnt[25];
    assign c100hz = cnt[17];
    
    always @(posedge clk, negedge rst)
    begin
        if (rst==0) begin
            cnt <= 0;
        end
        else begin
            cnt <= cnt +1;
        end
    end // always
endmodule

module bin2seven (
	input [3:0] bin,
	output reg [6:0] seven);

	always @(bin)
	begin
		case (bin)
		4'h0 : seven = 7'b1000000;
		4'h1 : seven = 7'b1111001;
		4'h2 : seven = 7'b0100100;
		4'h3 : seven = 7'b0110000;
		4'h4 : seven = 7'b0011001;
		4'h5 : seven = 7'b0010010;
		4'h6 : seven = 7'b0000010;
		4'h7 : seven = 7'b1111000;
		4'h8 : seven = 7'b0000000;
		4'h9 : seven = 7'b0010000;
		4'hA : seven = 7'b0001000;
		4'hB : seven = 7'b0000011;
		4'hC : seven = 7'b1000110;
		4'hD : seven = 7'b0100001;
		4'hE : seven = 7'b0000110;
		4'hF : seven = 7'b0001110;
		default : seven = 7'b0000000;
		endcase
	end
endmodule
   