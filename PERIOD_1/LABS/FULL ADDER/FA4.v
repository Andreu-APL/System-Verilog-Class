module FA4(

    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] s,
    output cout4);

    wire cout1,cout2,cout3;

    fulladder fa0 (a[0], b[0], cin, s[0], cout1);
    fulladder fa1 (a[1], b[1], cout1, s[1], cout2);
    fulladder fa2 (a[2], b[2], cout2, s[2], cout3);
    fulladder fa3 (a[3], b[3], cout3, s[3], cout4);

endmodule   