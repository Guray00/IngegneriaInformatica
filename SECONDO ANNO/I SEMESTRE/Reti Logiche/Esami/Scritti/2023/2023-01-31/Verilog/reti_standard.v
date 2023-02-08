// Sommatore valido sia per naturali che per interi, in base 2.
// Sia input che output sono a N cifre.
// Il circuito ha in uscita sia il carry che l'overflow, sta all'utilizzatore collegare quello corretto.
module add( 
    x, y, c_in,
    s, c_out, ow    
);
    parameter N = 2;

    input [N-1:0] x, y;
    input c_in;

    output [N-1:0] s;
    output c_out, ow;

    assign #1 {c_out, s} = x + y + c_in;
    assign #1 ow = (x[N-1] == y[N-1]) && (x[N-1] != s[N-1]);

endmodule

// Moltiplicatore con addizionatore per naturali in base 2.
// Moltiplicando (x) e addendo (c) a 4 bit, moltiplicatore (y) a 4 bit.
// Risultato (m) su 8 bit
module mul_add_nat(
    x, y, c,
    m
);

    localparam N = 4;
    localparam M = 4;

    input [N-1:0] x, c;
    input [M-1:0] y;

    output [N+M-1:0] m;

    assign #1 m = (x * y) + c;

endmodule
