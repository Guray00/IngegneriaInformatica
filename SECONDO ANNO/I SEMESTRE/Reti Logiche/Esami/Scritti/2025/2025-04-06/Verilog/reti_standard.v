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
// Moltiplicando (x) e addendo (c) a N bit, moltiplicatore (y) a M bit.
// Risultato (m) su N+M bit
module mul_add_nat(
    x, y, c,
    m
);

    parameter N = 2;
    parameter M = 2;

    input [N-1:0] x, c;
    input [M-1:0] y;

    output [N+M-1:0] m;

    assign #1 m = (x * y) + c;

endmodule

// Comparatore per naturali in base 2.
// Ingressi a N bit.
// Il flag min vale 1 se a < b
// Il flag eq vale 1 se a == b
module comp_nat(
    a, b,
    min, eq 
);

    parameter N = 2;

    input [N-1:0] a, b;
    output min, eq;

    assign min = (a < b);
    assign eq = (a == b);

endmodule

// Valore assoluto di un numero intero
// L'ingresso x e' un numero intero su N bit
// L'uscita abs_x e' un numero naturale su N bit
module abs(
    x,
    abs_x
);
    parameter N = 8;

    input [N-1:0] x;
    output [N-1:0] abs_x;

    wire [N-1:0] neg_x;
    add #( .N(N) ) a_neg_x(
        .x(~x), .y(8'B0), .c_in(1'B1),
        .s(neg_x)
    );

    assign abs_x = (x[N-1] == 1) ? neg_x : x;
endmodule