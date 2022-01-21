// Moltiplicatore con addizionatore per naturali in base 2
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