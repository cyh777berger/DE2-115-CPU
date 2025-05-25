module hex7_seg (DIN,R0,R1,R2,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);
input [9:0]DIN,R0,R1,R2;
output [6:0]HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
hex7seg HEX_0(R0[3:0],HEX0);
hex7seg HEX_1(R0[7:4],HEX1);
hex7seg HEX_2({2'b00,R0[9:8]},HEX2);
hex7seg HEX_3(DIN[9:6],HEX3);
hex7seg HEX_4(R1[3:0],HEX4);
hex7seg HEX_5(R1[7:4],HEX5);
hex7seg HEX_6(R2[3:0],HEX6);
hex7seg HEX_7(R2[7:4],HEX7);
endmodule