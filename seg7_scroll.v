module hex7seg(x,seg);
input [3:0] x ;
output[6:0] seg;
reg [6:0] seg;
always @(*)
case(x)
0: seg= 7'b1000000;
1: seg= 7'b1111001;
2: seg= 7'b0100100;
3: seg= 7'b0110000;
4: seg= 7'b0011001;
5: seg= 7'b0010010;
6: seg= 7'b0000010;
7: seg= 7'b1111000;
8: seg= 7'b0000000;
9: seg= 7'b0010000;
'hA: seg= 7'b0001000;
'hB: seg= 7'b0000011;
'hC: seg= 7'b1000110;
'hD: seg= 7'b0100001;
'hE: seg= 7'b0000110;
'hF: seg= 7'b0001110;
default:
seg= 7'b1000000;// 0
endcase
endmodule