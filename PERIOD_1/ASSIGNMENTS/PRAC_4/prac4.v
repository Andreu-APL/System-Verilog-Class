module pract4(
    input rst,clk,
    input  in,
    output reg out  

);


parameter idle =0 ,S1= 1, S2= 2, S3= 3,S4 = 4 , bad =5 ,gut = 6;

reg [2:0] current, next;


always @(posedge clk or posedge rst) begin
    if (rst)
        current <= idle;
    else 
        current <= next;
    
end

always @(*) begin
    case(current)
        idle:begin
            if (in == 1)
                next = S1;
            else 
                next = idle;
        end
        S1:begin
            if (in == 1)
                next = S2;
            else 
                next = bad;
        end
        S2:begin
            if (in == 1)
                next = S3;
            else 
                next = bad;
        end
        S3:begin
            if (in == 1)
                next = S4;
            else 
               next = bad;
        end
        S4:begin
            if (in == 1)
                next = gut;
            else 
                next = bad;
        end
        default:
            next = idle;
    endcase
end

         
    
always @(*) begin
    out = 0;
    case(current)
        gut:
        begin
            if (in)
                out = 1;
            else
                out = 0;
        end
        default:
                out = 0;
    endcase
    
end

endmodule