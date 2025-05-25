module proc(DIN, Resetn, ClocK, Run, Done, BusWires, R0, R1, R2);
input [9:0] DIN;
input Resetn, ClocK, Run;
output Done;
output [9:0] BusWires,R0,R1,R2;
parameter T0 = 2'b00, T1 = 2'b01, T2 = 2'b10, T3 = 2'b11;
reg [9:0] BusWires;
reg [0:7] Rin, Rout;
reg [9:0] Sum,result,result2,result3,result4;
reg IRin, Done, DINout;
reg Ain, Gin, Gout, AddSub;
reg Bin, Hin, Hout, AndOr;
reg Cin, Jin, Jout, Shift;
reg Din, Kin, Kout, MulDiv;
reg Ein, Lin, Lout, XorXnor;
reg [1:0] Tstep_Q, Tstep_D;
wire [3:0] I;
wire [0:7] Xreg, Yreg;
wire [17:0] R0, R1, R2, R3, R4, R5, R6, R7, A, G, B, H, C, J, D, K, E, L;
wire [1:10] IR;
wire [1:14] Sel; // bus selector //Sel = {Rout, Gout, Hout, Jout, Kout, Lout, DINout}
assign I = IR[1:4];
dec3to8 decX (IR[5:7], 1'b1, Xreg);
dec3to8 decY (IR[8:10], 1'b1, Yreg);
// Control FSM state table
always @(Tstep_Q, Run, Done)
begin
case (Tstep_Q)
T0: // data is loaded into IR in this time step
if (~Run) Tstep_D = T0;
else Tstep_D = T1;
T1: // some instructions end after this time step
if (Done) Tstep_D = T0;
else Tstep_D = T2;
T2: // always go to T3 after this
Tstep_D = T3;
T3: // instructions end after this time step
Tstep_D = T0;
endcase
end
/* Instruction Table
* 0000: mv Rx,Ry : Rx <- [Ry]
* 0001: mvi Rx,#D : Rx <- D
* 0010: add Rx,Ry : Rx <- [Rx] + [Ry]
* 0011: sub Rx,Ry : Rx <- [Rx] - [Ry]
* 0100: And_bit Rx,Ry : Rx <- [Rx] & [Ry]
* 0101: Or_bit Rx,Ry : Rx <- [Rx] | [Ry]
* 0110: Shift_L Rx,Ry : Rx <- [Rx]<< [Ry]
* 0111: Shift_R Rx,Ry : Rx <- Rx >> Ry
* 1000: Mul Rx,Ry : Rx <- Rx * Ry
* 1001: Div Rx,Ry : Rx <- Rx / Ry
* 1010: Xor Rx,Ry : Rx <- Rx ^ Ry
* 1011: NXor Rx,Ry : Rx <- Rx ~^ Ry
* OPCODE format: IIII XXX YYY, where
* IIII = instruction, XXX = Rx, and YYY = Ry. For mvi, * a second word of data is loaded from DIN
*/
parameter mv = 4'b0000, mvi = 4'b0001, add = 4'b0010, sub =
4'b0011;
parameter And = 4'b0100, Or = 4'b0101, Shift_L=4'b0110,Shift_R=4'b0111;
parameter Mul = 4'b1000, Div = 4'b1001, Xor = 4'b1010, NXor=
4'b1011;
// control FSM outputs
always @(Tstep_Q or I or Xreg or Yreg)
begin
Done = 1'b0;
Ain = 1'b0; Gin = 1'b0; Gout = 1'b0; AddSub = 1'b0;
Bin = 1'b0; Hin = 1'b0; Hout = 1'b0; AndOr = 1'b0;
Cin = 1'b0; Jin = 1'b0; Jout = 1'b0; Shift = 1'b0;
Din = 1'b0; Kin = 1'b0; Kout = 1'b0; MulDiv = 1'b0;
Ein = 1'b0; Lin = 1'b0; Lout = 1'b0; XorXnor= 1'b0;
IRin = 1'b0; DINout = 1'b0; Rin = 8'b0; Rout = 8'b0;
case (Tstep_Q)
T0: // store DIN in IR
begin
IRin = 1'b1;
end
T1: //define signals in time step T1
case (I)
mv: // mv Rx,Ry
begin
Rout = Yreg;
Rin = Xreg;
Done = 1'b1;
end
mvi: // mvi Rx,#D
begin
// data is required to be on DIN
DINout = 1'b1;
Rin = Xreg;
Done = 1'b1;
end
add, sub: //add, sub
begin
Rout = Xreg;
Ain = 1'b1;
end
And,Or://and,or
begin
Rout= Xreg;
Bin= 1'b1;
end
Shift_L,Shift_R://Shift_L,Shift_R
begin
Rout = Xreg;
Cin = 1'b1;
end
Mul,Div://Mul,Div
begin
Rout = Xreg;
Din = 1'b1;
end
Xor,NXor://Xor,NXor
begin
Rout = Xreg;
Ein = 1'b1;
end
default: ;
endcase
T2: //define signals in time step T2
case (I)
add: // add
begin
Rout = Yreg;
Gin = 1'b1;
end
sub: // sub
begin
Rout = Yreg;
AddSub = 1'b1;
Gin = 1'b1;
end
And://and
begin
Rout= Yreg;
Hin= 1'b1;
end
Or://or
begin
Rout= Yreg;
AndOr= 1'b1;
Hin= 1'b1;
end
Shift_L://Shift_L
begin
Rout= Yreg;
Jin= 1'b1;
end
Shift_R://Shift_R
begin
Rout= Yreg;
Shift= 1'b1;
Jin= 1'b1;
end
Mul://Mul
begin
Rout= Yreg;
Kin= 1'b1;
end
Div://Div
begin
Rout= Yreg;
MulDiv=1;
Kin= 1'b1;
end
Xor://Xor
begin
Rout= Yreg;
Lin= 1'b1;
end
NXor://NXor
begin
Rout= Yreg;
XorXnor=1;
Lin= 1'b1;
end
default: ;
endcase
T3: //define signals in time step T3
case (I)
add, sub: //add, sub
begin
Gout = 1'b1;
Rin = Xreg;
Done = 1'b1;
end
And,Or://and,or
begin
Hout= 1'b1;
Rin= Xreg;
Done = 1'b1;
end
Shift_L,Shift_R://Shift_L,Shift_R
begin
Jout= 1'b1;
Rin= Xreg;
Done = 1'b1;
end
Mul,Div://Mul,Div
begin
Kout= 1'b1;
Rin= Xreg;
Done = 1'b1;
end
Xor,NXor://Xor,NXor

begin
Lout= 1'b1;
Rin= Xreg;
Done = 1'b1;
end
default: ;
endcase
endcase
end
// Control FSM flip-flops
always @(posedge ClocK, negedge Resetn)
if (!Resetn)
Tstep_Q <= T0;
else
Tstep_Q <= Tstep_D;
regn reg_0 (BusWires, Rin[0], ClocK, R0);
regn reg_1 (BusWires, Rin[1], ClocK, R1);
regn reg_2 (BusWires, Rin[2], ClocK, R2);
regn reg_3 (BusWires, Rin[3], ClocK, R3);
regn reg_4 (BusWires, Rin[4], ClocK, R4);
regn reg_5 (BusWires, Rin[5], ClocK, R5);
regn reg_6 (BusWires, Rin[6], ClocK, R6);
regn reg_7 (BusWires, Rin[7], ClocK, R7);
regn reg_A (BusWires, Ain, ClocK, A);
regn reg_B (BusWires, Bin, ClocK, B);
regn reg_C (BusWires, Cin, ClocK, C);
regn reg_D (BusWires, Din, ClocK, D);
regn reg_E (BusWires, Ein, ClocK, E);
regn #(.n(10)) reg_IR (DIN[9:0], IRin, ClocK, IR);
// alu
always @(AddSub or A or BusWires)
begin
if (!AddSub)
Sum = A + BusWires;
else
Sum = A - BusWires;
end
regn reg_G (Sum, Gin, ClocK, G);
// alu_And_Or AndOr=0为与 AndOr=1为或
always @(AndOr or B or BusWires)
begin
if (!AndOr)
result = B & BusWires;
else
result = B | BusWires;
end
regn reg_H (result, Hin, ClocK, H);
// alu_Shift Shift=0左移，Shift=1右移
always @(Shift or C or BusWires)
begin
if (!Shift)
result2 = C << BusWires;
else
result2 = C >> BusWires;
end
regn reg_J (result2, Jin, ClocK, J);
// alu_MulDiv,MulDiv=0乘法,MulDiv=1除法
reg[20:0] trans;
always @(MulDiv or D or BusWires)
begin
if (!MulDiv)
begin
trans = D * BusWires;
result3=trans[9:0];
end
else
result3 = D / BusWires;
end
regn reg_K (result3, Kin, ClocK, K);
always @(XorXnor or E or BusWires)
begin
if (!XorXnor)
result4 = E ^ BusWires;
else
result4 = E ~^ BusWires;
end
regn reg_L (result4, Lin, ClocK, L);
//define the internal processor bus
assign Sel = {Rout, Gout, Hout, Jout, Kout, Lout, DINout};
always @(*)
begin
if (Sel == 14'b10000000000000)
BusWires = R0;
else if (Sel == 14'b01000000000000)
BusWires = R1;
else if (Sel == 14'b00100000000000)
BusWires = R2;
else if (Sel == 14'b00010000000000)
BusWires = R3;
else if (Sel == 14'b00001000000000)
BusWires = R4;
else if (Sel == 14'b00000100000000)
BusWires = R5;
else if (Sel == 14'b00000010000000)
BusWires = R6;
else if (Sel == 14'b00000001000000)
BusWires = R7;
else if (Sel == 14'b00000000100000)
BusWires = G;
else if (Sel == 14'b00000000010000)
BusWires = H;
else if (Sel == 14'b00000000001000)
BusWires = J;
else if (Sel == 14'b00000000000100)
BusWires = K;
else if (Sel == 14'b00000000000010)
BusWires = L;
else BusWires = DIN;
end
endmodule
module dec3to8(W, En, Y);
input [2:0] W;
input En;
output [0:7] Y;
reg [0:7] Y;
always @(W or En)
begin
if (En == 1)
case (W)
3'b000: Y = 8'b10000000;
3'b001: Y = 8'b01000000;
3'b010: Y = 8'b00100000;
3'b011: Y = 8'b00010000;
3'b100: Y = 8'b00001000;
3'b101: Y = 8'b00000100;
3'b110: Y = 8'b00000010;
3'b111: Y = 8'b00000001;
endcase
else
Y = 8'b00000000;
end
endmodule
module regn(R, Rin, ClocK, Q);
parameter n = 10;
input [n-1:0] R;
input Rin, ClocK;
output [n-1:0] Q;
reg [n-1:0] Q;
always @(posedge ClocK)
if (Rin)
Q <= R;
endmodule