module Soluzione(
    X, Y,
    S, c_out, ow
);
    input [7:0] X, Y;
    output [7:0] S;
    output c_out, ow;

    wire [8:0] m;
    mul_add_nat #( .N(8), .M(1) ) p2 (
        .x(X), .y(1'B1), .c(Y),
        .m(m)
    );

    assign S = m[7:0];
    assign c_out = m[8];
    assign #1 ow = ( ~X[7] & ~Y[7] & S[7] ) | ( X[7] & Y[7] & ~S[7] );

endmodule