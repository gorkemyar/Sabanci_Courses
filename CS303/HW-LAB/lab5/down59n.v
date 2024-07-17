/*
 * Generated by Digital. Don't modify this file!
 * Any changes will be lost if this file is regenerated.
 */

module DIG_D_FF_AS_1bit
#(
    parameter Default = 0
)
(
   input Set,
   input D,
   input C,
   input Clr,
   output Q,
   output \~Q
);
    reg state;

    assign Q = state;
    assign \~Q  = ~state;

    always @ (posedge C or posedge Clr or posedge Set)
    begin
        if (Set)
            state <= 1'b1;
        else if (Clr)
            state <= 'h0;
        else
            state <= D;
    end

    initial begin
        state = Default;
    end
endmodule

module Mux_4x1
(
    input [1:0] sel,
    input in_0,
    input in_1,
    input in_2,
    input in_3,
    output reg out
);
    always @ (*) begin
        case (sel)
            2'h0: out = in_0;
            2'h1: out = in_1;
            2'h2: out = in_2;
            2'h3: out = in_3;
            default:
                out = 'h0;
        endcase
    end
endmodule


module downcounter_new (
  input EN,
  input LOAD,
  input [3:0] IN,
  input CLK,
  input RESET,
  output [3:0] CNT,
  output ZERO
);
  wire s0;
  wire s1;
  wire s2;
  wire s3;
  wire s4;
  wire s5;
  wire s6;
  wire s7;
  wire s8;
  wire s9;
  wire s10;
  wire [1:0] s11;
  wire s12;
  wire s13;
  wire s14;
  wire [1:0] s15;
  wire s16;
  wire s17;
  wire s18;
  wire [1:0] s19;
  wire s20;
  wire s21;
  wire s22;
  wire [1:0] s23;
  assign s11[0] = EN;
  assign s11[1] = LOAD;
  assign s8 = ~ RESET;
  assign s0 = IN[0];
  assign s1 = IN[1];
  assign s2 = IN[2];
  assign s3 = IN[3];
  DIG_D_FF_AS_1bit #(
    .Default(0)
  )
  DIG_D_FF_AS_1bit_i0 (
    .Set( s8 ),
    .D( s9 ),
    .C( CLK ),
    .Clr( 1'b0 ),
    .Q( s4 ),
    .\~Q ( s10 )
  );
  Mux_4x1 Mux_4x1_i1 (
    .sel( s11 ),
    .in_0( s4 ),
    .in_1( s10 ),
    .in_2( s0 ),
    .in_3( s0 ),
    .out( s9 )
  );
  assign s12 = (s10 & EN);
  DIG_D_FF_AS_1bit #(
    .Default(0)
  )
  DIG_D_FF_AS_1bit_i2 (
    .Set( s8 ),
    .D( s13 ),
    .C( CLK ),
    .Clr( 1'b0 ),
    .Q( s5 ),
    .\~Q ( s14 )
  );
  Mux_4x1 Mux_4x1_i3 (
    .sel( s15 ),
    .in_0( s5 ),
    .in_1( s14 ),
    .in_2( s1 ),
    .in_3( s1 ),
    .out( s13 )
  );
  assign s15[0] = s12;
  assign s15[1] = LOAD;
  DIG_D_FF_AS_1bit #(
    .Default(0)
  )
  DIG_D_FF_AS_1bit_i4 (
    .Set( s8 ),
    .D( s17 ),
    .C( CLK ),
    .Clr( 1'b0 ),
    .Q( s6 ),
    .\~Q ( s18 )
  );
  Mux_4x1 Mux_4x1_i5 (
    .sel( s19 ),
    .in_0( s6 ),
    .in_1( s18 ),
    .in_2( s2 ),
    .in_3( s2 ),
    .out( s17 )
  );
  assign s19[0] = s16;
  assign s19[1] = LOAD;
  DIG_D_FF_AS_1bit #(
    .Default(0)
  )
  DIG_D_FF_AS_1bit_i6 (
    .Set( s8 ),
    .D( s21 ),
    .C( CLK ),
    .Clr( 1'b0 ),
    .Q( s7 ),
    .\~Q ( s22 )
  );
  Mux_4x1 Mux_4x1_i7 (
    .sel( s23 ),
    .in_0( s7 ),
    .in_1( s22 ),
    .in_2( s3 ),
    .in_3( s3 ),
    .out( s21 )
  );
  assign s23[0] = s20;
  assign s23[1] = LOAD;
  assign CNT[0] = s4;
  assign CNT[1] = s5;
  assign CNT[2] = s6;
  assign CNT[3] = s7;
  assign s16 = (s14 & s12);
  assign s20 = (s18 & s16);
  assign ZERO = (s22 & s20);
endmodule

module down59n (
  input CLK,
  input RESET,
  output [3:0] UNITS,
  output [3:0] TENS
);
  wire [3:0] s0;
  wire [3:0] s1;
  assign s0[0] = 1'b0;
  assign s0[1] = 1'b0;
  assign s0[2] = 1'b0;
  assign s0[3] = 1'b0;
  assign s1[0] = 1'b0;
  assign s1[1] = 1'b0;
  assign s1[2] = 1'b0;
  assign s1[3] = 1'b0;
  // units
  downcounter_new downcounter_new_i0 (
    .EN( 1'b1 ),
    .LOAD( 1'b0 ),
    .IN( s0 ),
    .CLK( CLK ),
    .RESET( RESET ),
    .CNT( UNITS )
  );
  downcounter_new downcounter_new_i1 (
    .EN( 1'b1 ),
    .LOAD( 1'b0 ),
    .IN( s1 ),
    .CLK( CLK ),
    .RESET( RESET ),
    .CNT( TENS )
  );
endmodule
