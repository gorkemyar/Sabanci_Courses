`timescale 1ns / 1ps

module display(
    input rst,
    input c1khz,
    input [3:0] m10,
    input [3:0] m1,
    input [3:0] s10,
    input [3:0] s1,
    output [6:0] SEVEN,
    output reg DP,
    output reg [7:0] AN
    );

    reg [1:0] digit;
    reg [3:0] binarydata;
    
    bin2seven myconverter(binarydata, SEVEN);
    
    always @(posedge c1khz, negedge rst)
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
            0 :  begin AN <= 8'b11111110; binarydata <= s1;  DP <= 1; end
            1 :  begin AN <= 8'b11111101; binarydata <= s10; DP <= 1; end
            2 :  begin AN <= 8'b11111011; binarydata <= m1;  DP <= 0; end
            3 :  begin AN <= 8'b11110111; binarydata <= m10; DP <= 1; end
        endcase
    end
    
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
   
