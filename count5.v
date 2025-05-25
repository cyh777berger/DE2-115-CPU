module count5 (Resetn, Clock, Q);
input Resetn, Clock;
output reg [4:0] Q;
always @ (posedge Clock, negedge Resetn)
if (Resetn == 0)
Q <= 5'b00000;
else
Q <= Q + 1'b1;
endmodule