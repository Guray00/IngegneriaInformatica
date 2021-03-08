// N bit inputs, N bit output + carry in and out
module add( 
    x, y, c_in,
    s, c_out    
);

    parameter N = 2;

    input [N-1:0] x, y;
    input c_in;

    output [N-1:0] s;
    output c_out;

    assign {c_out, s} = x + y + c_in;    

endmodule

// N and M bit inputs, N+M bit output
module mul_add(
    x, y, c,
    m
);

    parameter N = 2;
    parameter M = 2;

    input [N-1:0] x, c;
    input [M-1:0] y;

    output [N+M-1:0] m;

    assign m = (x * y) + c;

endmodule