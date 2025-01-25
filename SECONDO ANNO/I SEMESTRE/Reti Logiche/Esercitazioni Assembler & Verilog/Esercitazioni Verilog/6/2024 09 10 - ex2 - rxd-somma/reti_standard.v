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

// Sottrattore valido sia per naturali che per interi, in base 2.
// Sia input che output sono a N cifre.
// Il circuito ha in uscita sia il borrow che l'overflow, sta all'utilizzatore collegare quello corretto.
module diff(
    x, y, b_in, 
    d, b_out, ow
);
    parameter N = 8;

    input [N-1:0] x, y;
    input b_in;

    output [N-1:0] d;
    output b_out, ow;

    assign #1 {b_out, d} = x - y - b_in;
    assign #1 ow = (x[N-1] == y[N-1]) ? 0   // diff di numeri concordi è sempre rappresentabile 
        : (x[N-1] == d[N-1]) ? 0 : 1;       // se discordi, solo se il risultato su N bit ha lo stesso segno del minuendo
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

// Convertitore di rappresentazione per interi, da complemento alla radice a modulo e segno
// Ingresso x a N bit, uscita abs_x a N bit, uscita sgn_x a 1 bit.
module CR_to_MS(x, sgn_x, abs_x);

parameter N = 8;

input [N-1:0] x;
output sgn_x;
output [N-1:0] abs_x;

assign sgn_x = x[N-1];
assign #1 abs_x = sgn_x ? ~x + 1 : x;

endmodule

// Convertitore di rappresentazione per interi, da complemento alla radice a modulo e segno
// Ingresso abs_x a N bit, ingresso sgn_x a 1 bit, uscita x a N bit, uscita ow da 1 bit.
module MS_to_CR(sgn_x, abs_x, x, ow);

parameter N = 8;

input sgn_x;
input [N-1:0] abs_x;

output [N-1:0] x;
output ow;

assign #1 x = sgn_x ? ~abs_x + 1 : abs_x;
assign #1 ow = abs_x[N-1] & (  (|abs_x[N-2:0]) | ~sgn_x ); // ow è 1 se abs_x > 2^n-1 oppure (abs_x = 2^n-1 e sgn_x = 0)

endmodule

// Moltiplicatore per interi
// Ingresso x su N bit, y su M bit, uscita m su N+M bit
module imul(x, y, m);

    parameter N = 8;
    parameter M = 8;

    input [N-1:0] x;
    input [M-1:0] y;

    output [N+M-1:0] m;

    wire sgn_x;
    assign sgn_x = x[N-1];
    wire [N-1:0] abs_x;
    assign abs_x = sgn_x ? ~x + 1 : x;

    wire sgn_y;
    assign sgn_y = y[M-1];
    wire [M-1:0] abs_y;
    assign abs_y = sgn_y ? ~y + 1 : y;


    wire [N+M-1:0] abs_m;
    assign abs_m = abs_x * abs_y;

    wire sgn_m;
    assign sgn_m = sgn_x ^ sgn_y;

    assign #1 m = sgn_m ? ~abs_m + 1 : abs_m;

endmodule
