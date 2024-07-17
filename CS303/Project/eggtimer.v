module eggtimer(
    input CLK100MHZ,
    input rst,
    input beginn, 
    input reset,
    input [3:0] PM10,
    input [3:0] PM1,
    input [3:0] PS10,
    input [3:0] PS1,
    output [3:0] m10,
    output [3:0] m1,
    output [3:0] s10,
    output [3:0] s1,
    output zero
    );

    reg [1:0] state;

    wire c1khz, start, endd, zero, countdown;
    
    wire [3:0] m10;
    wire [3:0] m1;
    wire [3:0] s10;
    wire [3:0] s1;
    
    clk_divider mydivider(CLK100MHZ, rst, c1khz);
    counter mycounter(rst, c1khz, start, endd);  
    downcounter mydown(rst, c1khz, countdown, reset, PM10, PM1, PS10, PS1, m10, m1, s10, s1, zero);
  
  reg countTemp;
  assign countdown=countTemp;
  reg startTemp;
  assign start=startTemp;
    
  localparam [1:0] // 3 states are required for Moore
    zeroMoore = 2'b00,
    edgeMoore = 2'b01, 
    oneMoore = 2'b10,
 	twoMoore = 2'b11;
  
  
  
  always @(posedge zero, posedge beginn)
  begin
    
    if(zero && beginn) // go to state zero if rese
        begin
        state <= twoMoore;
        end
    
    
    else if (zero && ~beginn)
        begin 
        state <= oneMoore;
        end
    
    else if (~zero && beginn)
        begin 
        state <= edgeMoore;
        end
    
    else if (~zero && ~beginn)
        begin 
        state <= zeroMoore;
        end
  end

  always @(state)
	begin
      case(state)
        zeroMoore:
          begin
          startTemp = 0;
          countTemp = 0;
          end
        edgeMoore:
          begin
            countTemp= endd;
        	startTemp=endd;
          end
        oneMoore:
          begin
          startTemp = 0;
          countTemp = 0;
          end
        twoMoore:
          begin
          countTemp = 0;
          startTemp = endd;	
          end  
      endcase
    end
endmodule