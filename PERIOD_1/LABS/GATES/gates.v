module gates(
    input a,b,
    output [7:0] out
);
  
  assign out[0] = !a;
  assign out[1] = !b;
  assign out[2] = a&b;
  assign out[3] = a|b;
  assign out[4] = !(a&b);
  assign out[5] = !(a|b);
  assign out[6] = a^b;
  assign out[7] = !(a^b);
 

    
endmodule