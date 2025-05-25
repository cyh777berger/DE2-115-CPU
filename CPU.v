module CPU (KEY, SW, LEDR,CLOCK_50M,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);
input [1:0] KEY;
input [1:0] SW;
input CLOCK_50M;
output [10:0] LEDR;
output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
wire Done,Resetn,PClock,MClock,Run;
wire [9:0] DIN, Bus, R0, R1, R2;
wire [4:0] pc;
wire key_flag0;
wire key_flag1;
wire [7:0]HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;

flipflop U1(KEY[1],Resetn,CLOCK_50M,key_flag1);
flipflop U2(KEY[0],Resetn,CLOCK_50M,key_flag0);
assign MClock = key_flag0;
assign PClock = key_flag1;
//assign MClock = KEY[0];
//assign PClock = KEY[1];
assign Run = SW[1];
assign Resetn = SW[0];
assign LEDR[9:0] = Bus;
assign LEDR[10] = Done;
proc U3 (DIN, Resetn, PClock, Run, Done, Bus, R0, R1, R2);
int_memten U4 (pc, MClock, DIN);
count5 U5 (Resetn, MClock, pc);
hex7_seg U6(DIN,R0,R1,R2,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);
endmodule
