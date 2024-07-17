`timescale 1ns / 1ps
module TopModule(x, y, clk, start, reset, out, state);
   input [3:0] x, y;
   input clk, start, reset;

   output [7:0] out;
   output reg [1:0] state;
   
   reg [3:0] 	a, b, q;
   reg [2:0] 	p;          // counter	
   reg 		c;
   
   parameter T0 = 0, T1 = 1, T2 = 2, T3 = 3;

   assign out = {a,q};
   
   always @(posedge clk, negedge reset)
     if (~reset)
       begin
	  state <= T0;
	  a <= 4'h0;
	  b <= 4'h0;
	  q <= 4'h0;
	  p <= 4'h0;
	  c <= 1'b0;
       end
     else
       case (state)
	 T0:
	   if (start)
	     state <= T1;
	   else
	     state <= T0;
	 T1:
	   begin
	      b <= y;
	      q <= x;
	      p <= 3'b100;
	      state <= T2;
	   end
	 T2:
	   begin
	      p <= p-1;
	      state <= T3;
	      if (q[0] == 1'b1)
		{c, a} <= a + b;
	   end
	 T3:
	   begin
	      {c, a, q} <= {1'b0, c, a, q[3:1]};
	      if(p == 0)
		state <= T0;
	      else
		state <= T2;	
	   end
	 default:
	   if(start) state <= T1;
	   else state <= T0;
       endcase // case (state)
endmodule
