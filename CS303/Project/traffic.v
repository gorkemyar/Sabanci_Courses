`timescale 1ns / 1ps
module TrafficLight (clk, reset, car, timed, MAJOR, MINOR, start_timer);
   input      clk, reset, car, timed;
   output reg MAJOR, MINOR, start_timer;
   
   reg        pres_state, next_state;
   
   parameter ST_G = 1'b0, ST_R = 1'b1;

//   assign MAJOR = (pres_state==ST_G) ? 1'b1 : 1'b0;
//   assign MINOR = (pres_state==ST_R) ? 1'b0 : 1'b1;

//   assign start_timer = (pres_state==ST_G) & car;
   
   always @ (posedge clk, negedge reset)
     begin
	if (~reset)
	  pres_state <=  ST_G;
	else
	  pres_state <= next_state;
     end

   always @ (pres_state)
     case (pres_state)
       ST_G : begin MAJOR = 1'b1; MINOR = 1'b0; end
       ST_R : begin MAJOR = 1'b0; MINOR = 1'b1; end 
     endcase // case (state)

  always @ (pres_state, car, timed)
    case (pres_state)
      ST_G : begin if (car) next_state = ST_R; else next_state = pres_state; end
      ST_R : begin if (timed) next_state = ST_G; else next_state = pres_state; end
    endcase // case (pres_state)

   always @ (pres_state, car)
     case (pres_state)
       ST_G : begin if (car) start_timer = 1'b1; else start_timer = 1'b0; end
       ST_R : start_timer = 1'b0;
     endcase // case (pres_state)
   
endmodule // TraficLight

