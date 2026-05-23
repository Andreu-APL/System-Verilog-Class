module FFD (D,CLK,RST,Q);

input D;
input CLK;
input RST;
output reg Q;

always @(posedge CLK or posedge RST)

begin 
    if (RST == 1)
        Q <= 0;
    else
        Q <= D;
end
endmodule